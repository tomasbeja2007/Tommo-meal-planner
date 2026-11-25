import XCTest
@testable import ForkcastCore

final class PlannerTests: XCTestCase {
    let catalog = TestSupport.catalog
    lazy var planner = MealPlanner(catalog: catalog)

    func profile(of id: String) -> RecipeProfile {
        RecipeClassifier.profile(for: catalog.recipe(id: id)!, catalog: catalog)
    }

    func testFillsEveryCookingDay() {
        let result = planner.plan(TestSupport.request(days: [1, 2, 3, 4, 5, 6, 7]))
        XCTAssertEqual(result.meals.count, 7)
        XCTAssertEqual(Set(result.meals.map { $0.recipeId }).count, 7, "no repeated recipe in a week")
    }

    func testAllergensNeverAppearAcross100Seeds() {
        var rng = SeededRandom(seed: 99)
        for seed in 0..<100 {
            var allergens: Set<Allergen> = []
            for allergen in Allergen.allCases where rng.nextUnit() < 0.3 {
                allergens.insert(allergen)
            }
            if allergens.isEmpty { allergens = [.gluten] }
            let request = TestSupport.request(profile: PlannerProfile(allergens: allergens), days: [1, 2, 3, 4, 5, 6, 7], seed: UInt64(seed))
            let result = planner.plan(request)
            for meal in result.meals {
                let found = profile(of: meal.recipeId).allergens
                XCTAssertTrue(found.isDisjoint(with: allergens), "seed \(seed): \(meal.recipeId) contains \(found.intersection(allergens))")
            }
            // Alternatives must respect allergens too.
            if let first = result.meals.first {
                var current: [Int: LockedMeal] = [:]
                for meal in result.meals { current[meal.slotIndex] = LockedMeal(recipeId: meal.recipeId, servings: meal.servings) }
                for alt in planner.alternatives(for: first.slotIndex, current: current, request: request) {
                    XCTAssertTrue(profile(of: alt.recipeId).allergens.isDisjoint(with: allergens))
                }
            }
        }
    }

    func testDietIsRespected() {
        for diet in Diet.allCases {
            for seed in 0..<20 {
                let result = planner.plan(TestSupport.request(profile: PlannerProfile(diet: diet), days: [1, 2, 3, 4, 5, 6, 7], seed: UInt64(seed)))
                XCTAssertFalse(result.meals.isEmpty)
                for meal in result.meals {
                    XCTAssertTrue(profile(of: meal.recipeId).diet.isCompatible(with: diet), "\(diet): \(meal.recipeId)")
                }
            }
        }
    }

    func testDislikesAndAppliancesAreRespected() {
        let rules = PlannerProfile(
            dislikes: ["mushrooms", DislikeCatalog.spicy, DislikeCatalog.pork, "cilantro"],
            appliances: [.stovetop, .oven]
        )
        for seed in 0..<30 {
            let result = planner.plan(TestSupport.request(profile: rules, seed: UInt64(seed)))
            for meal in result.meals {
                let recipe = catalog.recipe(id: meal.recipeId)!
                let p = profile(of: meal.recipeId)
                XCTAssertFalse(p.ingredientIds.contains("mushrooms"))
                XCTAssertFalse(p.ingredientIds.contains("cilantro"))
                XCTAssertFalse(p.isSpicy, meal.recipeId)
                XCTAssertFalse(p.proteinGroups.contains(.pork), meal.recipeId)
                XCTAssertTrue(Set(recipe.appliances).isSubset(of: [.stovetop, .oven]), meal.recipeId)
            }
        }
    }

    func testNotForMeIsNeverPlanned() {
        let banned: Set<String> = Set(catalog.recipes.prefix(10).map { $0.id })
        let result = planner.plan(TestSupport.request(feedback: FeedbackSummary(notForMe: banned)))
        XCTAssertTrue(result.meals.allSatisfy { !banned.contains($0.recipeId) })
    }

    func testTimeLimitIsAppliedAndOnlyRelaxedWhenNeeded() {
        let quick = PlannerProfile(maxCookMinutes: 30)
        let result = planner.plan(TestSupport.request(profile: quick))
        XCTAssertFalse(result.relaxedTimeLimit)
        for meal in result.meals {
            XCTAssertLessThanOrEqual(catalog.recipe(id: meal.recipeId)!.handsOnMinutes, 40)
        }
        // Vegan + very short time + microwave only forces relaxation, but other rules hold.
        let strict = PlannerProfile(diet: .vegan, appliances: [.stovetop], maxCookMinutes: 20)
        let relaxed = planner.plan(TestSupport.request(profile: strict, days: [1, 2, 3, 4, 5, 6, 7]))
        XCTAssertTrue(relaxed.relaxedTimeLimit)
        for meal in relaxed.meals {
            XCTAssertEqual(profile(of: meal.recipeId).diet, .vegan)
            XCTAssertEqual(catalog.recipe(id: meal.recipeId)!.appliances, [.stovetop])
        }
    }

    func testVarietyRules() {
        for seed in 0..<50 {
            let result = planner.plan(TestSupport.request(days: [1, 2, 3, 4, 5, 6, 7], seed: UInt64(seed)))
            var proteins: [ProteinGroup: Int] = [:]
            var cuisines: [Cuisine: Int] = [:]
            for meal in result.meals {
                proteins[profile(of: meal.recipeId).mainProtein, default: 0] += 1
                cuisines[catalog.recipe(id: meal.recipeId)!.cuisine, default: 0] += 1
            }
            XCTAssertLessThanOrEqual(proteins.values.max() ?? 0, 2, "seed \(seed): \(proteins)")
            XCTAssertLessThanOrEqual(cuisines.values.max() ?? 0, 2, "seed \(seed): \(cuisines)")
        }
    }

    func testDeterministicForSameSeedAndDifferentAcrossRegenerations() {
        let a = planner.plan(TestSupport.request(seed: 7)).meals.map { $0.recipeId }
        let b = planner.plan(TestSupport.request(seed: 7)).meals.map { $0.recipeId }
        XCTAssertEqual(a, b)
        var distinct: Set<[String]> = []
        for regeneration in 0..<6 {
            let seed = SeededRandom.seed(weekStart: TestSupport.monday, regeneration: regeneration)
            distinct.insert(planner.plan(TestSupport.request(seed: seed)).meals.map { $0.recipeId })
        }
        XCTAssertGreaterThan(distinct.count, 1, "regenerating should give different weeks")
    }

    func testBudgetFitting() {
        let generous = planner.plan(TestSupport.request(budget: 1000, seed: 3))
        XCTAssertEqual(generous.overBudgetBy, 0)

        // A tighter budget produces a cheaper (or equal) basket, without breaking rules.
        let target = generous.estimatedTotal * 0.75
        let tight = planner.plan(TestSupport.request(budget: target, seed: 3))
        XCTAssertLessThanOrEqual(tight.estimatedTotal, generous.estimatedTotal + 0.001)
        XCTAssertEqual(tight.meals.count, generous.meals.count)
        if tight.estimatedTotal > target {
            XCTAssertEqual(tight.overBudgetBy, tight.estimatedTotal - target, accuracy: 0.001, "honestly reports the overage")
        } else {
            XCTAssertEqual(tight.overBudgetBy, 0)
        }

        // Impossible budget: keeps a valid full plan and reports how far over it is.
        let impossible = planner.plan(TestSupport.request(profile: PlannerProfile(allergens: [.dairy]), budget: 5, seed: 3))
        XCTAssertEqual(impossible.meals.count, 5)
        XCTAssertGreaterThan(impossible.overBudgetBy, 0)
        for meal in impossible.meals {
            XCTAssertFalse(profile(of: meal.recipeId).allergens.contains(.dairy))
        }
    }

    func testMealCostsAddUpToTotal() {
        let result = planner.plan(TestSupport.request(seed: 11))
        let sum = result.meals.reduce(0) { $0 + $1.allocatedCost }
        XCTAssertEqual(sum, result.estimatedTotal, accuracy: 0.01)
        XCTAssertTrue(result.meals.allSatisfy { $0.allocatedCost > 0 })
    }

    func testLockedMealsAreKept() {
        let locked: [Int: LockedMeal] = [0: LockedMeal(recipeId: "shakshuka", servings: 3), 2: LockedMeal(recipeId: "black-bean-tacos", servings: 2)]
        let result = planner.plan(TestSupport.request(locked: locked))
        XCTAssertEqual(result.meals.first { $0.slotIndex == 0 }?.recipeId, "shakshuka")
        XCTAssertEqual(result.meals.first { $0.slotIndex == 0 }?.servings, 3)
        XCTAssertEqual(result.meals.first { $0.slotIndex == 2 }?.recipeId, "black-bean-tacos")
    }

    func testLikedAndVibesScoreHigher() {
        let request = TestSupport.request(profile: PlannerProfile(vibes: [.quickEasy]), feedback: FeedbackSummary(liked: ["shakshuka"], stars: ["shakshuka": 5]))
        let liked = planner.score(catalog.recipe(id: "shakshuka")!, request: request)
        let plain = planner.score(catalog.recipe(id: "mushroom-pea-risotto")!, request: request)
        XCTAssertEqual(liked, 3 + 4 + 2)
        XCTAssertEqual(plain, 0)
        let recent = TestSupport.request(history: ["shakshuka": 1, "mushroom-pea-risotto": 4])
        XCTAssertEqual(planner.score(catalog.recipe(id: "shakshuka")!, request: recent), -5)
        XCTAssertEqual(planner.score(catalog.recipe(id: "mushroom-pea-risotto")!, request: recent), -1)
    }

    func testAlternativesExcludePlannedRecipesAndReportCostDelta() {
        let request = TestSupport.request(seed: 5)
        let result = planner.plan(request)
        var current: [Int: LockedMeal] = [:]
        for meal in result.meals { current[meal.slotIndex] = LockedMeal(recipeId: meal.recipeId, servings: meal.servings) }
        let alternatives = planner.alternatives(for: 1, current: current, request: request)
        XCTAssertEqual(alternatives.count, 3)
        let planned = Set(result.meals.map { $0.recipeId })
        for alt in alternatives {
            XCTAssertFalse(planned.contains(alt.recipeId))
            XCTAssertTrue(alt.costDelta.isFinite)
        }
    }

    func testUserRecipesCanBePlanned() {
        let mine = Recipe(id: "user:abc", title: "My beans on toast", emoji: "🍞", cuisine: .british, vibes: [.quickEasy], appliances: [.stovetop], prepMinutes: 2, cookMinutes: 5, baseServings: 2,
                          ingredients: [RecipeIngredient(ingredientId: "cannellini-beans", amount: 240, unit: .g), RecipeIngredient(ingredientId: "sourdough", amount: 4, unit: .slice), RecipeIngredient(ingredientId: nil, name: "Secret sauce", amount: 2, unit: .tbsp)],
                          steps: ["Heat the beans.", "Toast the bread.", "Serve."], source: .manual)
        let request = TestSupport.request(profile: PlannerProfile(vibes: [.quickEasy]), feedback: FeedbackSummary(liked: [mine.id]), recipes: catalog.recipes + [mine])
        let result = planner.plan(request)
        XCTAssertTrue(result.meals.contains { $0.recipeId == mine.id }, "a liked user recipe with matching vibe should be picked")
        XCTAssertTrue(result.groceryList.allItems.contains { $0.name == "Secret sauce" })
    }

    func testPlannerIsFast() {
        let request = TestSupport.request(days: [1, 2, 3, 4, 5, 6, 7], budget: 40)
        let start = Date()
        _ = planner.plan(request)
        let elapsed = Date().timeIntervalSince(start)
        // Target is < 200 ms on device in release; debug builds on CI are slower.
        XCTAssertLessThan(elapsed, 2.0)
        print("planner took \(Int(elapsed * 1000)) ms (debug)")
    }

    func testMealPrepModeFavoursLeftoverFriendlyDinners() {
        let prep = TestSupport.request(profile: PlannerProfile(prefersMealPrep: true))
        let keeps = planner.score(catalog.recipe(id: "chickpea-spinach-curry")!, request: prep)
        let doesNot = planner.score(catalog.recipe(id: "mushroom-pea-risotto")!, request: prep)
        XCTAssertEqual(keeps, 2)
        XCTAssertEqual(doesNot, 0)
        let normal = TestSupport.request()
        XCTAssertEqual(planner.score(catalog.recipe(id: "chickpea-spinach-curry")!, request: normal), 0)
    }

    func testExplicitMealPrepLinksShareOneBatchAndCountEveryPortion() throws {
        let profile = PlannerProfile(prefersMealPrep: true, mealPrepEdges: [1, 2, 3, 4, 5])
        let request = TestSupport.request(profile: profile, days: [1, 2, 3, 4, 5, 6], servings: 2, budget: 55)
        let result = planner.plan(request)
        XCTAssertEqual(result.meals.count, 6)
        let source = try XCTUnwrap(result.meals.first)
        let batch = result.meals.filter { $0.leftoversFromSlotIndex == source.slotIndex }
        XCTAssertEqual(batch.map(\.weekday), [2, 3, 4, 5])
        XCTAssertTrue(batch.allSatisfy { $0.recipeId == source.recipeId })
        XCTAssertNil(result.meals.last?.leftoversFromSlotIndex)
        let portions = try result.meals.map { draft in
            try MealPortion(recipe: XCTUnwrap(catalog.recipe(id: draft.recipeId)),
                            servings: draft.servings, weekday: draft.weekday)
        }
        let unbatched = GroceryAggregator.aggregate(meals: portions, catalog: catalog,
                                                     pricing: request.pricing, unitSystem: request.unitSystem)
        let batchQuantities = result.groceryList.allItems.map(\.neededBase)
        XCTAssertEqual(batchQuantities, unbatched.allItems.map(\.neededBase))
        XCTAssertEqual(result.estimatedTotal, unbatched.total, accuracy: 0.001)
        XCTAssertEqual(result.meals.reduce(0) { $0 + $1.allocatedCost }, result.estimatedTotal, accuracy: 0.001)
    }

    func testExplicitMealPrepWithNoLinksLeavesEvenAdjacentDaysIndependent() {
        let profile = PlannerProfile(prefersMealPrep: true, obstacles: [.tooTired], mealPrepEdges: [])
        let result = planner.plan(TestSupport.request(profile: profile, days: [1, 2, 3]))
        XCTAssertEqual(result.meals.count, 3)
        XCTAssertTrue(result.meals.allSatisfy { $0.leftoversFromSlotIndex == nil })
    }

    func testPreferredCuisineScoresHigher() {
        let request = TestSupport.request(profile: PlannerProfile(preferredCuisines: [.mediterranean]))
        let mediterranean = catalog.recipes.first { $0.cuisine == .mediterranean && !$0.isLeftoverFriendly }!
        let other = catalog.recipes.first { $0.cuisine != .mediterranean }!
        XCTAssertEqual(planner.score(mediterranean, request: request), 2)
        XCTAssertEqual(planner.score(other, request: request), 0)
    }

    func testSlotsCoverEveryMealTypeInDayOrder() {
        let slots = WeekMath.slots(from: TestSupport.monday, cookingDays: [1, 2], mealTypes: [.dinner, .breakfast, .snack])
        XCTAssertEqual(slots.map { $0.mealType }, [.breakfast, .dinner, .snack, .breakfast, .dinner, .snack])
        XCTAssertEqual(slots.map { $0.index }, Array(0..<6))
        XCTAssertEqual(WeekMath.slots(from: TestSupport.monday, cookingDays: [1, 2]).map { $0.mealType }, [.dinner, .dinner])
    }

    func testEverySlotGetsARecipeOfItsMealType() {
        let all: Set<MealType> = Set(MealType.allCases)
        for seed in 0..<20 {
            let request = TestSupport.request(days: [1, 2, 3, 4, 5, 6, 7], mealTypes: all, seed: UInt64(seed))
            let result = planner.plan(request)
            XCTAssertEqual(result.meals.count, 28, "seed \(seed)")
            for meal in result.meals {
                XCTAssertEqual(catalog.recipe(id: meal.recipeId)?.mealType, meal.mealType, "seed \(seed): \(meal.recipeId)")
            }
        }
    }

    func testBreakfastsAndSnacksRepeatAtMostTwiceAndDinnersNever() {
        let all: Set<MealType> = Set(MealType.allCases)
        for seed in 0..<20 {
            let result = planner.plan(TestSupport.request(days: [1, 2, 3, 4, 5, 6, 7], mealTypes: all, seed: UInt64(seed)))
            var uses: [String: Int] = [:]
            for meal in result.meals { uses[meal.recipeId, default: 0] += 1 }
            for (id, count) in uses {
                let type: MealType = catalog.recipe(id: id)?.mealType ?? .dinner
                XCTAssertLessThanOrEqual(count, type.maxUsesPerWeek, "seed \(seed): \(id) used \(count)×")
            }
        }
    }

    func testAllergensNeverAppearInAnyMealType() {
        let all: Set<MealType> = Set(MealType.allCases)
        let rules = PlannerProfile(allergens: [.peanut, .treeNut, .dairy])
        for seed in 0..<20 {
            let result = planner.plan(TestSupport.request(profile: rules, days: [1, 2, 3, 4, 5, 6, 7], mealTypes: all, seed: UInt64(seed)))
            for meal in result.meals {
                let profile = RecipeClassifier.profile(for: catalog.recipe(id: meal.recipeId)!, catalog: catalog)
                XCTAssertTrue(profile.allergens.isDisjoint(with: rules.allergens), "seed \(seed): \(meal.recipeId)")
            }
        }
    }

    func testSwapAlternativesStayInTheSameMealType() {
        let request = TestSupport.request(mealTypes: [.breakfast, .dinner], seed: 9)
        let result = planner.plan(request)
        guard let breakfast = result.meals.first(where: { $0.mealType == .breakfast }) else { return XCTFail("no breakfast planned") }
        var current: [Int: LockedMeal] = [:]
        for meal in result.meals { current[meal.slotIndex] = LockedMeal(recipeId: meal.recipeId, servings: meal.servings) }
        let options = planner.alternatives(for: breakfast.slotIndex, current: current, request: request)
        XCTAssertFalse(options.isEmpty)
        for option in options {
            XCTAssertEqual(catalog.recipe(id: option.recipeId)?.mealType, .breakfast, option.recipeId)
        }
    }

    func testBudgetCountsMealsByWeight() {
        XCTAssertEqual(BudgetMath.dinnerEquivalents(days: 5), 5)
        XCTAssertEqual(BudgetMath.dinnerEquivalents(days: 5, mealTypes: [.breakfast, .dinner]), 6.75, accuracy: 0.001)
        let dinners = BudgetMath.defaultBudget(region: .US, portions: 2, days: 5)
        let everything = BudgetMath.defaultBudget(region: .US, portions: 2, days: 5, mealTypes: Set(MealType.allCases))
        XCTAssertGreaterThan(everything, dinners * 2)
    }

    // MARK: Calorie target

    func testPortionScaleSteps() {
        XCTAssertEqual(MealPlanner.portionScale(goal: 3_000, planned: 1_590), 2.0)
        XCTAssertEqual(MealPlanner.portionScale(goal: 2_000, planned: 1_600), 1.25)
        XCTAssertEqual(MealPlanner.portionScale(goal: 1_000, planned: 2_500), 0.75)
        XCTAssertEqual(MealPlanner.portionScale(goal: 2_000, planned: 0), 1)
    }

    func testNoCalorieTargetKeepsStandardPortions() {
        let request = TestSupport.request(mealTypes: [.breakfast, .lunch, .dinner, .snack], servings: 1)
        let result = planner.plan(request)
        XCTAssertFalse(result.meals.isEmpty)
        XCTAssertTrue(result.meals.allSatisfy { $0.servings == 1 })
    }

    func testCalorieTargetSizesEachDay() {
        var profile = PlannerProfile()
        profile.dailyCalories = 3_000
        let request = TestSupport.request(profile: profile, days: [1, 2, 3, 4, 5, 6, 7],
                                          mealTypes: [.breakfast, .lunch, .dinner, .snack], servings: 1, budget: 5_000)
        let result = planner.plan(request)
        let days = Dictionary(grouping: result.meals) { WeekMath.gregorian.startOfDay(for: $0.date) }
        XCTAssertEqual(days.count, 7)
        for (day, meals) in days {
            let kcal = meals.reduce(0.0) { total, meal in
                guard let recipe = catalog.recipe(id: meal.recipeId) else { return total }
                return total + NutritionCalculator.perServing(recipe, catalog: catalog).macros.kcal * meal.servings
            }
            let atMaximum = meals.allSatisfy { $0.servings >= MealPlanner.portionScaleRange.upperBound }
            XCTAssertTrue(atMaximum || abs(kcal - 3_000) <= 3_000 * 0.15, "\(day): \(Int(kcal)) kcal")
            XCTAssertTrue(meals.allSatisfy { $0.servings >= 1 }, "a 3,000 kcal day never shrinks portions")
        }
    }
}
