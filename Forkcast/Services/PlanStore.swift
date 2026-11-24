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
    let repository: RecipeRepository
    let library: LibraryStore
    let profileStore: ProfileStore

    private(set) var currentPlan: WeekPlan?
    private(set) var groceryList: GroceryList = .empty
    /// Cost per meal, aligned with `meals`.
    private(set) var mealCosts: [Double] = []
    private(set) var checkedKeys: Set<String> = []
    private(set) var extras: [ExtraGroceryItem] = []
    private(set) var isGenerating: Bool = false
    /// Bumped on every change so views can animate.
    private(set) var revision: Int = 0

    init(context: ModelContext, catalog: FoodCatalog, repository: RecipeRepository, library: LibraryStore, profileStore: ProfileStore) {
        self.context = context
        self.catalog = catalog
        self.repository = repository
        self.library = library
        self.profileStore = profileStore
        reload()
    }

    // MARK: - Loading

    func reload() {
        var descriptor = FetchDescriptor<WeekPlan>(sortBy: [SortDescriptor(\WeekPlan.weekStartDate, order: .reverse)])
        descriptor.fetchLimit = 1
        currentPlan = (try? context.fetch(descriptor))?.first
        let extrasDescriptor = FetchDescriptor<ExtraGroceryItem>(sortBy: [SortDescriptor(\ExtraGroceryItem.createdAt, order: .forward)])
        extras = (try? context.fetch(extrasDescriptor)) ?? []
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

    func meal(on date: Date) -> PlannedMeal? {
        meals.first { WeekMath.gregorian.isDate($0.date, inSameDayAs: date) }
    }

    /// The seven days of the current plan.
    var weekDays: [Date] {
        guard let plan = currentPlan else { return [] }
        return WeekMath.days(from: plan.weekStartDate)
    }

    func recompute() {
        let current: [PlannedMeal] = meals
        var portions: [MealPortion] = []
        var indexMap: [Int] = []
        for (index, meal) in current.enumerated() {
            guard let recipe = repository.recipe(id: meal.recipeId) else { continue }
            portions.append(MealPortion(recipe: recipe, servings: meal.servings, weekday: WeekMath.isoWeekday(meal.date)))
            indexMap.append(index)
        }
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

    private var currentOnHand: Set<String> {
        onHand(forWeekStarting: currentPlan?.weekStartDate ?? Date())
    }

    func makeRequest(slots: [PlanSlot], seed: UInt64, locked: [Int: LockedMeal], start: Date, plan: WeekPlan?, recipes: [Recipe]? = nil) -> PlannerRequest {
        var rules: PlannerProfile = profileStore.plannerProfile
        rules.onHand = onHand(forWeekStarting: start)
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
            locked: locked
        )
    }

    private func runPlanner(_ request: PlannerRequest) async -> PlanResult {
        let planner = MealPlanner(catalog: catalog)
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
        let slots: [PlanSlot] = WeekMath.slots(from: weekStart, cookingDays: profileStore.cookingDays)
        let request: PlannerRequest = makeRequest(slots: slots, seed: SeededRandom.seed(weekStart: weekStart, regeneration: 0), locked: [:], start: weekStart, plan: nil)
        let result: PlanResult = await runPlanner(request)
        applyNewPlan(result, weekStart: weekStart)
        return result
    }

    /// Synchronous variant for previews and the debug menu.
    func generatePlanNow(startingAt start: Date = Date()) {
        let weekStart: Date = WeekMath.gregorian.startOfDay(for: start)
        let slots: [PlanSlot] = WeekMath.slots(from: weekStart, cookingDays: profileStore.cookingDays)
        let request: PlannerRequest = makeRequest(slots: slots, seed: SeededRandom.seed(weekStart: weekStart, regeneration: 0), locked: [:], start: weekStart, plan: nil)
        let result: PlanResult = MealPlanner(catalog: catalog).plan(request)
        applyNewPlan(result, weekStart: weekStart)
    }

    private func applyNewPlan(_ result: PlanResult, weekStart: Date) {
        let plan = WeekPlan(weekStartDate: weekStart, storeIdSnapshot: profileStore.profile?.storeId ?? "", budgetSnapshot: profileStore.weeklyBudget)
        context.insert(plan)
        for (index, draft) in result.meals.enumerated() {
            let meal = PlannedMeal(date: draft.date, recipeId: draft.recipeId, servings: draft.servings, orderIndex: index)
            meal.userRecipe = repository.userRecipeModel(id: draft.recipeId)
            meal.weekPlan = plan
            context.insert(meal)
        }
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
        let slots: [PlanSlot] = WeekMath.slots(from: plan.weekStartDate, cookingDays: profileStore.cookingDays)
        let liked: Set<String> = library.summary.liked
        var locked: [Int: LockedMeal] = [:]
        var keepMeals: [PlannedMeal] = []
        for meal in plan.sortedMeals {
            let keep: Bool = keepCookedAndLiked && (meal.isCooked || liked.contains(meal.recipeId))
            if keep, let slot = slots.first(where: { WeekMath.gregorian.isDate($0.date, inSameDayAs: meal.date) }) {
                locked[slot.index] = LockedMeal(recipeId: meal.recipeId, servings: meal.servings)
                keepMeals.append(meal)
            } else if keep {
                keepMeals.append(meal)
            }
        }
        let seed: UInt64 = SeededRandom.seed(weekStart: plan.weekStartDate, regeneration: plan.regenerationCount)
        let request: PlannerRequest = makeRequest(slots: slots, seed: seed, locked: locked, start: plan.weekStartDate, plan: plan)
        let result: PlanResult = await runPlanner(request)

        let keepIds: Set<PersistentIdentifier> = Set(keepMeals.map { $0.persistentModelID })
        for meal in plan.meals ?? [] where !keepIds.contains(meal.persistentModelID) {
            context.delete(meal)
        }
        for (index, draft) in result.meals.enumerated() where locked[draft.slotIndex] == nil {
            let meal = PlannedMeal(date: draft.date, recipeId: draft.recipeId, servings: draft.servings, orderIndex: index)
            meal.userRecipe = repository.userRecipeModel(id: draft.recipeId)
            meal.weekPlan = plan
            context.insert(meal)
        }
        saveAndRefresh()
    }

    // MARK: - Swaps and edits

    /// Top 3 rule-following swaps for a meal, with cost change.
    func alternatives(for meal: PlannedMeal) async -> [SwapSuggestion] {
        let current: [PlannedMeal] = meals
        guard let targetIndex = current.firstIndex(where: { $0.persistentModelID == meal.persistentModelID }) else { return [] }
        var slots: [PlanSlot] = []
        var assignment: [Int: LockedMeal] = [:]
        for (index, item) in current.enumerated() {
            slots.append(PlanSlot(index: index, date: item.date, weekday: WeekMath.isoWeekday(item.date)))
            assignment[index] = LockedMeal(recipeId: item.recipeId, servings: item.servings)
        }
        let start: Date = currentPlan?.weekStartDate ?? Date()
        let seed: UInt64 = SeededRandom.seed(weekStart: start, regeneration: (currentPlan?.regenerationCount ?? 0) + 101)
        // Swaps may use any of the user's own recipes.
        let request: PlannerRequest = makeRequest(slots: slots, seed: seed, locked: [:], start: start, plan: currentPlan, recipes: repository.allRecipes)
        let planner = MealPlanner(catalog: catalog)
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

    func swap(_ meal: PlannedMeal, to recipeId: String) {
        meal.recipeId = recipeId
        meal.userRecipe = repository.userRecipeModel(id: recipeId)
        meal.isCooked = false
        meal.cookedAt = nil
        saveAndRefresh()
    }

    func addMeal(recipeId: String, on date: Date, servings: Double? = nil) {
        guard let plan = currentPlan ?? createEmptyPlan() else { return }
        let meal = PlannedMeal(date: WeekMath.gregorian.startOfDay(for: date), recipeId: recipeId, servings: servings ?? profileStore.defaultServings, orderIndex: meals.count)
        meal.userRecipe = repository.userRecipeModel(id: recipeId)
        meal.weekPlan = plan
        context.insert(meal)
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
        context.delete(meal)
        saveAndRefresh()
    }

    func setServings(_ meal: PlannedMeal, servings: Double) {
        meal.servings = min(12, max(1, servings))
        saveAndRefresh()
    }

    func setCooked(_ meal: PlannedMeal, cooked: Bool) {
        meal.isCooked = cooked
        meal.cookedAt = cooked ? Date() : nil
        saveAndRefresh()
    }

    /// Mark the plan's meal for this recipe as cooked (from recipe detail / cook mode).
    func markCooked(recipeId: String) {
        if let meal = meals.first(where: { $0.recipeId == recipeId && !$0.isCooked }) ?? meals.first(where: { $0.recipeId == recipeId }) {
            setCooked(meal, cooked: true)
        }
    }

    func isInPlan(_ recipeId: String) -> Bool {
        meals.contains { $0.recipeId == recipeId }
    }

    func plannedMeal(for recipeId: String) -> PlannedMeal? {
        meals.first { $0.recipeId == recipeId }
    }

    /// Rows for the Edit week sheet: one per day of the plan window.
    func editRows() -> [EditableMeal?] {
        weekDays.map { day in
            guard let meal = meal(on: day) else { return nil }
            return EditableMeal(recipeId: meal.recipeId, servings: meal.servings, isCooked: meal.isCooked, cookedAt: meal.cookedAt)
        }
    }

    /// Saves the Edit week sheet (rows aligned with `weekDays`).
    func applyEdit(rows: [EditableMeal?]) {
        guard let plan = currentPlan else { return }
        let days: [Date] = weekDays
        for meal in plan.meals ?? [] {
            context.delete(meal)
        }
        for (index, row) in rows.enumerated() where index < days.count {
            guard let row else { continue }
            let meal = PlannedMeal(date: days[index], recipeId: row.recipeId, servings: row.servings, orderIndex: index)
            meal.isCooked = row.isCooked
            meal.cookedAt = row.cookedAt
            meal.userRecipe = repository.userRecipeModel(id: row.recipeId)
            meal.weekPlan = plan
            context.insert(meal)
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

    func addExtra(name: String, quantity: String) {
        let trimmed: String = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        context.insert(ExtraGroceryItem(name: trimmed, quantityText: quantity.trimmingCharacters(in: .whitespacesAndNewlines)))
        try? context.save()
        reload()
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
    func addRecipeToExtras(_ recipe: Recipe, servings: Double) {
        let scale: Double = servings / Double(max(1, recipe.baseServings))
        for item in recipe.ingredients {
            let ingredient: Ingredient? = item.ingredientId.flatMap { catalog.ingredient(id: $0) }
            if ingredient?.isPantryStaple == true { continue }
            let name: String = ingredient?.displayName(for: profileStore.unitSystem) ?? item.name ?? ""
            let quantity: String = QuantityFormatter.string(amount: item.amount * scale, unit: item.unit, system: profileStore.unitSystem, ingredient: ingredient)
            context.insert(ExtraGroceryItem(name: name.capitalizedFirst, quantityText: quantity))
        }
        try? context.save()
        reload()
    }

    func shareText(title: String) -> String {
        GroceryTextExporter.plainText(
            list: groceryList,
            title: title,
            checkedKeys: checkedKeys,
            extras: extras.map { (name: $0.name, quantity: $0.quantityText, checked: $0.isChecked) },
            formatMoney: { [profileStore] amount in profileStore.formatMoney(amount) }
        )
    }

    // MARK: - Persistence

    func saveAndRefresh(widget: Bool = true) {
        do {
            try context.save()
        } catch {
            PersistenceController.logger.error("Plan save failed: \(String(describing: error), privacy: .public)")
        }
        recompute()
        if widget {
            WidgetSnapshotWriter.write(meals: meals, repository: repository)
        }
    }
}
