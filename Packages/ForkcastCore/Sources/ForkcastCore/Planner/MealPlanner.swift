import Foundation

/// Deterministic, on-device weekly dinner planner.
///
/// 1. Hard filters (never broken): allergens, diet, dislikes, appliances,
///    time (the only rule that may be relaxed), "not for me".
/// 2. Score: vibes, likes, stars, recency, user recipes, seeded jitter.
/// 3. Greedy week with variety rules and ingredient-overlap bonus.
/// 4. Budget pass: swap expensive meals for cheaper good ones.
public struct MealPlanner: Sendable {
    public let catalog: FoodCatalog

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

    struct Candidate {
        let recipe: Recipe
        let profile: RecipeProfile
        let baseScore: Double
    }

    /// Hard-filtered, scored candidates. Relaxes the time rule if too few remain.
    func candidates(for request: PlannerRequest, rng: inout SeededRandom) -> (candidates: [Candidate], relaxedTime: Bool) {
        let profiles: [(Recipe, RecipeProfile)] = request.recipes.map { ($0, RecipeClassifier.profile(for: $0, catalog: catalog)) }
        let needed: Int = max(1, request.slots.count) * 2
        var relaxed: Bool = false
        var passing: [(Recipe, RecipeProfile)] = profiles.filter {
            passesHardFilters($0.0, recipeProfile: $0.1, profile: request.profile, notForMe: request.feedback.notForMe, ignoreTime: false)
        }
        if passing.count < needed && request.profile.maxCookMinutes != nil {
            passing = profiles.filter {
                passesHardFilters($0.0, recipeProfile: $0.1, profile: request.profile, notForMe: request.feedback.notForMe, ignoreTime: true)
            }
            relaxed = true
        }
        let scored: [Candidate] = passing.map { pair in
            let jitter: Double = rng.nextUnit() * 0.9
            return Candidate(recipe: pair.0, profile: pair.1, baseScore: score(pair.0, request: request) + jitter)
        }
        return (scored, relaxed)
    }

    /// Score without jitter or overlap.
    public func score(_ recipe: Recipe, request: PlannerRequest) -> Double {
        var value: Double = 0
        let vibeMatches: Int = Set(recipe.vibes).intersection(request.profile.vibes).count
        value += 3 * Double(vibeMatches)
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

    // MARK: - Plan

    public func plan(_ request: PlannerRequest) -> PlanResult {
        var rng = SeededRandom(seed: request.seed)
        let pool = candidates(for: request, rng: &rng)
        let candidates: [Candidate] = pool.candidates

        // Start with locked meals.
        var assignment: [Int: Candidate] = [:]
        var servingsBySlot: [Int: Double] = [:]
        for slot in request.slots {
            servingsBySlot[slot.index] = request.servings
            if let locked = request.locked[slot.index] {
                if let recipe = request.recipes.first(where: { $0.id == locked.recipeId }) ?? catalog.recipe(id: locked.recipeId) {
                    assignment[slot.index] = Candidate(recipe: recipe, profile: RecipeClassifier.profile(for: recipe, catalog: catalog), baseScore: 0)
                    servingsBySlot[slot.index] = locked.servings
                }
            }
        }
        let lockedSlots: Set<Int> = Set(assignment.keys)

        // Greedy fill.
        for slot in request.slots where assignment[slot.index] == nil {
            if let pick = bestCandidate(from: candidates, chosen: Array(assignment.values), excluding: nil) {
                assignment[slot.index] = pick
            }
        }

        // Budget pass.
        var total: Double = basket(for: assignment, servings: servingsBySlot, slots: request.slots, request: request).total
        var iterations: Int = 0
        while total > request.budget && iterations < MealPlanner.maxBudgetIterations {
            iterations += 1
            let list: GroceryList = basket(for: assignment, servings: servingsBySlot, slots: request.slots, request: request)
            let ordered: [PlanSlot] = orderedSlots(request.slots, assignment: assignment)
            let costs: [Int: Double] = mealCostsBySlot(list: list, ordered: ordered)
            let expensiveFirst: [Int] = costs.keys
                .filter { !lockedSlots.contains($0) }
                .sorted { (costs[$0] ?? 0) > (costs[$1] ?? 0) }
            var improved: Bool = false
            for slotIndex in expensiveFirst {
                var others: [Candidate] = []
                for (key, value) in assignment where key != slotIndex { others.append(value) }
                let usedIds: Set<String> = Set(assignment.values.map { $0.recipe.id })
                let options: [Candidate] = candidates
                    .filter { !usedIds.contains($0.recipe.id) }
                    .sorted { $0.baseScore + overlapBonus($0, chosen: others) > $1.baseScore + overlapBonus($1, chosen: others) }
                var bestSwap: (Candidate, Double)? = nil
                for option in options {
                    var trial: [Int: Candidate] = assignment
                    trial[slotIndex] = option
                    let trialTotal: Double = basket(for: trial, servings: servingsBySlot, slots: request.slots, request: request).total
                    if trialTotal < total - 0.01 {
                        let respectsVariety: Bool = varietyOK(option, chosen: others)
                        if respectsVariety {
                            bestSwap = (option, trialTotal)
                            break
                        } else if bestSwap == nil {
                            bestSwap = (option, trialTotal)
                        }
                    }
                }
                if let swap = bestSwap {
                    assignment[slotIndex] = swap.0
                    total = swap.1
                    improved = true
                    break
                }
            }
            if !improved { break }
        }

        // Final basket and drafts.
        let ordered: [PlanSlot] = orderedSlots(request.slots, assignment: assignment)
        let finalList: GroceryList = basket(for: assignment, servings: servingsBySlot, slots: request.slots, request: request)
        var drafts: [PlannedMealDraft] = []
        for (position, slot) in ordered.enumerated() {
            guard let candidate = assignment[slot.index] else { continue }
            let cost: Double = position < finalList.mealCosts.count ? finalList.mealCosts[position] : 0
            drafts.append(PlannedMealDraft(
                slotIndex: slot.index,
                date: slot.date,
                weekday: slot.weekday,
                recipeId: candidate.recipe.id,
                servings: servingsBySlot[slot.index] ?? request.servings,
                allocatedCost: cost
            ))
        }
        return PlanResult(
            meals: drafts,
            estimatedTotal: finalList.total,
            budget: request.budget,
            overBudgetBy: max(0, finalList.total - request.budget),
            relaxedTimeLimit: pool.relaxedTime,
            groceryList: finalList
        )
    }

    // MARK: - Alternatives

    /// Top 3 swaps for a slot that keep every rule, with their cost change.
    /// `current` maps slot index -> (recipe, servings) for the whole week.
    public func alternatives(for slotIndex: Int, current: [Int: LockedMeal], request: PlannerRequest, limit: Int = 3) -> [SwapSuggestion] {
        var rng = SeededRandom(seed: request.seed &+ UInt64(slotIndex) &+ 7)
        let pool: [Candidate] = candidates(for: request, rng: &rng).candidates
        var assignment: [Int: Candidate] = [:]
        var servings: [Int: Double] = [:]
        for (index, meal) in current {
            guard let recipe = request.recipes.first(where: { $0.id == meal.recipeId }) ?? catalog.recipe(id: meal.recipeId) else { continue }
            assignment[index] = Candidate(recipe: recipe, profile: RecipeClassifier.profile(for: recipe, catalog: catalog), baseScore: 0)
            servings[index] = meal.servings
        }
        if servings[slotIndex] == nil { servings[slotIndex] = request.servings }
        let slots: [PlanSlot] = request.slots
        let baseTotal: Double = basket(for: assignment, servings: servings, slots: slots, request: request).total
        var others: [Candidate] = []
        for (key, value) in assignment where key != slotIndex { others.append(value) }
        let usedIds: Set<String> = Set(assignment.values.map { $0.recipe.id })

        var options: [Candidate] = pool.filter { !usedIds.contains($0.recipe.id) && varietyOK($0, chosen: others) }
        if options.count < limit {
            options = pool.filter { !usedIds.contains($0.recipe.id) }
        }
        let ranked: [Candidate] = options.sorted {
            $0.baseScore + overlapBonus($0, chosen: others) > $1.baseScore + overlapBonus($1, chosen: others)
        }
        return ranked.prefix(limit).map { option in
            var trial: [Int: Candidate] = assignment
            trial[slotIndex] = option
            let newTotal: Double = basket(for: trial, servings: servings, slots: slots, request: request).total
            return SwapSuggestion(recipeId: option.recipe.id, costDelta: newTotal - baseTotal, score: option.baseScore + overlapBonus(option, chosen: others))
        }
    }

    // MARK: - Helpers

    func bestCandidate(from candidates: [Candidate], chosen: [Candidate], excluding: Set<String>?) -> Candidate? {
        let usedIds: Set<String> = Set(chosen.map { $0.recipe.id }).union(excluding ?? [])
        let fresh: [Candidate] = candidates.filter { !usedIds.contains($0.recipe.id) }
        let strict: [Candidate] = fresh.filter { varietyOK($0, chosen: chosen) }
        let pool: [Candidate]
        if !strict.isEmpty {
            pool = strict
        } else if !fresh.isEmpty {
            pool = fresh
        } else {
            // Last resort: repeat a recipe rather than leave a dinner empty.
            pool = candidates
        }
        return pool.max { lhs, rhs in
            lhs.baseScore + overlapBonus(lhs, chosen: chosen) < rhs.baseScore + overlapBonus(rhs, chosen: chosen)
        }
    }

    func varietyOK(_ candidate: Candidate, chosen: [Candidate]) -> Bool {
        let sameProtein: Int = chosen.filter { $0.profile.mainProtein == candidate.profile.mainProtein }.count
        let sameCuisine: Int = chosen.filter { $0.recipe.cuisine == candidate.recipe.cuisine }.count
        return sameProtein < MealPlanner.maxSameProtein && sameCuisine < MealPlanner.maxSameCuisine
    }

    func overlapBonus(_ candidate: Candidate, chosen: [Candidate]) -> Double {
        var shared: Set<String> = []
        for other in chosen {
            shared.formUnion(candidate.profile.keyIngredientIds.intersection(other.profile.keyIngredientIds))
        }
        return Double(min(3, shared.count))
    }

    func orderedSlots(_ slots: [PlanSlot], assignment: [Int: Candidate]) -> [PlanSlot] {
        slots.filter { assignment[$0.index] != nil }.sorted { $0.index < $1.index }
    }

    func mealCostsBySlot(list: GroceryList, ordered: [PlanSlot]) -> [Int: Double] {
        var result: [Int: Double] = [:]
        for (position, slot) in ordered.enumerated() where position < list.mealCosts.count {
            result[slot.index] = list.mealCosts[position]
        }
        return result
    }

    func basket(for assignment: [Int: Candidate], servings: [Int: Double], slots: [PlanSlot], request: PlannerRequest) -> GroceryList {
        let ordered: [PlanSlot] = orderedSlots(slots, assignment: assignment)
        var portions: [MealPortion] = []
        for slot in ordered {
            guard let candidate = assignment[slot.index] else { continue }
            portions.append(MealPortion(recipe: candidate.recipe, servings: servings[slot.index] ?? request.servings, weekday: slot.weekday))
        }
        return GroceryAggregator.aggregate(meals: portions, catalog: catalog, pricing: request.pricing, unitSystem: request.unitSystem, onHand: request.profile.onHand)
    }
}
