import XCTest
import Foundation
import ForkcastCore // deliberately NOT @testable: proves the app can see everything it uses.

final class PublicAPITests: XCTestCase {
    func testAppFacingAPIIsPublic() throws {
        let catalog: FoodCatalog = FoodCatalog.bundled
        let country: Country = catalog.defaultCountry
        let store: Store? = catalog.stores(forCountry: country.id).first
        XCTAssertNotNil(catalog.store(id: Store.localStoreId))
        _ = store?.monogram
        _ = store?.isLocalStore
        _ = country.priceNote
        _ = country.priceMultiplier
        let pricing = PriceContext(country: country, store: store)
        let recipe: Recipe = try XCTUnwrap(catalog.recipe(id: "shakshuka"))
        _ = recipe.totalMinutes
        _ = recipe.isUserRecipe
        _ = Recipe.userIdPrefix

        // Nutrition / classification
        let nutrition: NutritionResult = NutritionCalculator.perServing(recipe, catalog: catalog)
        _ = (nutrition.macros.kcal, nutrition.hasIncompleteData, nutrition.isManualOverride)
        let profile: RecipeProfile = RecipeClassifier.profile(for: recipe, catalog: catalog)
        _ = (profile.diet.displayName, profile.isGlutenFree, profile.isDairyFree, profile.allergens, profile.mainProtein)

        // Units and text
        _ = QuantityFormatter.string(amount: 1.5, unit: .cup, system: .imperial, ingredient: nil)
        _ = FractionFormatter.string(1.5, maxFractionValue: 1000)
        _ = FractionFormatter.parse("1/2")
        _ = MeasureUnit.parse("tbsp")
        _ = MeasureUnit.tbsp.label(for: 2)
        _ = "olive oil".capitalizedFirst
        _ = TimerDetector.timers(in: "for 20 minutes").first?.id
        _ = TimerDetector.clock(90)
        _ = StepTextFormatter.string("Heat the oven to 200°C (400°F).", system: .imperial)
        _ = StepIngredientMatcher.ingredients(in: recipe.steps[0], recipe: recipe, catalog: catalog)
        _ = IngredientMatcher.suggestions(for: "oni", in: catalog, limit: 4)
        _ = IngredientMatcher.bestMatch(for: "onion", in: catalog)

        // Dislikes / vibes / enums used in UI
        for option in DislikeCatalog.commonPicks { _ = (option.id, option.label, option.emoji) }
        _ = DislikeCatalog.label(for: "mushrooms", catalog: catalog, system: .metric)
        _ = (Vibe.quickEasy.displayName, Vibe.quickEasy.systemImage, Vibe.quickEasy.tintHex)
        _ = (Appliance.oven.displayName, Appliance.oven.systemImage, Allergen.egg.emoji, Aisle.produce.emoji, Cuisine.thai.emoji)
        _ = Diet.vegan.displayName

        // Budget maths
        _ = BudgetMath.portions(adults: 2, kids: 1)
        _ = BudgetMath.range(region: .US, portions: 2, days: 5, multiplier: 1)
        _ = BudgetMath.defaultBudget(region: .US, portions: 2, days: 5, multiplier: 1)
        _ = BudgetMath.verdict(budget: 50, portions: 2, days: 5, region: .US, multiplier: 1).title
        _ = BudgetMath.costPerServing(budget: 50, portions: 2, days: 5)
        _ = BudgetMath.estimatedSavings(budget: 50, portions: 2, days: 5, region: .US, multiplier: 1)
        _ = BudgetMath.step(region: .US)

        // Planner + groceries
        let slots: [PlanSlot] = WeekMath.slots(from: Date(), cookingDays: [1, 2, 3])
        _ = WeekMath.days(from: Date())
        _ = WeekMath.isoWeekday(Date())
        _ = WeekMath.weeksBetween(Date(), Date())
        _ = WeekMath.englishInitials
        let request = PlannerRequest(profile: PlannerProfile(), recipes: catalog.recipes, feedback: FeedbackSummary(), history: [:], slots: slots, servings: 2, budget: 60, pricing: pricing, unitSystem: .imperial, seed: SeededRandom.seed(weekStart: Date(), regeneration: 0), locked: [:])
        let planner = MealPlanner(catalog: catalog)
        var tailored = request
        tailored.profile.goals = [.saveTime]
        tailored.profile.obstacles = [.tooTired]
        tailored.profile.children = 2
        tailored.tasteAsOf = Date()
        tailored.tasteRecipes = [recipe]
        tailored.savedRecipeIds = [recipe.id]
        tailored.tasteEvents = [TasteEvent(recipeId: recipe.id, kind: .saved, date: Date())]
        let traits: RecipeTraits = planner.traits(for: recipe, pricing: pricing)
        let taste = TasteProfile(events: tailored.tasteEvents, recipes: [recipe], planner: planner, pricing: pricing, asOf: Date())
        _ = taste.score(recipe: recipe, profile: profile, traits: traits)
        _ = TailoringWeights(profile: tailored.profile).pairsLeftovers
        let result: PlanResult = planner.plan(tailored)
        _ = (result.estimatedTotal, result.overBudgetBy, result.relaxedTimeLimit)
        for draft in result.meals { _ = (draft.slotIndex, draft.date, draft.recipeId, draft.servings, draft.allocatedCost, draft.reason, draft.leftoversFromSlotIndex) }
        var current: [Int: LockedMeal] = [:]
        for draft in result.meals { current[draft.slotIndex] = LockedMeal(recipeId: draft.recipeId, servings: draft.servings, leftoversFromSlotIndex: draft.leftoversFromSlotIndex) }
        for alt in planner.alternatives(for: 0, current: current, request: request) { _ = (alt.recipeId, alt.costDelta) }
        _ = planner.passesHardFilters(recipe, profile: PlannerProfile(), notForMe: [], ignoreTime: true)
        let list: GroceryList = GroceryAggregator.aggregate(meals: [MealPortion(recipe: recipe, servings: 2, weekday: 1)], catalog: catalog, pricing: pricing, unitSystem: .metric)
        _ = (list.itemCount, list.allItems, list.pantryStaples, list.total, list.standaloneTotal, list.savingsFromSharing, list.mealCosts)
        for section in list.sections { _ = (section.id, section.aisle.displayName) }
        for item in list.allItems { _ = (item.id, item.key, item.name, item.emoji, item.displayQuantity, item.neededText, item.usedOnWeekdays, item.cost, item.hasPrice, item.isPantryStaple) }
        _ = GroceryAggregator.usedOnText([1, 4], shortNames: WeekMath.englishShortWeekdays)
        _ = GroceryAggregator.pantryCost(packPrice: 2)
        _ = GroceryTextExporter.plainText(list: list, title: "t", checkedKeys: [], extras: [], formatMoney: { "\($0)" })
        _ = catalog.packPrice(ingredientId: "onion", context: pricing)
        _ = catalog.ingredient(id: "onion")?.displayName(for: .metric, plural: true)

        // Shared
        _ = DishPalette.hex(for: "x")
        _ = (SharedConstants.urlScheme, SharedConstants.widgetKind, SharedConstants.appGroupId)
        let day = WidgetSnapshot.Day(date: Date(), recipeId: nil, title: nil, emoji: nil, colorHex: nil, minutes: nil, servings: nil, macrosLine: nil)
        _ = WidgetSnapshot(generatedAt: Date(), days: [day]).day(for: Date())
        _ = WidgetSnapshot.empty
        _ = Macros.zero
    }
}
