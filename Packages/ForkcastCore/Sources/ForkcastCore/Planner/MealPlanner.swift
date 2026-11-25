import Foundation

/// Deterministic, on-device weekly meal planner (breakfast, lunch, dinner, snacks).
///
/// 1. Hard filters (never broken): allergens, diet, dislikes, appliances,
///    time (the only rule that may be relaxed), "not for me".
/// 2. Rank safe options by onboarding choices, taste, schedule and incremental basket cost.
/// 3. Fill by meal type and variety, then repair expensive choices if needed.
public struct MealPlanner: Sendable {
    public let catalog: FoodCatalog
    let analysisCache = RecipeAnalysisCache()

    public func traits(for recipe: Recipe, pricing: PriceContext) -> RecipeTraits {
        analysisCache.analyze([recipe], catalog: catalog, pricing: pricing).0[0].1
    }

    public static let maxBudgetIterations: Int = 20
    public static let maxSameProtein: Int = 2
    public static let maxSameCuisine: Int = 2

    public init(catalog: FoodCatalog) {
        self.catalog = catalog
    }

    // MARK: - Hard filters

    public func passesHardFilters(_ recipe: Recipe, profile: PlannerProfile, notForMe: Set<String>, ignoreTime: Bool = false) -> Bool {
        passesHardFilters(recipe, recipeProfile: RecipeClassifier.profile(for: recipe, catalog: catalog), profile: profile, notForMe: notForMe, ignoreTime: ignoreTime)
    }

    func passesHardFilters(_ recipe: Recipe, recipeProfile: RecipeProfile, profile: PlannerProfile, notForMe: Set<String>, ignoreTime: Bool) -> Bool {
        if notForMe.contains(recipe.id) { return false }
        if !recipeProfile.allergens.isDisjoint(with: profile.allergens) { return false }
        if !recipeProfile.diet.isCompatible(with: profile.diet) { return false }
        if DislikeCatalog.isDisliked(recipeProfile, dislikes: profile.dislikes) { return false }
        if !Set(recipe.appliances).isSubset(of: profile.appliances) { return false }
        if !ignoreTime, let max = profile.maxCookMinutes, recipe.handsOnMinutes > max + 10 { return false }
        return true
    }

    /// Recipes that never break the user's rules (allergens, diet, dislikes, appliances).
    /// Time is not applied here: it is a preference for auto-plans, not a safety rule.
    public func safeRecipes(from recipes: [Recipe], profile: PlannerProfile, notForMe: Set<String> = []) -> [Recipe] {
        recipes.filter { passesHardFilters($0, profile: profile, notForMe: notForMe, ignoreTime: true) }
    }

    /// Score without jitter or overlap.
    public func score(_ recipe: Recipe, request: PlannerRequest) -> Double {
        var value: Double = 0
        let vibeMatches: Int = Set(recipe.vibes).intersection(request.profile.vibes).count
        value += 3 * Double(vibeMatches)
        if request.profile.vibes.contains(.fiberForward), !recipe.vibes.contains(.fiberForward) {
            value += min(3, max(0, NutritionCalculator.perServing(recipe, catalog: catalog).macros.fiber) / max(1, 3 * recipe.mealType.budgetWeight))
        }
        if request.feedback.liked.contains(recipe.id) { value += 4 }
        if let stars = request.feedback.stars[recipe.id], stars > 3 { value += Double(stars - 3) }
        if let weeksAgo = request.history[recipe.id] {
            if weeksAgo <= 2 {
                value -= 5
            } else {
                value -= 1
            }
        }
        if recipe.isUserRecipe && request.profile.includeUserRecipes { value += 0.5 }
        if request.profile.prefersMealPrep && recipe.isLeftoverFriendly { value += 2 }
        if request.profile.preferredCuisines.contains(recipe.cuisine) { value += 2 }
        return value
    }

    struct Candidate {
        let recipe: Recipe
        let analysis: RecipeAnalysis
        let traits: RecipeTraits
        let score: Double

        var profile: RecipeProfile { analysis.profile }
    }

    struct Selection {
        var candidate: Candidate
        let servings: Double
        var leftoversFrom: Int? = nil
        var reason: PlannedMealReason = .everyday
    }

    struct Options {
        let byType: [MealType: [Candidate]]
        let byID: [String: Candidate]
        let prices: [String: Double]
        let weights: TailoringWeights
        let taste: TasteProfile
        let relaxedTime: Bool
    }

    func options(for request: PlannerRequest, seed: UInt64, allowAllUserRecipes: Bool = false) -> Options {
        var seen: Set<String> = []
        let recipes = (request.recipes + request.tasteRecipes).filter { seen.insert($0.id).inserted }
        let (analyzed, prices) = analysisCache.analyze(recipes, catalog: catalog, pricing: request.pricing)
        let asOf = request.tasteAsOf ?? request.slots.map(\.date).min() ?? Date(timeIntervalSince1970: 0)
        let taste = TasteProfile(events: request.tasteEvents, recipes: recipes, analyzed: analyzed, asOf: asOf)
        let weights = TailoringWeights(profile: request.profile)
        let poolIDs = Set(request.recipes.map(\.id))
        let counts = Dictionary(grouping: request.slots, by: \.mealType).mapValues(\.count)
        var rng = SeededRandom(seed: seed)
        var indexed: [Candidate] = []
        for (recipe, data) in zip(recipes, analyzed) {
            let (analysis, traits) = data
            let proteinTarget = 30 * recipe.mealType.budgetWeight
            let learned = taste.score(recipe: recipe, profile: analysis.profile, traits: traits)
            let saved = request.savedRecipeIds.contains(recipe.id) ? weights.saved : 0
            var rank = score(recipe, request: request) + learned + saved + rng.nextUnit() * 0.9
            rank += weights.everyday * traits.everyday + weights.health * traits.healthiness
            rank += weights.protein * unit(traits.proteinPerServing / proteinTarget)
            rank += weights.family * traits.kidFriendly
            if traits.onePan { rank += weights.onePan }
            if weights.pairsLeftovers { rank += traits.leftoverValue }
            indexed.append(Candidate(recipe: recipe, analysis: analysis, traits: traits, score: rank))
        }
        var safe: [MealType: [Candidate]] = [:]
        for item in indexed {
            let type = item.recipe.mealType
            guard poolIDs.contains(item.recipe.id), counts[type] != nil,
                  !item.recipe.isUserRecipe || request.profile.includeUserRecipes || allowAllUserRecipes,
                  passesHardFilters(item.recipe, recipeProfile: item.profile, profile: request.profile,
                                    notForMe: request.feedback.notForMe, ignoreTime: true) else { continue }
            safe[type, default: []].append(item)
        }
        var timed = safe
        var relaxed = false
        if let limit = request.profile.maxCookMinutes {
            timed = safe.mapValues { $0.filter { $0.recipe.handsOnMinutes <= limit + 10 } }
            relaxed = counts.contains { type, count in timed[type, default: []].count < count * 2 }
            if relaxed { timed = safe }
        }
        return Options(byType: timed, byID: Dictionary(uniqueKeysWithValues: indexed.map { ($0.recipe.id, $0) }),
                       prices: prices, weights: weights, taste: taste, relaxedTime: relaxed)
    }

    public func plan(_ request: PlannerRequest) -> PlanResult {
        let options = options(for: request, seed: request.seed)
        let slots = request.slots.sorted { $0.date == $1.date ? $0.index < $1.index : $0.date < $1.date }
        let target = request.budget / max(0.01, slots.reduce(0) { $0 + $1.mealType.budgetWeight })
        var assignment: [Int: Selection] = [:]
        var basket = IncrementalBasket(prices: options.prices, onHand: request.profile.onHand)
        for slot in slots {
            guard let locked = request.locked[slot.index],
                  let item = options.byID[locked.recipeId] ?? catalog.recipe(id: locked.recipeId).map({ cachedCandidate($0, request: request) }),
                  item.recipe.mealType == slot.mealType,
                  passesHardFilters(item.recipe, recipeProfile: item.profile, profile: request.profile,
                                    notForMe: request.feedback.notForMe, ignoreTime: true) else { continue }
            assignment[slot.index] = Selection(candidate: item, servings: locked.servings, reason: .kept)
            basket.add(item.analysis.ingredients, servings: locked.servings)
        }
        let locked = Set(assignment.keys)
        var paired = false
        for slot in slots {
            guard let source = request.locked[slot.index]?.leftoversFromSlotIndex,
                  let meal = assignment[slot.index], let batch = assignment[source],
                  meal.candidate.recipe.id == batch.candidate.recipe.id,
                  let sourceSlot = slots.first(where: { $0.index == source }),
                  sourceSlot.mealType == slot.mealType,
                  (1...4).contains(WeekMath.gregorian.dateComponents([.day], from: sourceSlot.date, to: slot.date).day ?? 0) else { continue }
            assignment[slot.index]?.leftoversFrom = source
            paired = true
        }
        var explored = false
        let known = options.taste.knownRecipeIds.union(request.history.keys).union(request.feedback.liked).union(request.savedRecipeIds)
        for (dayIndex, slot) in slots.enumerated() where assignment[slot.index] == nil {
            let peers = selections(in: assignment, slots: slots, of: slot.mealType)
            let available = options.byType[slot.mealType, default: []]
            var eligible = eligibleOptions(available, peers: peers, type: slot.mealType, family: options.weights.family > 0)
            guard !eligible.isEmpty else { continue }

            let busyLimit = slot.weekday <= 4 && options.weights.effort > 2 ? request.profile.maxCookMinutes : nil
            if let busyLimit {
                let quick = eligible.filter { $0.recipe.handsOnMinutes <= busyLimit }
                if !quick.isEmpty { eligible = quick }
            }
            let laterSlots = slots.dropFirst(dayIndex + 1)
            let requestedPartners = request.profile.mealPrepEdges.map { edges in
                linkedPartners(after: slot, candidates: laterSlots, edges: edges, occupied: Set(assignment.keys))
            }
            var partners = requestedPartners ?? []
            if requestedPartners == nil, slot.mealType == .dinner, options.weights.pairsLeftovers, !paired,
               let nextDinner = laterSlots.first(where: { $0.mealType == .dinner }),
               assignment[nextDinner.index] == nil, isNextDay(nextDinner.date, after: slot.date) {
                partners = [nextDinner]
            }
            if !partners.isEmpty {
                let batch = eligible.filter {
                    $0.recipe.isLeftoverFriendly && (requestedPartners != nil || $0.traits.batchFriendly)
                }
                if batch.isEmpty { partners = [] }
                else { eligible = batch }
            }

            let reference = slot.mealType == .dinner && !explored && partners.isEmpty
                ? explorationReference(in: options, request: request) : nil
            let groupSize = Double(partners.count + 1)
            let units = groupSize * request.servings
            let allowance = max(0.01, target * slot.mealType.budgetWeight * groupSize)
            let weekPosition = min(6, slot.date.timeIntervalSince(slots.first?.date ?? slot.date) / 86_400)
            var best: Candidate?
            var highest = -Double.infinity
            for item in eligible {
                let value = rank(item, slot: slot, weekPosition: weekPosition, peers: peers, basket: basket,
                                 units: units, allowance: allowance, weights: options.weights, reference: reference, known: known)
                if value > highest {
                    highest = value
                    best = item
                }
            }
            guard let chosen = best else { continue }
            let isExploration = reference.map { isNovel(chosen, relativeTo: $0, known: known) } ?? false
            let why = reason(for: chosen, slot: slot, basket: basket, allowance: allowance, servings: request.servings,
                             weights: options.weights, similarTo: isExploration ? reference?.recipe.id : nil)
            explored = explored || isExploration
            assignment[slot.index] = Selection(candidate: chosen, servings: request.servings, reason: partners.isEmpty ? why : .batchCooking)
            for partner in partners {
                assignment[partner.index] = Selection(candidate: chosen, servings: request.servings,
                                                      leftoversFrom: slot.index, reason: .plannedLeftovers)
                paired = true
            }
            basket.add(chosen.analysis.ingredients, servings: units)
        }

        repairBudget(&assignment, slots: slots, locked: locked, options: options, request: request)
        let grocery = groceryList(assignment, slots: slots, request: request)
        var meals: [PlannedMealDraft] = []
        for slot in slots {
            guard let selection = assignment[slot.index] else { continue }
            let draft = PlannedMealDraft(slotIndex: slot.index, date: slot.date, weekday: slot.weekday, mealType: slot.mealType,
                                        recipeId: selection.candidate.recipe.id, servings: selection.servings,
                                        allocatedCost: grocery.mealCosts[meals.count], reason: selection.reason,
                                        leftoversFromSlotIndex: selection.leftoversFrom)
            meals.append(draft)
        }
        return PlanResult(meals: meals, estimatedTotal: grocery.total, budget: request.budget,
                          overBudgetBy: max(0, grocery.total - request.budget), relaxedTimeLimit: options.relaxedTime, groceryList: grocery)
    }

    private func linkedPartners(after slot: PlanSlot, candidates: ArraySlice<PlanSlot>, edges: Set<Int>, occupied: Set<Int>) -> [PlanSlot] {
        var previous = slot
        var partners: [PlanSlot] = []
        for candidate in candidates where candidate.mealType == slot.mealType {
            guard partners.count < 4, previous.weekday < 7, edges.contains(previous.weekday),
                  !occupied.contains(candidate.index), isNextDay(candidate.date, after: previous.date) else { break }
            partners.append(candidate)
            previous = candidate
        }
        return partners
    }

    func isNextDay(_ date: Date, after previous: Date) -> Bool {
        let calendar = WeekMath.gregorian
        guard let next = calendar.date(byAdding: .day, value: 1, to: previous) else { return false }
        return calendar.isDate(date, inSameDayAs: next)
    }

    func cachedCandidate(_ recipe: Recipe, request: PlannerRequest) -> Candidate {
        let (analysis, traits) = analysisCache.analyze([recipe], catalog: catalog, pricing: request.pricing).0[0]
        return Candidate(recipe: recipe, analysis: analysis, traits: traits, score: score(recipe, request: request))
    }

    func selections(in assignment: [Int: Selection], slots: [PlanSlot], of type: MealType, excluding: Int? = nil) -> [Candidate] {
        slots.compactMap { slot in
            guard slot.mealType == type, slot.index != excluding, let selection = assignment[slot.index],
                  selection.leftoversFrom == nil else { return nil }
            return selection.candidate
        }
    }

    func eligibleOptions(_ candidates: [Candidate], peers: [Candidate], type: MealType, family: Bool) -> [Candidate] {
        let uses = Dictionary(grouping: peers, by: { $0.recipe.id }).mapValues(\.count)
        let protein = Dictionary(grouping: peers, by: { $0.profile.mainProtein }).mapValues(\.count)
        let cuisines = Dictionary(grouping: peers, by: { $0.recipe.cuisine }).mapValues(\.count)
        let mild = family ? candidates.filter { !$0.profile.isSpicy } : candidates
        for pool in [mild, candidates] where !pool.isEmpty {
            let fresh = pool.filter { uses[$0.recipe.id] == nil }
            let strict = type.usesVarietyRules ? fresh.filter {
                protein[$0.profile.mainProtein, default: 0] < Self.maxSameProtein
                    && cuisines[$0.recipe.cuisine, default: 0] < Self.maxSameCuisine
            } : fresh
            if !strict.isEmpty { return strict }
            if !fresh.isEmpty && (!family || mild.count == candidates.count) { return fresh }
        }
        let repeatable = candidates.filter { uses[$0.recipe.id, default: 0] < type.maxUsesPerWeek }
        return repeatable.isEmpty ? candidates : repeatable
    }

    func rank(_ item: Candidate, slot: PlanSlot, weekPosition: Double, peers: [Candidate], basket: IncrementalBasket,
              units: Double, allowance: Double, weights: TailoringWeights, reference: Candidate?, known: Set<String>) -> Double {
        let traits = item.traits
        let shopping = basket.addition(item.analysis.ingredients, servings: units)
        let ratio = shopping.cost / allowance
        let spend = weights.cheapness * min(ratio, 4) + 2 * max(0, min(6, ratio - 1))
        let dayEffort = weights.effort * (slot.weekday <= 4 ? 1.3 : 0.55)
        let freshTiming = weights.perishability * traits.perishability * (1 - weekPosition / 3)
        let reuseScale = weights.perishability > 1 ? max(1, allowance * 0.18) : allowance
        let savedFresh = min(shopping.freshReuse / reuseScale, 1.5)
        let sharedFresh = weights.perishability > 1 ? min(3, shopping.freshShared) * 0.18 : 0
        let reuse = weights.reuse * (savedFresh + sharedFresh)
        let familiarCuisine = peers.contains { $0.recipe.cuisine == item.recipe.cuisine }
        let exploration = reference.map { isNovel(item, relativeTo: $0, known: known) ? weights.novelty + 0.7 : 0 } ?? 0
        return item.score - spend - dayEffort * traits.effort + freshTiming
            + reuse
            + min(shopping.shared, 3) * 0.18 + exploration
            + (familiarCuisine ? 0 : weights.novelty * 0.45)
    }

    func explorationReference(in options: Options, request: PlannerRequest) -> Candidate? {
        let ids = options.taste.positiveRecipeIds.union(request.feedback.liked)
        return ids.sorted().compactMap { options.byID[$0] }.max { $0.score < $1.score }
    }

    func isNovel(_ candidate: Candidate, relativeTo reference: Candidate, known: Set<String>) -> Bool {
        !known.contains(candidate.recipe.id) && candidate.traits.everyday >= 0.48
            && (candidate.recipe.cuisine == reference.recipe.cuisine
                || candidate.profile.keyIngredientIds.intersection(reference.profile.keyIngredientIds).count >= 2)
    }

    func reason(for item: Candidate, slot: PlanSlot, basket: IncrementalBasket, allowance: Double,
                servings: Double, weights: TailoringWeights, similarTo: String?) -> PlannedMealReason {
        if let similarTo { return .similarTo(recipeId: similarTo) }
        let addition = basket.addition(item.analysis.ingredients, servings: servings)
        if let used = addition.freshIngredient {
            return .usesPerishable(ingredientId: used)
        }
        if weights.family > 0 && item.traits.kidFriendly >= 0.65 { return .familyFriendly }
        if slot.weekday <= 4 && item.traits.effort < 0.35 { return .quick(weekday: slot.weekday) }
        if addition.cost <= allowance { return .underBudget }
        return .everyday
    }

    func groceryList(_ assignment: [Int: Selection], slots: [PlanSlot], request: PlannerRequest) -> GroceryList {
        let weekdays = Dictionary(uniqueKeysWithValues: slots.map { ($0.index, $0.weekday) })
        var positions: [Int: Int] = [:]
        var portions: [MealPortion] = []
        for slot in slots {
            guard let selection = assignment[slot.index] else { continue }
            let weekday = selection.leftoversFrom.flatMap { weekdays[$0] } ?? slot.weekday
            let source = selection.leftoversFrom.flatMap { positions[$0] }
            positions[slot.index] = portions.count
            portions.append(MealPortion(recipe: selection.candidate.recipe, servings: selection.servings, weekday: weekday,
                                        batchWithMealIndex: source))
        }
        return GroceryAggregator.aggregate(meals: portions, catalog: catalog, pricing: request.pricing,
                                           unitSystem: request.unitSystem, onHand: request.profile.onHand)
    }

    func repairBudget(_ assignment: inout [Int: Selection], slots: [PlanSlot], locked: Set<Int>, options: Options, request: PlannerRequest) {
        for _ in 0..<Self.maxBudgetIterations {
            var full = IncrementalBasket(prices: options.prices, onHand: request.profile.onHand)
            for slot in slots {
                guard let selection = assignment[slot.index] else { continue }
                full.add(selection.candidate.analysis.ingredients, servings: selection.servings)
            }
            guard full.total > request.budget + 0.01 else { break }

            var best: (slot: Int, partners: [Int], replacement: Candidate, merit: Double)?
            for slot in slots where !locked.contains(slot.index) {
                guard let current = assignment[slot.index], current.leftoversFrom == nil else { continue }
                let partners = slots.filter { assignment[$0.index]?.leftoversFrom == slot.index }.map(\.index)
                guard partners.allSatisfy({ !locked.contains($0) }) else { continue }
                let servings = partners.reduce(current.servings) { $0 + (assignment[$1]?.servings ?? 0) }
                var rest = full
                rest.add(current.candidate.analysis.ingredients, servings: servings, removing: true)
                let old = rest.addition(current.candidate.analysis.ingredients, servings: servings).cost
                let peers = selections(in: assignment, slots: slots, of: slot.mealType, excluding: slot.index)
                let used = Set(peers.map { $0.recipe.id })
                let candidates = options.byType[slot.mealType, default: []].filter {
                    $0.recipe.id != current.candidate.recipe.id && !used.contains($0.recipe.id)
                        && (partners.isEmpty || $0.recipe.isLeftoverFriendly)
                }
                var eligible = eligibleOptions(candidates, peers: peers, type: slot.mealType, family: options.weights.family > 0)
                if slot.weekday <= 4, options.weights.effort > 2, let limit = request.profile.maxCookMinutes,
                   current.candidate.recipe.handsOnMinutes <= limit {
                    eligible = eligible.filter { $0.recipe.handsOnMinutes <= limit }
                }
                for replacement in eligible {
                    let savings = old - rest.addition(replacement.analysis.ingredients, servings: servings).cost
                    guard savings > 0.01 else { continue }
                    let merit = savings - 0.22 * max(0, current.candidate.score - replacement.score)
                    if merit > (best?.merit ?? -.infinity) {
                        best = (slot.index, partners, replacement, merit)
                    }
                }
            }
            guard let best else { break }
            assignment[best.slot]?.candidate = best.replacement
            assignment[best.slot]?.reason = best.partners.isEmpty ? .lowerCost : .batchCooking
            for partner in best.partners { assignment[partner]?.candidate = best.replacement }
        }
    }

    public func alternatives(for slotIndex: Int, current: [Int: LockedMeal], request: PlannerRequest, limit: Int = 3) -> [SwapSuggestion] {
        guard limit > 0 else { return [] }
        let options = options(for: request, seed: request.seed &+ UInt64(truncatingIfNeeded: slotIndex) &+ 7, allowAllUserRecipes: true)
        let slots = request.slots.sorted { $0.index < $1.index }
        guard let slot = slots.first(where: { $0.index == slotIndex }) else { return [] }
        var assignment: [Int: Selection] = [:]
        var basket = IncrementalBasket(prices: options.prices, onHand: request.profile.onHand)
        for other in slots {
            guard let locked = current[other.index],
                  let item = options.byID[locked.recipeId] ?? catalog.recipe(id: locked.recipeId).map({ cachedCandidate($0, request: request) }) else { continue }
            let source = locked.leftoversFromSlotIndex == slotIndex ? nil : locked.leftoversFromSlotIndex
            assignment[other.index] = Selection(candidate: item, servings: locked.servings, leftoversFrom: source)
            if other.index != slotIndex { basket.add(item.analysis.ingredients, servings: locked.servings) }
        }
        let servings = current[slotIndex]?.servings ?? request.servings
        let original = assignment[slotIndex].map { basket.addition($0.candidate.analysis.ingredients, servings: servings).cost } ?? 0
        let used = Set(assignment.values.map { $0.candidate.recipe.id })
        let available = options.byType[slot.mealType, default: []].filter { !used.contains($0.recipe.id) }
        let peers = selections(in: assignment, slots: slots, of: slot.mealType, excluding: slotIndex)
        let strict = eligibleOptions(available, peers: peers, type: slot.mealType, family: options.weights.family > 0)
        let allowance = max(0.01, request.budget * slot.mealType.budgetWeight / max(0.01, slots.reduce(0) { $0 + $1.mealType.budgetWeight }))
        var ranked: [SwapSuggestion] = []
        for item in strict.count >= limit ? strict : available {
            let delta = basket.addition(item.analysis.ingredients, servings: servings).cost - original
            let value = rank(item, slot: slot, weekPosition: 0, peers: peers, basket: basket, units: servings,
                             allowance: allowance, weights: options.weights, reference: nil, known: [])
            ranked.append(SwapSuggestion(recipeId: item.recipe.id, costDelta: delta, score: value))
        }
        ranked.sort { lhs, rhs in
            if lhs.score == rhs.score { return lhs.recipeId < rhs.recipeId }
            return lhs.score > rhs.score
        }
        return Array(ranked.prefix(limit))
    }
}
