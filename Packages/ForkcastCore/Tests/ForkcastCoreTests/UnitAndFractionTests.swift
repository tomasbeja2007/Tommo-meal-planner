import XCTest
@testable import ForkcastCore

final class UnitAndFractionTests: XCTestCase {
    let catalog = TestSupport.catalog

    func testDailyNutritionTargetPresetsAndCustomSplit() throws {
        var target = NutritionTarget()
        XCTAssertEqual(target.calories, 2_000)
        XCTAssertEqual(target.grams.protein, 150)
        XCTAssertEqual(target.grams.carbs, 200)
        XCTAssertEqual(target.grams.fat, 67)

        for preset in NutritionTarget.Preset.allCases {
            target.preset = preset
            let split = target.percentages
            XCTAssertEqual(split.protein + split.carbs + split.fat, 100)
        }

        target.preset = .custom
        target.customProteinPercent = 60
        target.customCarbPercent = 25
        XCTAssertEqual(target.percentages.fat, 15)
        let data = try JSONEncoder().encode(target)
        XCTAssertEqual(try JSONDecoder().decode(NutritionTarget.self, from: data), target)

        target.customCarbPercent = 70
        XCTAssertEqual(target.percentages.carbs, 40)
        XCTAssertEqual(target.percentages.fat, 0)
    }

    func testFractionFormatting() {
        XCTAssertEqual(FractionFormatter.string(0.5), "½")
        XCTAssertEqual(FractionFormatter.string(0.333), "⅓")
        XCTAssertEqual(FractionFormatter.string(0.666), "⅔")
        XCTAssertEqual(FractionFormatter.string(1.5), "1½")
        XCTAssertEqual(FractionFormatter.string(2.25), "2¼")
        XCTAssertEqual(FractionFormatter.string(2), "2")
        XCTAssertEqual(FractionFormatter.string(0.97), "1")
        XCTAssertEqual(FractionFormatter.string(0.02), "⅛")
        XCTAssertEqual(FractionFormatter.string(12.4), "12")
        XCTAssertEqual(FractionFormatter.string(0), "0")
    }

    func testFractionParsing() {
        XCTAssertEqual(FractionFormatter.parse("1/2") ?? 0, 0.5, accuracy: 0.0001)
        XCTAssertEqual(FractionFormatter.parse("1 1/2") ?? 0, 1.5, accuracy: 0.0001)
        XCTAssertEqual(FractionFormatter.parse("½") ?? 0, 0.5, accuracy: 0.0001)
        XCTAssertEqual(FractionFormatter.parse("1½") ?? 0, 1.5, accuracy: 0.0001)
        XCTAssertEqual(FractionFormatter.parse("2.5") ?? 0, 2.5, accuracy: 0.0001)
        XCTAssertEqual(FractionFormatter.parse("2,5") ?? 0, 2.5, accuracy: 0.0001)
        XCTAssertEqual(FractionFormatter.parse("2-3") ?? 0, 2, accuracy: 0.0001)
        XCTAssertNil(FractionFormatter.parse("abc"))
    }

    func testConversions() {
        let oil = catalog.ingredient(id: "olive-oil")!
        XCTAssertEqual(UnitConverter.grams(amount: 1, unit: .tbsp, ingredient: oil) ?? 0, 13.5, accuracy: 0.01)
        XCTAssertEqual(UnitConverter.baseAmount(amount: 2, unit: .tbsp, ingredient: oil) ?? 0, 30, accuracy: 0.01)
        let onion = catalog.ingredient(id: "onion")!
        XCTAssertEqual(UnitConverter.grams(amount: 2, unit: .piece, ingredient: onion) ?? 0, 300, accuracy: 0.01)
        let eggs = catalog.ingredient(id: "eggs")!
        XCTAssertEqual(UnitConverter.baseAmount(amount: 3, unit: .piece, ingredient: eggs) ?? 0, 3, accuracy: 0.01)
        XCTAssertEqual(UnitConverter.baseAmount(amount: 100, unit: .g, ingredient: eggs) ?? 0, 2, accuracy: 0.01)
        XCTAssertEqual(UnitConverter.grams(amount: 1, unit: .lb, ingredient: nil) ?? 0, 453.592, accuracy: 0.01)
        XCTAssertNil(UnitConverter.grams(amount: 1, unit: .piece, ingredient: catalog.ingredient(id: "ground-beef")!))
    }

    func testQuantityDisplay() {
        XCTAssertEqual(QuantityFormatter.string(amount: 400, unit: .g, system: .metric, ingredient: nil), "400 g")
        XCTAssertEqual(QuantityFormatter.string(amount: 400, unit: .g, system: .imperial, ingredient: nil), "14 oz")
        XCTAssertEqual(QuantityFormatter.string(amount: 500, unit: .g, system: .imperial, ingredient: nil), "1 lb")
        XCTAssertEqual(QuantityFormatter.string(amount: 1500, unit: .g, system: .metric, ingredient: nil), "1.5 kg")
        XCTAssertEqual(QuantityFormatter.string(amount: 80, unit: .ml, system: .imperial, ingredient: nil), "⅓ cup")
        XCTAssertEqual(QuantityFormatter.string(amount: 400, unit: .ml, system: .imperial, ingredient: nil), "1⅔ cups")
        XCTAssertEqual(QuantityFormatter.string(amount: 30, unit: .ml, system: .imperial, ingredient: nil), "2 tbsp")
        XCTAssertEqual(QuantityFormatter.string(amount: 0.5, unit: .tsp, system: .metric, ingredient: nil), "½ tsp")
        XCTAssertEqual(QuantityFormatter.string(amount: 3, unit: .clove, system: .metric, ingredient: nil), "3 cloves")
        XCTAssertEqual(QuantityFormatter.string(amount: 1, unit: .clove, system: .metric, ingredient: nil), "1 clove")
        XCTAssertEqual(QuantityFormatter.string(amount: 0.333, unit: .cup, system: .imperial, ingredient: nil), "⅓ cup")
        XCTAssertEqual(QuantityFormatter.string(amount: 1, unit: .cup, system: .metric, ingredient: nil), "240 ml")
        XCTAssertEqual(QuantityFormatter.string(amount: 1.5, unit: .piece, system: .metric, ingredient: nil), "1½")
        XCTAssertEqual(QuantityFormatter.string(amount: 1, unit: .toTaste, system: .metric, ingredient: nil), "to taste")
    }

    func testMetricRounding() {
        XCTAssertEqual(QuantityFormatter.mass(grams: 123, system: .metric), "120 g")
        XCTAssertEqual(QuantityFormatter.mass(grams: 47, system: .metric), "45 g")
        XCTAssertEqual(QuantityFormatter.mass(grams: 7.4, system: .metric), "7 g")
    }

    func testNamesFollowUnitSystem() {
        let eggplant = catalog.ingredient(id: "eggplant")!
        XCTAssertEqual(eggplant.displayName(for: .imperial), "eggplant")
        XCTAssertEqual(eggplant.displayName(for: .metric), "aubergine")
    }

    func testNutritionScalesPerServingAndOverride() {
        var recipe = catalog.recipe(id: "shakshuka")!
        let base = NutritionCalculator.perServing(recipe, catalog: catalog)
        XCTAssertGreaterThan(base.macros.protein, 10)
        recipe.macroOverride = Macros(kcal: 400, protein: 20, carbs: 30, fat: 10)
        let manual = NutritionCalculator.perServing(recipe, catalog: catalog)
        XCTAssertTrue(manual.isManualOverride)
        XCTAssertEqual(manual.macros.kcal, 400)
        recipe.macroOverride = nil
        recipe.ingredients.append(RecipeIngredient(ingredientId: nil, name: "mystery spice", amount: 1, unit: .tsp))
        XCTAssertTrue(NutritionCalculator.perServing(recipe, catalog: catalog).hasIncompleteData)
    }

    func testBudgetMath() {
        XCTAssertEqual(BudgetMath.portions(adults: 2, kids: 2), 3)
        XCTAssertEqual(BudgetMath.defaultBudget(region: .US, portions: 3, days: 5), 55)
        let range = BudgetMath.range(region: .US, portions: 2, days: 5)
        XCTAssertEqual(range.lowerBound, 35)
        XCTAssertEqual(range.upperBound, 250)
        XCTAssertEqual(BudgetMath.verdict(budget: 20, portions: 2, days: 5, region: .US), .tight)
        XCTAssertEqual(BudgetMath.verdict(budget: 50, portions: 2, days: 5, region: .US), .comfortable)
        XCTAssertEqual(BudgetMath.verdict(budget: 150, portions: 2, days: 5, region: .US), .plenty)
        let savings = BudgetMath.estimatedSavings(budget: 50, portions: 2, days: 5, region: .US)
        // 10 portions: 10 × 9 − 50 = 40 → × 0.25 = 10
        XCTAssertEqual(savings.weekly, 10)
        XCTAssertEqual(savings.yearly, 520)
        let floor = BudgetMath.estimatedSavings(budget: 500, portions: 1, days: 1, region: .US)
        XCTAssertEqual(floor.weekly, 1.5, "max(5, negative gap) × 0.25 = 1.25, rounded to the nearest 0.5")
        let capped = BudgetMath.estimatedSavings(budget: 0, portions: 10, days: 7, region: .US)
        XCTAssertEqual(capped.weekly, 40)
    }

    func testWeekMath() {
        XCTAssertEqual(WeekMath.isoWeekday(TestSupport.monday), 1)
        let slots = WeekMath.slots(from: TestSupport.monday, cookingDays: [1, 3, 5])
        XCTAssertEqual(slots.map { $0.weekday }, [1, 3, 5])
        XCTAssertEqual(slots.map { $0.index }, [0, 1, 2])
        // Starting on a Wednesday, the window wraps to next Monday.
        let wednesday = WeekMath.gregorian.date(byAdding: .day, value: 2, to: TestSupport.monday)!
        let wrapped = WeekMath.slots(from: wednesday, cookingDays: [1, 3])
        XCTAssertEqual(wrapped.map { $0.weekday }, [3, 1])
    }

    func testTimerDetection() {
        let timers = TimerDetector.timers(in: "Simmer for 20 minutes, then rest for 30 seconds.")
        XCTAssertEqual(timers.map { $0.seconds }, [1200, 30])
        XCTAssertEqual(timers.map { $0.usesUpperBound }, [false, false])
        XCTAssertEqual(TimerDetector.timers(in: "Cook for 10–12 min").first?.usesUpperBound, true)
        XCTAssertTrue(TimerDetector.timers(in: "Cook for 9999999999999999999999999 hours").isEmpty)
        XCTAssertEqual(TimerDetector.timers(in: "Cook for 6 to 8 minutes").first?.seconds, 480)
        XCTAssertEqual(TimerDetector.timers(in: "Cook on low for 4 hours").first?.seconds, 14400)
        XCTAssertEqual(TimerDetector.timers(in: "Bake 12-15 mins").first?.seconds, 900)
        XCTAssertTrue(TimerDetector.timers(in: "Heat the oven to 200°C (400°F).").isEmpty)
        XCTAssertEqual(TimerDetector.clock(125), "2:05")
        XCTAssertEqual(TimerDetector.clock(3725), "1:02:05")
    }

    func testStepIngredientMatching() {
        let recipe = catalog.recipe(id: "chickpea-spinach-curry")!
        let found = StepIngredientMatcher.ingredients(in: "Stir through the spinach a handful at a time until wilted. Season with the salt.", recipe: recipe, catalog: catalog)
        XCTAssertEqual(Set(found.compactMap { $0.ingredientId }), ["spinach", "salt"])
        let curry = StepIngredientMatcher.ingredients(in: "Stir in the garlic, ginger and curry powder", recipe: recipe, catalog: catalog)
        XCTAssertEqual(Set(curry.compactMap { $0.ingredientId }), ["garlic", "ginger", "curry-powder"])
    }

    func testIngredientMatcher() {
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "2 cloves of garlic, minced", in: catalog)?.id, "garlic")
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "extra virgin olive oil", in: catalog)?.id, "olive-oil")
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "courgette", in: catalog)?.id, "zucchini")
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "boneless skinless chicken thighs", in: catalog)?.id, "chicken-thighs")
        XCTAssertNil(IngredientMatcher.bestMatch(for: "unicorn tears", in: catalog))
        XCTAssertEqual(IngredientMatcher.suggestions(for: "chick", in: catalog).first?.id.hasPrefix("chick"), true)
    }

    func testIngredientAliasesPreserveCanonicalForms() {
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "scallions", in: catalog)?.id, "spring-onion")
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "garbanzo beans", in: catalog)?.id, "chickpeas")
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "fresh coriander", in: catalog)?.id, "cilantro")
        XCTAssertEqual(IngredientMatcher.bestMatch(for: "ground coriander", in: catalog)?.id, "ground-coriander")
        XCTAssertEqual(IngredientMatcher.suggestions(for: "scalli", in: catalog).first?.id, "spring-onion")
    }

    func testWidgetSnapshotRoundTrip() throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let snapshot = WidgetSnapshot(generatedAt: Date(timeIntervalSince1970: 1_000), days: [
            WidgetSnapshot.Day(date: TestSupport.monday, recipeId: "shakshuka", title: "Shakshuka", emoji: "🍳", colorHex: "#E35E48", minutes: 25, servings: 2, macrosLine: "500 kcal")
        ])
        try snapshot.write(to: dir)
        let loaded = WidgetSnapshot.load(from: dir)
        XCTAssertEqual(loaded?.days.first?.recipeId, "shakshuka")
        XCTAssertNotNil(loaded?.day(for: TestSupport.monday))
    }
}
