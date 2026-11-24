import XCTest
@testable import ForkcastCore

final class GroceryTests: XCTestCase {
    let catalog = TestSupport.catalog

    func recipe(_ id: String) -> Recipe { catalog.recipe(id: id)! }

    func testSharedIngredientIsOneLineWithBothDays() {
        // Both use onion.
        let meals = [
            MealPortion(recipe: recipe("chickpea-spinach-curry"), servings: 4, weekday: 1),
            MealPortion(recipe: recipe("weeknight-spaghetti-bolognese"), servings: 4, weekday: 4)
        ]
        let list = GroceryAggregator.aggregate(meals: meals, catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .imperial)
        let onions = list.allItems.filter { $0.ingredientId == "onion" }
        XCTAssertEqual(onions.count, 1)
        XCTAssertEqual(onions.first?.usedOnWeekdays, [1, 4])
        XCTAssertEqual(GroceryAggregator.usedOnText(onions.first?.usedOnWeekdays ?? []), "used Mon & Thu")
        XCTAssertEqual(onions.first?.neededBase ?? 0, 300, accuracy: 0.01)
        XCTAssertEqual(onions.first?.packCount, 1)
        XCTAssertEqual(onions.first?.neededText, "you need 2 onions")
    }

    func testPacksRoundUpAndScaleWithServings() {
        // Curry uses 480 g chickpeas = 2 tins at 4 servings, 4 tins at 8 servings.
        let four = GroceryAggregator.aggregate(meals: [MealPortion(recipe: recipe("chickpea-spinach-curry"), servings: 4, weekday: 1)], catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .metric)
        let eight = GroceryAggregator.aggregate(meals: [MealPortion(recipe: recipe("chickpea-spinach-curry"), servings: 8, weekday: 1)], catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .metric)
        XCTAssertEqual(four.allItems.first { $0.ingredientId == "chickpeas" }?.packCount, 2)
        XCTAssertEqual(eight.allItems.first { $0.ingredientId == "chickpeas" }?.packCount, 4)
        XCTAssertEqual(four.allItems.first { $0.ingredientId == "chickpeas" }?.displayQuantity, "2 × 400 g tin (240 g drained)")
        // 3 servings: 360 g -> 1.5 tins -> 2 tins
        let three = GroceryAggregator.aggregate(meals: [MealPortion(recipe: recipe("chickpea-spinach-curry"), servings: 3, weekday: 1)], catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .metric)
        let chickpeas = three.allItems.first { $0.ingredientId == "chickpeas" }
        XCTAssertEqual(chickpeas?.packCount, 2)
        XCTAssertEqual(chickpeas?.neededText, "you need 360 g (1½ tins)")
    }

    func testPantryStaplesAreSeparateAndCheap() {
        let list = GroceryAggregator.aggregate(meals: [MealPortion(recipe: recipe("lemon-cod-traybake"), servings: 2, weekday: 2)], catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .imperial)
        XCTAssertTrue(list.pantryStaples.contains { $0.ingredientId == "olive-oil" })
        XCTAssertTrue(list.pantryStaples.contains { $0.ingredientId == "salt" })
        XCTAssertFalse(list.allItems.contains { $0.isPantryStaple })
        for staple in list.pantryStaples {
            XCTAssertLessThanOrEqual(staple.cost, 0.6)
        }
    }

    func testSectionsFollowWalkingOrder() {
        let meals = catalog.recipes.prefix(8).enumerated().map { MealPortion(recipe: $0.element, servings: 2, weekday: ($0.offset % 7) + 1) }
        let list = GroceryAggregator.aggregate(meals: Array(meals), catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .imperial)
        let order = list.sections.map { $0.aisle.walkingOrder }
        XCTAssertEqual(order, order.sorted())
        XCTAssertEqual(list.sections.first?.aisle, .produce)
    }

    func testCostsAddUpAndSharingIsCheaper() {
        let meals = [
            MealPortion(recipe: recipe("chickpea-spinach-curry"), servings: 2, weekday: 1),
            MealPortion(recipe: recipe("sweet-potato-peanut-curry"), servings: 2, weekday: 3),
            MealPortion(recipe: recipe("slow-cooker-red-lentil-dahl"), servings: 2, weekday: 5)
        ]
        let list = GroceryAggregator.aggregate(meals: meals, catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .imperial)
        XCTAssertEqual(list.mealCosts.reduce(0, +), list.total, accuracy: 0.01)
        XCTAssertGreaterThan(list.standaloneTotal, list.total, "shared packs make the list cheaper than the meals added up")
        XCTAssertGreaterThan(list.savingsFromSharing, 0)
    }

    func testTierAndCountryMultipliers() {
        let meals = [MealPortion(recipe: recipe("shakshuka"), servings: 2, weekday: 1)]
        func packCost(_ context: PriceContext) -> Double {
            GroceryAggregator.aggregate(meals: meals, catalog: catalog, pricing: context, unitSystem: .imperial).allItems.reduce(0) { $0 + $1.cost }
        }
        let standard = packCost(PriceContext(region: .US, tier: .standard))
        XCTAssertEqual(packCost(PriceContext(region: .US, tier: .budget)), standard * 0.85, accuracy: 0.01)
        XCTAssertEqual(packCost(PriceContext(region: .US, tier: .premium)), standard * 1.25, accuracy: 0.01)
        XCTAssertEqual(packCost(PriceContext(region: .US, tier: .standard, countryMultiplier: 1.37)), standard * 1.37, accuracy: 0.01)
    }

    func testPlainTextExport() {
        let list = GroceryAggregator.aggregate(meals: [MealPortion(recipe: recipe("black-bean-tacos"), servings: 4, weekday: 2)], catalog: catalog, pricing: TestSupport.usPricing, unitSystem: .imperial)
        let text = GroceryTextExporter.plainText(list: list, title: "Grocery list", checkedKeys: ["black-beans"], extras: [(name: "Coffee", quantity: "1 bag", checked: false)]) { String(format: "$%.2f", $0) }
        XCTAssertTrue(text.contains("Produce"))
        XCTAssertTrue(text.contains("☑ black beans"))
        XCTAssertTrue(text.contains("☐ Coffee (1 bag)"))
        XCTAssertTrue(text.contains("You probably have these"))
    }

    func testUsedOnText() {
        XCTAssertEqual(GroceryAggregator.usedOnText([2]), "used Tue")
        XCTAssertEqual(GroceryAggregator.usedOnText([1, 3, 5]), "used Mon, Wed & Fri")
        XCTAssertEqual(GroceryAggregator.usedOnText([]), "")
    }
}
