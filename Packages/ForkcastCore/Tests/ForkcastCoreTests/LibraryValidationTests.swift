import XCTest
@testable import ForkcastCore

final class LibraryValidationTests: XCTestCase {
    let catalog = TestSupport.catalog

    func testCatalogLoads() throws {
        let loaded = try FoodCatalog.loadBundled()
        XCTAssertEqual(loaded.recipes.count, 40)
        XCTAssertGreaterThanOrEqual(loaded.ingredients.count, 140)
        XCTAssertEqual(loaded.countries.first?.id, "us", "United States must be first in every list")
        XCTAssertEqual(loaded.countries[1].id, "gb", "then the United Kingdom")
    }

    func testIdsAreUnique() {
        XCTAssertEqual(Set(catalog.recipes.map { $0.id }).count, catalog.recipes.count)
        XCTAssertEqual(Set(catalog.ingredients.map { $0.id }).count, catalog.ingredients.count)
        XCTAssertEqual(Set(catalog.stores.map { $0.id }).count, catalog.stores.count)
    }

    func testEveryRecipeIngredientExistsAndConverts() {
        for recipe in catalog.recipes {
            for item in recipe.ingredients {
                guard let id = item.ingredientId else {
                    XCTFail("\(recipe.id): bundled ingredient without id")
                    continue
                }
                guard let ingredient = catalog.ingredient(id: id) else {
                    XCTFail("\(recipe.id): unknown ingredient \(id)")
                    continue
                }
                XCTAssertNotNil(UnitConverter.grams(amount: item.amount, unit: item.unit, ingredient: ingredient), "\(recipe.id): can't convert \(item.amount) \(item.unit.rawValue) of \(id) to grams")
                XCTAssertNotNil(UnitConverter.baseAmount(amount: item.amount, unit: item.unit, ingredient: ingredient), "\(recipe.id): can't convert \(id) to base unit")
            }
        }
    }

    func testRecipesHaveStepsAndSensibleMacros() {
        for recipe in catalog.recipes {
            XCTAssertTrue((6...10).contains(recipe.steps.count), "\(recipe.id) has \(recipe.steps.count) steps")
            XCTAssertTrue([2, 4].contains(recipe.baseServings), "\(recipe.id) baseServings")
            XCTAssertFalse(recipe.appliances.isEmpty, "\(recipe.id) needs appliances")
            let nutrition = NutritionCalculator.perServing(recipe, catalog: catalog)
            XCTAssertFalse(nutrition.hasIncompleteData, recipe.id)
            XCTAssertTrue((250...950).contains(nutrition.macros.kcal), "\(recipe.id): \(Int(nutrition.macros.kcal)) kcal per serving")
        }
    }

    func testOvenAndAirFryerStepsGiveBothTemperatures() {
        for recipe in catalog.recipes {
            for step in recipe.steps where step.contains("°C") {
                XCTAssertTrue(step.contains("°F"), "\(recipe.id): \(step)")
            }
        }
    }

    func testCoverageRequirements() {
        let profiles = catalog.recipes.map { ($0, RecipeClassifier.profile(for: $0, catalog: catalog)) }
        let vegetarian = profiles.filter { $0.1.diet >= .vegetarian }.count
        let vegan = profiles.filter { $0.1.diet == .vegan }.count
        let pescatarian = profiles.filter { $0.1.diet == .pescatarian }.count
        let glutenFree = profiles.filter { $0.1.isGlutenFree }.count
        let dairyFree = profiles.filter { $0.1.isDairyFree }.count
        let quick = catalog.recipes.filter { $0.totalMinutes <= 25 }.count
        let airFryer = catalog.recipes.filter { $0.appliances.contains(.airFryer) }.count
        let slowCooker = catalog.recipes.filter { $0.appliances.contains(.slowCooker) }.count
        let microwaveOnly = catalog.recipes.filter { $0.appliances == [.microwave] }.count
        let onePan = catalog.recipes.filter { $0.vibes.contains(.onePan) }.count
        let meatProteins = Set(profiles.map { $0.1.mainProtein })

        XCTAssertGreaterThanOrEqual(vegetarian, 14)
        XCTAssertGreaterThanOrEqual(vegan, 7)
        XCTAssertGreaterThanOrEqual(pescatarian, 4)
        XCTAssertGreaterThanOrEqual(glutenFree, 12)
        XCTAssertGreaterThanOrEqual(dairyFree, 12)
        XCTAssertGreaterThanOrEqual(quick, 12)
        XCTAssertGreaterThanOrEqual(airFryer, 5)
        XCTAssertGreaterThanOrEqual(slowCooker, 3)
        XCTAssertGreaterThanOrEqual(microwaveOnly, 2)
        XCTAssertGreaterThanOrEqual(onePan, 6)
        for protein in [ProteinGroup.chicken, .beef, .pork, .turkey] {
            XCTAssertTrue(meatProteins.contains(protein), "missing \(protein)")
        }
    }

    func testEveryIngredientHasAPriceInEveryRegion() {
        for ingredient in catalog.ingredients {
            for region in RegionPriceKey.allCases {
                let price = catalog.prices.standardPackPrice(ingredientId: ingredient.id, region: region)
                XCTAssertNotNil(price, "\(ingredient.id) has no \(region.rawValue) price")
                XCTAssertGreaterThan(price ?? 0, 0)
            }
            XCTAssertGreaterThan(ingredient.pack.amount, 0, ingredient.id)
        }
    }

    func testEveryCountryHasStoresWithLocalLast() {
        for country in catalog.countries {
            let stores = catalog.stores(forCountry: country.id)
            XCTAssertGreaterThanOrEqual(stores.count, 2, country.id)
            XCTAssertEqual(stores.last?.id, Store.localStoreId, country.id)
        }
        XCTAssertEqual(catalog.stores(forCountry: "us").first?.name, "Walmart")
    }

    func testHiddenAllergenSourcesAreFlagged() {
        func allergens(_ id: String) -> Set<Allergen> {
            Set(catalog.ingredient(id: id)?.allergens ?? [])
        }
        XCTAssertTrue(allergens("soy-sauce").contains(.gluten), "soy sauce contains wheat")
        XCTAssertTrue(allergens("pesto").contains(.treeNut))
        XCTAssertTrue(allergens("worcestershire").contains(.fish))
        XCTAssertTrue(allergens("sausages").contains(.gluten))
        XCTAssertTrue(allergens("thai-curry-paste").contains(.shellfish))
        XCTAssertTrue(catalog.ingredient(id: "honey")?.dietFlags.isAnimalProduct ?? false, "honey isn't vegan")
    }

    func testDishPaletteIsStable() {
        XCTAssertEqual(DishPalette.index(for: "shakshuka"), DishPalette.index(for: "shakshuka"))
        XCTAssertEqual(StableHash.fnv1a("a"), 0xaf63dc4c8601ec8c)
        let used = Set(catalog.recipes.map { DishPalette.index(for: $0.id) })
        XCTAssertGreaterThanOrEqual(used.count, 6, "tile colours should be well spread")
    }
}
