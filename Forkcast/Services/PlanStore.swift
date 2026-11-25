import Foundation
import SwiftData
import Observation
import ForkcastCore

/// One row in the Edit week sheet.
struct EditableMeal: Identifiable, Hashable {
    let id: UUID
    var recipeId: String
    var servings: Double
    var isCooked: Bool
    var cookedAt: Date?

    init(id: UUID = UUID(), recipeId: String, servings: Double, isCooked: Bool = false, cookedAt: Date? = nil) {
        self.id = id
        self.recipeId = recipeId
        self.servings = servings
        self.isCooked = isCooked
        self.cookedAt = cookedAt
    }
}

/// The current week: generating, swapping, editing, grocery checks and extras.
/// The grocery list is always DERIVED from the plan; only check states persist.
@MainActor
@Observable
final class PlanStore {
    let context: ModelContext
    let catalog: FoodCatalog
    private let planner: MealPlanner
    let repository: RecipeRepository
    let library: LibraryStore
    let profileStore: ProfileStore

    private(set) var currentPlan: WeekPlan?
    private(set) var currentPlanIsSaved = false
    private(set) var groceryList: GroceryList = .empty
    /// Cost per meal, aligned with `meals`.
    private(set) var mealCosts: [Double] = []
    private(set) var checkedKeys: Set<String> = []
    static let usualsListID = "usuals"
    private var allExtras: [ExtraGroceryItem] = []
    private(set) var groceryCollections: [GroceryCollection] = []
    private var basketPortions: [MealPortion] = []
    private(set) var recipesByGroceryKey: [String: [Recipe]] = [:]

    var extras: [ExtraGroceryItem] { extras(for: nil) }

    func extras(for listID: String?) -> [ExtraGroceryItem] {
        allExtras.filter { $0.listID == listID }
    }
    private(set) var isGenerating: Bool = false
    /// Bumped on every change so views can animate.
    private(set) var revision: Int = 0

    init(context: ModelContext, catalog: FoodCatalog, repository: RecipeRepository, library: LibraryStore, profileStore: ProfileStore) {
        self.context = context
        self.catalog = catalog
        self.planner = MealPlanner(catalog: catalog)
        self.repository = repository
        self.library = library
        self.profileStore = profileStore
        reload()
    }

    // MARK: - Loading

    func reload() {
        var descriptor = FetchDescriptor<WeekPlan>(sortBy: [SortDescriptor(\WeekPlan.weekStartDate, order: .reverse), SortDescriptor(\WeekPlan.createdAt, order: .reverse)])
        descriptor.fetchLimit = 1
        currentPlan = (try? context.fetch(descriptor))?.first
        currentPlanIsSaved = currentPlan != nil
        let extrasDescriptor = FetchDescriptor<ExtraGroceryItem>(sortBy: [SortDescriptor(\ExtraGroceryItem.createdAt, order: .forward)])
        allExtras = (try? context.fetch(extrasDescriptor)) ?? []
        groceryCollections = (try? context.fetch(FetchDescriptor<GroceryCollection>(
            sortBy: [SortDescriptor(\.createdAt)]
        ))) ?? []
        recompute()
    }

    var meals: [PlannedMeal] { currentPlan?.sortedMeals ?? [] }

    var hasPlan: Bool { currentPlan != nil }

    var total: Double { groceryList.total }

    var budget: Double { profileStore.weeklyBudget }

    var overBudgetBy: Double { max(0, total - budget) }

    var underBudgetBy: Double { max(0, budget - total) }

    func recipe(for meal: PlannedMeal) -> Recipe? {
        repository.recipe(id: meal.recipeId)
    }

    func cost(for meal: PlannedMeal) -> Double {
        guard let index = meals.firstIndex(where: { $0.persistentModelID == meal.persistentModelID }), index < mealCosts.count else { return 0 }
        return mealCosts[index]
    }

    /// Every meal on a day, in meal order.
    func meals(on date: Date) -> [PlannedMeal] {
        meals.filter { WeekMath.gregorian.isDate($0.date, inSameDayAs: date) }
    }

    /// The meals of one type on a day (usually one).
    func meals(on date: Date, type: MealType) -> [PlannedMeal] {
        meals(on: date).filter { !$0.isSide && $0.mealType == type }
    }

    /// The first meal of a type on a day (dinner by default).
    func meal(on date: Date, type: MealType = .dinner) -> PlannedMeal? {
        meals(on: date, type: type).first
    }

    /// Meal types the Plan tab shows: the ones the user plans, plus any already in this week's plan.
    var plannedMealTypes: [MealType] {
        MealType.ordered(profileStore.mealTypes.union(meals.filter { !$0.isSide }.map(\.mealType)))
    }

    /// True when only dinners are planned (the Plan tab then shows one card per day, as before).
    var isDinnersOnly: Bool { plannedMealTypes == [.dinner] }

    /// The seven days of the current plan.
    var weekDays: [Date] {
        guard let plan = currentPlan else { return [] }
        return WeekMath.days(from: plan.weekStartDate)
    }

    func recompute() {
        let current: [PlannedMeal] = meals
        var portions: [MealPortion] = []
        var indexMap: [Int] = []
        var portionPositions: [PersistentIdentifier: Int] = [:]
        for (index, meal) in current.enumerated() {
            guard let recipe = repository.recipe(id: meal.recipeId) else { continue }
            let source = leftoversSource(for: meal)
            let cookDate = source?.date ?? meal.date
            let batchIndex = source.flatMap { portionPositions[$0.persistentModelID] }
            portionPositions[meal.persistentModelID] = portions.count
            portions.append(MealPortion(recipe: recipe, servings: meal.servings, weekday: WeekMath.isoWeekday(cookDate),
                                        batchWithMealIndex: batchIndex))
            indexMap.append(index)
        }
        basketPortions = portions
        var associations: [String: [Recipe]] = [:]
        var seenRecipes: Set<String> = []
        for portion in portions where seenRecipes.insert(portion.recipe.id).inserted {
            let keys = Set(portion.recipe.ingredients.map { GroceryAggregator.ingredientKey($0, catalog: catalog) })
            for key in keys { associations[key, default: []].append(portion.recipe) }
        }
        recipesByGroceryKey = associations
        let list: GroceryList = GroceryAggregator.aggregate(meals: portions, catalog: catalog, pricing: profileStore.pricing, unitSystem: profileStore.unitSystem, onHand: currentOnHand)
        var costs: [Double] = Array(repeating: 0, count: current.count)
        for (position, index) in indexMap.enumerated() where position < list.mealCosts.count {
            costs[index] = list.mealCosts[position]
        }
        groceryList = list
        mealCosts = costs
        var checked: Set<String> = []
        for check in currentPlan?.groceryChecks ?? [] where check.isChecked {
            checked.insert(check.ingredientKey)
        }
        checkedKeys = checked
        revision += 1
    }

    /// Store comparisons use the same recipes, portions, and pantry as the main list.
    func estimatedBasket(for store: Store) -> GroceryEstimate? {
        let priced = GroceryAggregator.aggregate(
            meals: basketPortions, catalog: catalog, pricing: PriceContext(country: profileStore.country, store: store),
            unitSystem: profileStore.unitSystem, onHand: currentOnHand
        )
        return completeEstimate(for: priced)
    }

    var basketEstimate: GroceryEstimate? { completeEstimate(for: groceryList) }

    private func completeEstimate(for list: GroceryList) -> GroceryEstimate? {
        guard !basketPortions.isEmpty, list.allItems.allSatisfy(\.hasPrice),
              list.pantryStaples.allSatisfy({ $0.hasPrice || $0.cost == 0 }) else { return nil }
        return GroceryEstimate(list.total)
    }

    // MARK: - Generating

    private func history(relativeTo start: Date, excluding plan: WeekPlan?) -> [String: Int] {
        let descriptor = FetchDescriptor<WeekPlan>(sortBy: [SortDescriptor(\WeekPlan.weekStartDate, order: .reverse)])
        let plans: [WeekPlan] = (try? context.fetch(descriptor)) ?? []
        var result: [String: Int] = [:]
        for past in plans where past.persistentModelID != plan?.persistentModelID && past.weekStartDate < start {
            let weeks: Int = max(1, WeekMath.weeksBetween(past.weekStartDate, start))
            guard weeks <= 6 else { continue }
            for meal in past.meals ?? [] {
                result[meal.recipeId] = min(result[meal.recipeId] ?? Int.max, weeks)
            }
        }
        return result
    }

    private func autoPlanPool() -> [Recipe] {
        let include: Bool = profileStore.profile?.includeUserRecipesInPlans ?? true
        return include ? repository.allRecipes : repository.bundledRecipes
    }

    /// Pantry answers from onboarding count only for the week they were given in
    /// (after that the user has probably used them up).
    func onHand(forWeekStarting start: Date) -> Set<String> {
        let answers: OnboardingAnswers = profileStore.profile?.onboardingAnswers ?? OnboardingAnswers()
        guard let pantryWeek = answers.pantryWeekStart,
              WeekMath.gregorian.isDate(pantryWeek, inSameDayAs: start) else { return [] }
        return Set(answers.pantry)
    }

    func updatePantry(_ ingredients: Set<String>) {
        guard let profile = profileStore.profile else { return }
        var answers = profile.onboardingAnswers
        answers.pantry = ingredients.sorted()
        answers.pantryWeekStart = ingredients.isEmpty ? nil : currentPlan?.weekStartDate ?? WeekMath.gregorian.startOfDay(for: Date())
        profile.onboardingAnswers = answers
        profileStore.save()
        recompute()
    }

    var currentOnHand: Set<String> {
        onHand(forWeekStarting: currentPlan?.weekStartDate ?? Date())
    }

    func makeRequest(slots: [PlanSlot], seed: UInt64, locked: [Int: LockedMeal], start: Date, plan: WeekPlan?, recipes: [Recipe]? = nil) -> PlannerRequest {
        var rules: PlannerProfile = profileStore.plannerProfile
        rules.onHand = onHand(forWeekStarting: start)
        let now = Date()
        return PlannerRequest(
            profile: rules,
            recipes: recipes ?? autoPlanPool(),
            feedback: library.summary,
            history: history(relativeTo: start, excluding: plan),
            slots: slots,
            servings: profileStore.defaultServings,
            budget: profileStore.weeklyBudget,
            pricing: profileStore.pricing,
            unitSystem: profileStore.unitSystem,
            seed: seed,
            locked: locked,
            tasteEvents: RecipeBehaviorLog.events(in: context, asOf: now),
            tasteRecipes: repository.userRecipes,
            tasteAsOf: now,
            savedRecipeIds: Set(library.savedIds)
        )
    }

    private func runPlanner(_ request: PlannerRequest) async -> PlanResult {
        let planner = self.planner
        return await Task.detached(priority: .userInitiated) {
            planner.plan(request)
        }.value
    }

    /// Builds a brand-new week starting on `start` (default: today).
    @discardableResult
    func generatePlan(startingAt start: Date = Date()) async -> PlanResult {
        isGenerating = true
        defer { isGenerating = false }
        let weekStart: Date = WeekMath.gregorian.startOfDay(for: start)
        let slots: [PlanSlot] = WeekMath.slots(from: weekStart, cookingDays: profileStore.cookingDays, mealTypes: profileStore.mealTypes)
        let request: PlannerRequest = makeRequest(slots: slots, seed: SeededRandom.seed(weekStart: weekStart, regeneration: 0), locked: [:], start: weekStart, plan: nil)
        let result: PlanResult = await runPlanner(request)
        applyNewPlan(result, weekStart: weekStart)
        return result
    }

    /// Synchronous variant for previews and the debug menu.
    func generatePlanNow(startingAt start: Date = Date()) {
        let weekStart: Date = WeekMath.gregorian.startOfDay(for: start)
        let slots: [PlanSlot] = WeekMath.slots(from: weekStart, cookingDays: profileStore.cookingDays, mealTypes: profileStore.mealTypes)
        let request: PlannerRequest = makeRequest(slots: slots, seed: SeededRandom.seed(weekStart: weekStart, regeneration: 0), locked: [:], start: weekStart, plan: nil)
        let result: PlanResult = planner.plan(request)
        applyNewPlan(result, weekStart: weekStart)
    }

    private func applyNewPlan(_ result: PlanResult, weekStart: Date) {
        let plan = WeekPlan(weekStartDate: weekStart, storeIdSnapshot: profileStore.profile?.storeId ?? "", budgetSnapshot: profileStore.weeklyBudget)
        context.insert(plan)
        insertDrafts(result.meals, into: plan, keeping: [:])
        currentPlan = plan
        saveAndRefresh()
    }

    /// Next week: starts the day after the current plan ends (or today, if later).
    func generateNextWeek() async {
        let today: Date = WeekMath.gregorian.startOfDay(for: Date())
        var start: Date = today
        if let plan = currentPlan, let next = WeekMath.gregorian.date(byAdding: .day, value: 7, to: plan.weekStartDate), next > today {
            start = next
        }
        await generatePlan(startingAt: start)
    }

    /// Regenerate. Optionally keep cooked and liked meals in their days.
    func regenerate(keepCookedAndLiked: Bool) async {
        guard let plan = currentPlan else {
            await generatePlan()
            return
        }
        isGenerating = true
        defer { isGenerating = false }
        plan.regenerationCount += 1
        let slots: [PlanSlot] = WeekMath.slots(from: plan.weekStartDate, cookingDays: profileStore.cookingDays, mealTypes: profileStore.mealTypes)
        let liked: Set<String> = library.summary.liked
        var locked: [Int: LockedMeal] = [:]
        var keepMeals: [PlannedMeal] = []
        for meal in plan.sortedMeals where !meal.isSide {
            let keep: Bool = keepCookedAndLiked && (meal.isCooked || liked.contains(meal.recipeId))
            if keep, let slot = slots.first(where: { WeekMath.gregorian.isDate($0.date, inSameDayAs: meal.date) && $0.mealType == meal.mealType && locked[$0.index] == nil }) {
                locked[slot.index] = LockedMeal(recipeId: meal.recipeId, servings: meal.servings)
                keepMeals.append(meal)
            } else if keep {
                keepMeals.append(meal)
            }
        }
        for meal in keepMeals {
            guard let source = leftoversSource(for: meal),
                  let servingSlot = slots.first(where: { $0.date == meal.date && $0.mealType == meal.mealType }),
                  let sourceSlot = slots.first(where: { $0.date == source.date && $0.mealType == source.mealType }),
                  let existing = locked[servingSlot.index], locked[sourceSlot.index]?.recipeId == source.recipeId else { continue }
            locked[servingSlot.index] = LockedMeal(recipeId: existing.recipeId, servings: existing.servings,
                                                   leftoversFromSlotIndex: sourceSlot.index)
        }
        let seed: UInt64 = SeededRandom.seed(weekStart: plan.weekStartDate, regeneration: plan.regenerationCount)
        let request: PlannerRequest = makeRequest(slots: slots, seed: seed, locked: locked, start: plan.weekStartDate, plan: plan)
        let result: PlanResult = await runPlanner(request)

        let keptSlots = Set(result.meals.filter { $0.reason == .kept }.map(\.slotIndex))
        var keptBySlot: [Int: PlannedMeal] = [:]
        for meal in keepMeals {
            if let slot = slots.first(where: { $0.mealType == meal.mealType && $0.date == meal.date }),
               keptSlots.contains(slot.index), keptBySlot[slot.index] == nil,
               locked[slot.index]?.recipeId == meal.recipeId {
                keptBySlot[slot.index] = meal
            }
        }
        let offSchedule = keepMeals.filter { meal in
            guard !slots.contains(where: { $0.mealType == meal.mealType && $0.date == meal.date }),
                  let recipe = recipe(for: meal) else { return false }
            return planner.passesHardFilters(recipe, profile: request.profile, notForMe: request.feedback.notForMe, ignoreTime: true)
        }
        let sides = (plan.meals ?? []).filter { meal in
            guard meal.isSide, let recipe = recipe(for: meal) else { return false }
            return planner.passesHardFilters(recipe, profile: request.profile, notForMe: request.feedback.notForMe, ignoreTime: true)
        }
        let keepIds = Set((Array(keptBySlot.values) + offSchedule + sides).map(\.persistentModelID))
        for meal in plan.meals ?? [] where !keepIds.contains(meal.persistentModelID) {
            unlinkBatch(containing: meal)
            context.delete(meal)
        }
        insertDrafts(result.meals, into: plan, keeping: keptBySlot)
        saveAndRefresh()
    }

    private func insertDrafts(_ drafts: [PlannedMealDraft], into plan: WeekPlan, keeping kept: [Int: PlannedMeal]) {
        var models = kept
        let batchSlots = Set(drafts.compactMap(\.leftoversFromSlotIndex))
        for (index, draft) in drafts.enumerated() {
            let meal: PlannedMeal
            if let existing = models[draft.slotIndex] {
                meal = existing
            } else {
                meal = PlannedMeal(date: draft.date, recipeId: draft.recipeId, servings: draft.servings, orderIndex: index, mealType: draft.mealType)
                meal.userRecipe = repository.userRecipeModel(id: draft.recipeId)
                meal.weekPlan = plan
                context.insert(meal)
                RecipeBehaviorLog.record(.planned, recipeId: meal.recipeId, in: context, mealID: meal.ensurePlannerMealID())
                models[draft.slotIndex] = meal
            }
            let reason: PlannedMealReason
            if draft.leftoversFromSlotIndex != nil {
                reason = .plannedLeftovers
            } else if batchSlots.contains(draft.slotIndex) {
                reason = .batchCooking
            } else {
                reason = draft.reason
            }
            meal.planningReasonData = try? JSONEncoder().encode(reason)
        }
        for draft in drafts {
            models[draft.slotIndex]?.leftoversFromMealID = draft.leftoversFromSlotIndex.flatMap { models[$0]?.ensurePlannerMealID() }
        }
    }

    private func leftoversSource(for meal: PlannedMeal) -> PlannedMeal? {
        guard let sourceId = meal.leftoversFromMealID else { return nil }
        return (meal.weekPlan?.meals ?? []).first {
            let calendar = WeekMath.gregorian
            return $0.plannerMealID == sourceId && $0.recipeId == meal.recipeId && $0.mealType == meal.mealType
                && (1...4).contains(calendar.dateComponents([.day], from: $0.date, to: meal.date).day ?? 0)
        }
    }

    func servingsToCook(for meal: PlannedMeal) -> Double {
        (meal.weekPlan?.meals ?? []).reduce(meal.servings) { total, other in
            leftoversSource(for: other)?.persistentModelID == meal.persistentModelID ? total + other.servings : total
        }
    }

    private func unlinkBatch(containing meal: PlannedMeal) {
        meal.leftoversFromMealID = nil
        meal.planningReasonData = nil
        guard let id = meal.plannerMealID else { return }
        for other in meal.weekPlan?.meals ?? [] where other.leftoversFromMealID == id {
            other.leftoversFromMealID = nil
            other.planningReasonData = nil
        }
    }

    // MARK: - Swaps and edits

    /// Top 3 rule-following swaps for a meal, with cost change.
    func alternatives(for meal: PlannedMeal) async -> [SwapSuggestion] {
        let current: [PlannedMeal] = meals
        guard let targetIndex = current.firstIndex(where: { $0.persistentModelID == meal.persistentModelID }) else { return [] }
        var slots: [PlanSlot] = []
        var assignment: [Int: LockedMeal] = [:]
        for (index, item) in current.enumerated() {
            slots.append(PlanSlot(index: index, date: item.date, weekday: WeekMath.isoWeekday(item.date), mealType: item.mealType))
            let source = leftoversSource(for: item).flatMap { batch in
                current.firstIndex { $0.persistentModelID == batch.persistentModelID }
            }
            assignment[index] = LockedMeal(recipeId: item.recipeId, servings: item.servings, leftoversFromSlotIndex: source)
        }
        let start: Date = currentPlan?.weekStartDate ?? Date()
        let seed: UInt64 = SeededRandom.seed(weekStart: start, regeneration: (currentPlan?.regenerationCount ?? 0) + 101)
        // Swaps may use any of the user's own recipes.
        let request: PlannerRequest = makeRequest(slots: slots, seed: seed, locked: [:], start: start, plan: currentPlan, recipes: repository.allRecipes)
        let planner = self.planner
        let index: Int = targetIndex
        return await Task.detached(priority: .userInitiated) {
            planner.alternatives(for: index, current: assignment, request: request)
        }.value
    }

    /// Basket change if `meal` became `recipeId` (for saved-recipe swap rows).
    func costDelta(replacing meal: PlannedMeal, with recipeId: String) -> Double {
        guard let newRecipe = repository.recipe(id: recipeId) else { return 0 }
        var portions: [MealPortion] = []
        for item in meals {
            let recipe: Recipe? = item.persistentModelID == meal.persistentModelID ? newRecipe : repository.recipe(id: item.recipeId)
            guard let recipe else { continue }
            portions.append(MealPortion(recipe: recipe, servings: item.servings, weekday: WeekMath.isoWeekday(item.date)))
        }
        let newTotal: Double = GroceryAggregator.aggregate(meals: portions, catalog: catalog, pricing: profileStore.pricing, unitSystem: profileStore.unitSystem, onHand: currentOnHand).total
        return newTotal - total
    }

    func swap(_ meal: PlannedMeal, to recipeId: String, servings: Double? = nil) {
        if meal.recipeId == recipeId {
            guard let servings, servings != meal.servings else { return }
            unlinkBatch(containing: meal)
            meal.servings = servings
            saveAndRefresh()
            return
        }
        let id = meal.ensurePlannerMealID()
        RecipeBehaviorLog.record(.swappedAway, recipeId: meal.recipeId, in: context, mealID: id)
        RecipeBehaviorLog.record(.chosenAsSwap, recipeId: recipeId, in: context, mealID: id)
        unlinkBatch(containing: meal)
        // A replacement is a new exposure and gets its own skip/cook identity.
        meal.plannerMealID = nil
        RecipeBehaviorLog.record(.planned, recipeId: recipeId, in: context, mealID: meal.ensurePlannerMealID())
        meal.recipeId = recipeId
        if let servings { meal.servings = servings }
        meal.userRecipe = repository.userRecipeModel(id: recipeId)
        meal.isCooked = false
        meal.cookedAt = nil
        saveAndRefresh()
    }

    /// Adds a meal to a day. The meal type defaults to the recipe's own (a breakfast recipe lands as breakfast).
    func addMeal(recipeId: String, on date: Date, servings: Double? = nil, mealType: MealType? = nil, isSide: Bool = false) {
        guard let plan = currentPlan ?? createEmptyPlan() else { return }
        let type: MealType = mealType ?? repository.recipe(id: recipeId)?.mealType ?? .dinner
        let meal = PlannedMeal(date: WeekMath.gregorian.startOfDay(for: date), recipeId: recipeId, servings: servings ?? profileStore.defaultServings, orderIndex: meals.count, mealType: type)
        meal.userRecipe = repository.userRecipeModel(id: recipeId)
        meal.isSide = isSide
        meal.weekPlan = plan
        context.insert(meal)
        RecipeBehaviorLog.record(.planned, recipeId: meal.recipeId, in: context, mealID: meal.ensurePlannerMealID())
        saveAndRefresh()
    }

    private func createEmptyPlan() -> WeekPlan? {
        let start: Date = WeekMath.gregorian.startOfDay(for: Date())
        let plan = WeekPlan(weekStartDate: start, storeIdSnapshot: profileStore.profile?.storeId ?? "", budgetSnapshot: profileStore.weeklyBudget)
        context.insert(plan)
        currentPlan = plan
        return plan
    }

    func removeMeal(_ meal: PlannedMeal) {
        unlinkBatch(containing: meal)
        context.delete(meal)
        saveAndRefresh()
    }

    func setServings(_ meal: PlannedMeal, servings: Double) {
        meal.servings = min(12, max(1, servings))
        saveAndRefresh()
    }

    func setCooked(_ meal: PlannedMeal, cooked: Bool) {
        guard meal.isCooked != cooked else { return }
        let now = Date()
        meal.isCooked = cooked
        meal.cookedAt = cooked ? now : nil
        if leftoversSource(for: meal) == nil {
            let id = meal.ensurePlannerMealID()
            for row in RecipeBehaviorLog.matchingMeal(id, in: context) {
                let kind = row.event?.kind
                if kind == .skipped || (!cooked && (kind == .cooked || kind == .cookedAgain)) {
                    context.delete(row)
                }
            }
            if cooked {
                RecipeBehaviorLog.recordCook(recipeId: meal.recipeId, in: context, date: now, mealID: id)
            }
        }
        saveAndRefresh()
    }

    /// An explicit cook from the recipe screen can also happen outside a plan.
    func markCooked(recipeId: String, meal: PlannedMeal?) {
        if let meal, !meal.isCooked {
            setCooked(meal, cooked: true)
        } else if meal.flatMap({ leftoversSource(for: $0) }) == nil {
            RecipeBehaviorLog.recordCook(recipeId: recipeId, in: context, date: Date(), mealID: nil)
            try? context.save()
        }
    }

    func isInPlan(_ recipeId: String) -> Bool {
        meals.contains { $0.recipeId == recipeId }
    }

    func plannedMeal(for recipeId: String, id: UUID? = nil) -> PlannedMeal? {
        if let id { return meals.first { $0.plannerMealID == id && $0.recipeId == recipeId } }
        return meals.first { $0.recipeId == recipeId && !$0.isCooked } ?? meals.first { $0.recipeId == recipeId }
    }

    /// Rows for the Edit week sheet: one per day of the plan window, for one meal type.
    func editRows(for type: MealType = .dinner) -> [EditableMeal?] {
        weekDays.map { day in
            guard let meal = meal(on: day, type: type) else { return nil }
            return EditableMeal(id: meal.ensurePlannerMealID(), recipeId: meal.recipeId, servings: meal.servings, isCooked: meal.isCooked, cookedAt: meal.cookedAt)
        }
    }

    /// Saves the Edit week sheet for one meal type (rows aligned with `weekDays`).
    /// Meals of other types are left alone.
    func applyEdit(rows: [EditableMeal?], for type: MealType = .dinner) {
        guard let plan = currentPlan else { return }
        let days: [Date] = weekDays
        let existing = (plan.meals ?? []).filter { !$0.isSide && $0.mealType == type }
        var byID: [UUID: PlannedMeal] = [:]
        for meal in existing { byID[meal.ensurePlannerMealID()] = meal }
        var retained: Set<UUID> = []
        for (index, row) in rows.enumerated() where index < days.count {
            guard let row else { continue }
            if let meal = byID[row.id], meal.recipeId == row.recipeId {
                if meal.date != days[index] { unlinkBatch(containing: meal) }
                meal.date = days[index]
                meal.orderIndex = index
                meal.servings = row.servings
                retained.insert(row.id)
            } else {
                let meal = PlannedMeal(date: days[index], recipeId: row.recipeId, servings: row.servings, orderIndex: index, mealType: type)
                meal.isCooked = row.isCooked
                meal.cookedAt = row.cookedAt
                meal.userRecipe = repository.userRecipeModel(id: row.recipeId)
                meal.weekPlan = plan
                context.insert(meal)
                RecipeBehaviorLog.record(.planned, recipeId: meal.recipeId, in: context, mealID: meal.ensurePlannerMealID())
            }
        }
        for (id, meal) in byID where !retained.contains(id) {
            unlinkBatch(containing: meal)
            context.delete(meal)
        }
        saveAndRefresh()
    }

    /// Danger zone: delete this week's plan.
    func resetCurrentPlan() {
        if let plan = currentPlan {
            context.delete(plan)
        }
        currentPlan = nil
        saveAndRefresh()
        reload()
    }

    // MARK: - Weekly feedback

    /// True on or after the plan's last dinner, until feedback is given or skipped.
    var needsWeeklyFeedback: Bool {
        guard let plan = currentPlan, !plan.feedbackGiven, let last = meals.last else { return false }
        let today: Date = WeekMath.gregorian.startOfDay(for: Date())
        return WeekMath.gregorian.startOfDay(for: last.date) <= today
    }

    func markFeedbackGiven() {
        currentPlan?.feedbackGiven = true
        saveAndRefresh()
    }

    // MARK: - Groceries

    func isChecked(_ key: String) -> Bool { checkedKeys.contains(key) }

    func toggleChecked(_ key: String) {
        guard let plan = currentPlan else { return }
        if let existing = (plan.groceryChecks ?? []).first(where: { $0.ingredientKey == key }) {
            existing.isChecked.toggle()
        } else {
            let check = GroceryCheck(ingredientKey: key, isChecked: true)
            check.weekPlan = plan
            context.insert(check)
        }
        saveAndRefresh(widget: false)
    }

    func uncheckAll() {
        for check in currentPlan?.groceryChecks ?? [] {
            check.isChecked = false
        }
        for extra in extras {
            extra.isChecked = false
        }
        saveAndRefresh(widget: false)
    }

    var checkedCount: Int {
        groceryList.allItems.filter { checkedKeys.contains($0.key) }.count
    }

    var allGroceriesChecked: Bool {
        let items: [GroceryItem] = groceryList.allItems
        return !items.isEmpty && items.allSatisfy { checkedKeys.contains($0.key) } && extras.allSatisfy { $0.isChecked }
    }

    func addExtra(name: String, quantity: String, to listID: String? = nil) {
        let trimmed: String = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        context.insert(ExtraGroceryItem(name: trimmed, quantityText: quantity.trimmingCharacters(in: .whitespacesAndNewlines), listID: listID))
        try? context.save()
        reload()
    }

    func createGroceryCollection(_ title: String) -> String? {
        let name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }
        let collection = GroceryCollection(title: name)
        context.insert(collection)
        do {
            try context.save()
        } catch {
            context.delete(collection)
            return nil
        }
        reload()
        return collection.id
    }

    func toggleExtra(_ item: ExtraGroceryItem) {
        item.isChecked.toggle()
        saveAndRefresh(widget: false)
    }

    func deleteExtra(_ item: ExtraGroceryItem) {
        context.delete(item)
        try? context.save()
        reload()
    }

    /// Adds every ingredient of a recipe (not in the plan) to Extras.
    func addRecipeToExtras(_ recipe: Recipe, servings: Double, to listID: String? = nil) {
        let scale: Double = servings / Double(max(1, recipe.baseServings))
        for item in recipe.ingredients {
            let ingredient: Ingredient? = item.ingredientId.flatMap { catalog.ingredient(id: $0) }
            if listID == nil, let ingredient, ingredient.isPantryStaple || currentOnHand.contains(ingredient.id) { continue }
            let name: String = ingredient?.displayName(for: profileStore.unitSystem) ?? item.name ?? ""
            let quantity: String = QuantityFormatter.string(amount: item.amount * scale, unit: item.unit, system: profileStore.unitSystem, ingredient: ingredient)
            guard !name.isEmpty else { continue }
            context.insert(ExtraGroceryItem(name: name.capitalizedFirst, quantityText: quantity, listID: listID, ingredientID: ingredient?.id))
        }
        try? context.save()
        reload()
    }

    func shareText(title: String, listID: String? = nil) -> String {
        GroceryTextExporter.plainText(
            list: listID == nil ? groceryList : .empty,
            title: title,
            checkedKeys: listID == nil ? checkedKeys : [],
            extras: extras(for: listID).map { (name: $0.name, quantity: $0.quantityText, checked: $0.isChecked) },
            includesEstimate: listID == nil && basketEstimate != nil,
            formatMoney: { [profileStore] amount in profileStore.formatMoney(amount) }
        )
    }

    // MARK: - Persistence

    func saveAndRefresh(widget: Bool = true) {
        do {
            try context.save()
            currentPlanIsSaved = currentPlan != nil
        } catch {
            currentPlanIsSaved = false
            PersistenceController.logger.error("Plan save failed: \(String(describing: error), privacy: .public)")
        }
        recompute()
        if widget {
            WidgetSnapshotWriter.write(meals: meals, repository: repository)
        }
    }
}
