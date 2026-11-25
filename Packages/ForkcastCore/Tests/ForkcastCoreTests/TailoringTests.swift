import Foundation
import XCTest
@testable import ForkcastCore

final class TailoringTests: XCTestCase {
    let catalog = TestSupport.catalog
    let planner = MealPlanner(catalog: TestSupport.catalog)

    func testTraitsDescribeEverydayFoodAndAreRecomputedForEdits() throws {
        let pasta = Recipe(id: "trait-pasta", title: "Tomato pasta", emoji: "🍝", cuisine: .italian,
                           vibes: [.onePan, .family, .batchFriendly], appliances: [.stovetop],
                           prepMinutes: 5, cookMinutes: 12,
                           ingredients: [
                            RecipeIngredient(ingredientId: "pasta", amount: 200, unit: .g),
                            RecipeIngredient(ingredientId: "onion", amount: 1, unit: .piece),
                            RecipeIngredient(ingredientId: "spinach", amount: 80, unit: .g),
                            RecipeIngredient(ingredientId: "olive-oil", amount: 1, unit: .tbsp),
                            RecipeIngredient(ingredientId: "garlic", amount: 1, unit: .clove)
                           ],
                           steps: ["Slice the onion.", "Cook together until tender."], isLeftoverFriendly: true)
        let simple = planner.traits(for: pasta, pricing: TestSupport.usPricing)
        var ragu = pasta
        ragu.title = "Slow-cooker ragù"
        ragu.vibes = []
        ragu.appliances = [.stovetop, .slowCooker]
        ragu.prepMinutes = 40
        ragu.cookMinutes = 240
        ragu.steps += Array(repeating: "Knead and marinate overnight.", count: 8)
        ragu.ingredients += Array(repeating: RecipeIngredient(ingredientId: "olives", amount: 10, unit: .g), count: 6)
        ragu.isLeftoverFriendly = false
        let project = planner.traits(for: ragu, pricing: TestSupport.usPricing)
        XCTAssertLessThan(simple.effort, project.effort)
        XCTAssertGreaterThan(simple.everyday, project.everyday)
        XCTAssertGreaterThan(simple.kidFriendly, project.kidFriendly)
        XCTAssertEqual(simple.budgetBand, .cheap)
        XCTAssertGreaterThan(simple.perishability, 0)
        XCTAssertGreaterThan(simple.healthiness, 0)
        XCTAssertGreaterThan(simple.leftoverValue, project.leftoverValue)
        XCTAssertTrue(simple.batchFriendly)
        XCTAssertTrue(simple.onePan)
        XCTAssertFalse(project.batchFriendly)
        XCTAssertFalse(project.onePan)
        let premium = planner.traits(for: pasta, pricing: PriceContext(region: .US, tier: .premium))
        XCTAssertGreaterThan(premium.costPerServing, simple.costPerServing)
        XCTAssertEqual(planner.traits(for: pasta, pricing: TestSupport.usPricing), simple)
    }

    func testWeightsUseOnboardingAnswersAndKeepDefaultsModest() {
        let standard = TailoringWeights(profile: PlannerProfile())
        let custom = TailoringWeights(profile: PlannerProfile(vibes: [.highProtein], goals: [.saveTime, .spendLess, .eatHealthier],
                                                              obstacles: [.tooTired, .foodGoesOff, .sameMeals, .messyRecipes], children: 2))
        XCTAssertGreaterThan(custom.everyday, standard.everyday)
        XCTAssertGreaterThan(custom.effort, standard.effort)
        XCTAssertGreaterThan(custom.onePan, standard.onePan)
        XCTAssertGreaterThan(custom.cheapness, standard.cheapness)
        XCTAssertGreaterThan(custom.reuse, standard.reuse)
        XCTAssertGreaterThan(custom.family, standard.family)
        XCTAssertGreaterThan(custom.health, standard.health)
        XCTAssertGreaterThan(custom.protein, standard.protein)
        XCTAssertGreaterThan(custom.perishability, standard.perishability)
        XCTAssertGreaterThan(custom.novelty, standard.novelty)
        XCTAssertGreaterThan(custom.saved, standard.saved)
        XCTAssertTrue(custom.pairsLeftovers)
        XCTAssertFalse(standard.pairsLeftovers)
    }

    func testTasteDecaysCapsAndClearsLatestExplicitFeedback() throws {
        let recipe = try XCTUnwrap(catalog.recipe(id: "shakshuka"))
        let date = TestSupport.monday
        func taste(_ events: [TasteEvent]) -> TasteProfile {
            TasteProfile(events: events, recipes: [recipe], planner: planner, pricing: TestSupport.usPricing, asOf: date)
        }
        let old = date.addingTimeInterval(-28 * 86_400)
        let recent = date.addingTimeInterval(-86_400)
        let cooked = TasteEvent(recipeId: recipe.id, kind: .cooked, date: recent)
        let liked = TasteEvent(recipeId: recipe.id, kind: .liked, date: recent)
        let oldLike = TasteEvent(recipeId: recipe.id, kind: .liked, date: old)
        let cleared = TasteEvent(recipeId: recipe.id, kind: .ratingCleared, date: date)
        let future = TasteEvent(recipeId: recipe.id, kind: .notForMe, date: date.addingTimeInterval(1))
        func cuisine(_ events: [TasteEvent]) -> Double { taste(events).cuisines[recipe.cuisine, default: 0] }
        XCTAssertGreaterThan(cuisine([liked]), cuisine([cooked]))
        XCTAssertGreaterThan(cuisine([liked]), cuisine([oldLike]))
        XCTAssertEqual(cuisine([liked, liked, future]), cuisine([liked]), accuracy: 1e-12)
        XCTAssertEqual(cuisine([liked, cleared]), 0)
        let repeated = (1...100).map { TasteEvent(recipeId: recipe.id, kind: .cookedAgain, date: date.addingTimeInterval(-Double($0))) }
        XCTAssertLessThanOrEqual(cuisine(repeated), 0.5)
        XCTAssertTrue(taste([liked]).positiveRecipeIds.contains(recipe.id))
        XCTAssertFalse(taste([liked]).proteins.isEmpty)
        XCTAssertFalse(taste([liked]).ingredients.isEmpty)
        XCTAssertFalse(taste([liked]).vibes.isEmpty)
        XCTAssertFalse(taste([liked]).effortBands.isEmpty)
        XCTAssertFalse(taste([liked]).budgetBands.isEmpty)
    }

    func testTiredParentGetsMildWeeknightMealsAndOneBatch() throws {
        let profile = PlannerProfile(maxCookMinutes: 30, goals: [.saveTime, .feedFamily], obstacles: [.tooTired], children: 2)
        let request = TestSupport.request(profile: profile, days: [1, 2, 3, 4, 5, 6, 7], servings: 3, budget: 90)
        let plan = planner.plan(request)
        XCTAssertEqual(plan.meals.count, 7)
        XCTAssertLessThanOrEqual(plan.estimatedTotal, 90)
        let leftovers = plan.meals.filter { $0.reason == .plannedLeftovers }
        XCTAssertEqual(leftovers.count, 1)
        let leftover = try XCTUnwrap(leftovers.first)
        let original = try XCTUnwrap(plan.meals.first { $0.slotIndex == leftover.leftoversFromSlotIndex })
        XCTAssertEqual(original.reason, .batchCooking)
        XCTAssertEqual(original.recipeId, leftover.recipeId)
        XCTAssertEqual(leftover.weekday, original.weekday + 1)
        let recipes = plan.meals.compactMap { catalog.recipe(id: $0.recipeId) }
        XCTAssertTrue(recipes.allSatisfy { !RecipeClassifier.profile(for: $0, catalog: catalog).isSpicy })
        for meal in plan.meals where meal.weekday <= 4 && meal.leftoversFromSlotIndex == nil {
            let recipe = try XCTUnwrap(catalog.recipe(id: meal.recipeId))
            let traits = planner.traits(for: recipe, pricing: request.pricing)
            XCTAssertLessThan(traits.effort, 0.55)
            XCTAssertGreaterThanOrEqual(traits.kidFriendly, 0.64)
            XCTAssertLessThanOrEqual(recipe.handsOnMinutes, 30)
        }
        let standalone = GroceryAggregator.aggregate(meals: recipes.map { MealPortion(recipe: $0, servings: 3, weekday: 1) },
                                                     catalog: catalog, pricing: request.pricing, unitSystem: request.unitSystem)
        XCTAssertEqual(standalone.total, plan.estimatedTotal, accuracy: 0.0001)
        XCTAssertLessThan(plan.groceryList.standaloneTotal, standalone.standaloneTotal)
        XCTAssertEqual(plan.meals.reduce(0) { $0 + $1.allocatedCost }, plan.estimatedTotal, accuracy: 0.0001)
        printMetrics("Tired parent", plan: plan, request: request)
    }

    func testStudentStaysUnderBudgetAndPicksCheapRecipes() {
        var request = TestSupport.request(profile: PlannerProfile(goals: [.spendLess]), servings: 1, budget: 25)
        request.pricing = PriceContext(region: .UK, tier: .budget)
        let plan = planner.plan(request)
        let traits = plan.meals.compactMap { catalog.recipe(id: $0.recipeId) }.map { planner.traits(for: $0, pricing: request.pricing) }
        XCTAssertLessThanOrEqual(plan.estimatedTotal, 25)
        XCTAssertGreaterThanOrEqual(traits.filter { $0.budgetBand == .cheap }.count, 3)
        XCTAssertFalse(traits.contains { $0.budgetBand == .treat })
        XCTAssertGreaterThan(plan.groceryList.savingsFromSharing, 0)
        printMetrics("Student", plan: plan, request: request)
    }

    func testGymGoerGetsProteinOnMostDays() {
        let profile = PlannerProfile(vibes: [.highProtein], goals: [.eatHealthier])
        let request = TestSupport.request(profile: profile, budget: 85)
        let plan = planner.plan(request)
        let highProtein = plan.meals.compactMap { catalog.recipe(id: $0.recipeId) }.filter {
            NutritionCalculator.perServing($0, catalog: catalog).macros.protein >= 28
        }
        XCTAssertGreaterThanOrEqual(highProtein.count, 3)
        printMetrics("Gym-goer", plan: plan, request: request)
    }

    func testFoodGoesOffIncreasesFreshReuse() throws {
        // The comparison with the previous planner used the catalog through this recipe.
        // Keep the same input pool when adding new batches.
        let end = try XCTUnwrap(catalog.recipes.firstIndex { $0.id == "mango-lassi-pops" })
        let benchmarkRecipes = Array(catalog.recipes[...end])
        var request = TestSupport.request(budget: 75, seed: 62, recipes: benchmarkRecipes)
        let withoutPreference = planner.plan(request)
        request.profile.obstacles = [.foodGoesOff]
        let withPreference = planner.plan(request)
        XCTAssertGreaterThan(freshReuse(withPreference), freshReuse(withoutPreference))
        // The previous planner reused six fresh items on this same catalog and seed.
        XCTAssertGreaterThan(freshReuse(withPreference), 6)
        printMetrics("Freshness preference off", plan: withoutPreference, request: request)
        printMetrics("Food goes off", plan: withPreference, request: request)
    }

    func testLearningChangesCuisineMixWithoutBreakingCaps() {
        let pool = catalog.recipes.filter { $0.mealType == .dinner }
        var request = TestSupport.request(days: [1, 2, 3, 4, 5], budget: 100, seed: 12)
        let recent = TestSupport.monday.addingTimeInterval(-7 * 86_400)
        request.tasteAsOf = TestSupport.monday
        let baseline = planner.plan(request)
        let cooked = pool.filter { $0.cuisine == .mexican }.prefix(12)
        let skipped = pool.filter { $0.cuisine == .indian || $0.cuisine == .thai }.prefix(14)
        request.tasteEvents = (1...4).flatMap { week -> [TasteEvent] in
            let date = recent.addingTimeInterval(-Double(week) * 7 * 86_400)
            return cooked.map { TasteEvent(recipeId: $0.id, kind: .cooked, date: date) }
                + skipped.map { TasteEvent(recipeId: $0.id, kind: .skipped, date: date) }
        }
        let applied = planner.plan(request)
        func cuisines(_ plan: PlanResult) -> [Cuisine: Int] {
            Dictionary(grouping: plan.meals.compactMap { catalog.recipe(id: $0.recipeId) }, by: \.cuisine).mapValues(\.count)
        }
        let before = cuisines(baseline)
        let after = cuisines(applied)
        XCTAssertGreaterThan(after[.mexican, default: 0], before[.mexican, default: 0])
        XCTAssertLessThan(after[.indian, default: 0] + after[.thai, default: 0], before[.indian, default: 0] + before[.thai, default: 0])
        XCTAssertLessThanOrEqual(after.values.max() ?? 0, 2)
        XCTAssertEqual(applied.meals, planner.plan(request).meals)
        XCTAssertLessThanOrEqual(applied.meals.filter { if case .similarTo = $0.reason { return true }; return false }.count, 1)
        printMetrics("Learning before", plan: baseline, request: request)
        printMetrics("Learning after", plan: applied, request: request)
    }

    func testLearnedAndLockedRecipesCannotOverrideHardExclusion() throws {
        let recipe = try XCTUnwrap(catalog.recipe(id: "shakshuka"))
        let request = TestSupport.request(feedback: FeedbackSummary(notForMe: [recipe.id], stars: [recipe.id: 5]),
                                          locked: [0: LockedMeal(recipeId: recipe.id, servings: 2)])
        XCTAssertFalse(planner.plan(request).meals.contains { $0.recipeId == recipe.id })
    }

    func testPlannerAt1500Recipes() {
        let base = catalog.recipes.filter { $0.mealType == .dinner }
        let recipes = (0..<1_500).map { index -> Recipe in
            var recipe = base[index % base.count]
            recipe.id += "-benchmark-\(index)"
            return recipe
        }
        let request = TestSupport.request(days: [1, 2, 3, 4, 5, 6, 7], budget: 20, recipes: recipes)
        let coldStart = ProcessInfo.processInfo.systemUptime
        let first = planner.plan(request)
        let cold = ProcessInfo.processInfo.systemUptime - coldStart
        let warmStart = ProcessInfo.processInfo.systemUptime
        let second = planner.plan(request)
        let warm = ProcessInfo.processInfo.systemUptime - warmStart
        XCTAssertEqual(first.meals.count, 7)
        XCTAssertEqual(first.meals, second.meals)
        XCTAssertLessThan(cold, 2)
        XCTAssertLessThan(warm, 2)
        print("1500 recipes: cold \(Int(cold * 1000)) ms, warm \(Int(warm * 1000)) ms")
    }

    private func freshReuse(_ plan: PlanResult) -> Int {
        plan.groceryList.allItems.filter {
            [.produce, .meatFish, .dairyEggs].contains($0.aisle) && $0.usedOnWeekdays.count > 1
        }.count
    }

    private func printMetrics(_ name: String, plan: PlanResult, request: PlannerRequest) {
        let recipes = plan.meals.compactMap { catalog.recipe(id: $0.recipeId) }
        let cooking = plan.meals.filter { $0.leftoversFromSlotIndex == nil }.compactMap { catalog.recipe(id: $0.recipeId) }
        let effort = cooking.map { planner.traits(for: $0, pricing: request.pricing).effort }.reduce(0, +)
        let highProtein = recipes.filter { NutritionCalculator.perServing($0, catalog: catalog).macros.protein >= 28 }.count
        let cuisines = Set(recipes.map(\.cuisine)).count
        print("\(name): cost=\(String(format: "%.2f", plan.estimatedTotal)), effort=\(String(format: "%.2f", effort / Double(max(1, recipes.count)))), freshReuse=\(freshReuse(plan)), cuisines=\(cuisines), higherProtein=\(highProtein)")
    }
}
