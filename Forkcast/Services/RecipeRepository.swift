import Foundation
import SwiftData
import Observation
import ForkcastCore

/// Merges bundled recipes and the user's own recipes behind one `Recipe` type,
/// and caches derived data (macros, allergens, cost).
@MainActor
@Observable
final class RecipeRepository {
    let catalog: FoodCatalog
    let context: ModelContext
    private(set) var userRecipes: [Recipe] = []
    private(set) var userRecipeModels: [UserRecipe] = []

    @ObservationIgnored private var nutritionCache: [String: NutritionResult] = [:]
    @ObservationIgnored private var profileCache: [String: RecipeProfile] = [:]

    init(catalog: FoodCatalog, context: ModelContext) {
        self.catalog = catalog
        self.context = context
        refresh()
    }

    func refresh() {
        let descriptor = FetchDescriptor<UserRecipe>(sortBy: [SortDescriptor(\UserRecipe.createdAt, order: .reverse)])
        userRecipeModels = (try? context.fetch(descriptor)) ?? []
        userRecipes = userRecipeModels.map { $0.asRecipe() }
        // User recipes can change, so drop their cached values.
        nutritionCache = nutritionCache.filter { !$0.key.hasPrefix(Recipe.userIdPrefix) }
        profileCache = profileCache.filter { !$0.key.hasPrefix(Recipe.userIdPrefix) }
    }

    var bundledRecipes: [Recipe] { catalog.recipes }

    var allRecipes: [Recipe] { catalog.recipes + userRecipes }

    func recipe(id: String) -> Recipe? {
        if id.hasPrefix(Recipe.userIdPrefix) {
            return userRecipes.first { $0.id == id }
        }
        return catalog.recipe(id: id)
    }

    func userRecipeModel(id: String) -> UserRecipe? {
        userRecipeModels.first { $0.recipeId == id }
    }

    func nutrition(for recipe: Recipe) -> NutritionResult {
        if let cached = nutritionCache[recipe.id] { return cached }
        let result: NutritionResult = NutritionCalculator.perServing(recipe, catalog: catalog)
        nutritionCache[recipe.id] = result
        return result
    }

    func profile(for recipe: Recipe) -> RecipeProfile {
        if let cached = profileCache[recipe.id] { return cached }
        let result: RecipeProfile = RecipeClassifier.profile(for: recipe, catalog: catalog)
        profileCache[recipe.id] = result
        return result
    }

    /// Hard filters used for browsing: allergens, diet, dislikes, appliances
    /// and "not for me". (Time only affects auto-plans.)
    func passesHardFilters(_ recipe: Recipe, rules: PlannerProfile, notForMe: Set<String>) -> Bool {
        let planner = MealPlanner(catalog: catalog)
        return planner.passesHardFilters(recipe, profile: rules, notForMe: notForMe, ignoreTime: true)
    }

    func browsable(rules: PlannerProfile, notForMe: Set<String>, includeUser: Bool = true) -> [Recipe] {
        let pool: [Recipe] = includeUser ? allRecipes : bundledRecipes
        return pool.filter { passesHardFilters($0, rules: rules, notForMe: notForMe) }
    }

    /// Approximate cost per serving if this recipe were bought on its own.
    func costPerServing(_ recipe: Recipe, pricing: PriceContext, unitSystem: UnitSystem) -> Double {
        let portion = MealPortion(recipe: recipe, servings: Double(recipe.baseServings), weekday: 1)
        let list: GroceryList = GroceryAggregator.aggregate(meals: [portion], catalog: catalog, pricing: pricing, unitSystem: unitSystem)
        // Use the proportional cost (what the ingredients actually used are worth),
        // not whole packs, so the number is comparable between recipes.
        var used: Double = 0
        for item in recipe.ingredients {
            guard let id = item.ingredientId, let ingredient = catalog.ingredient(id: id),
                  let price = catalog.packPrice(ingredientId: id, context: pricing),
                  let base = UnitConverter.baseAmount(amount: item.amount, unit: item.unit, ingredient: ingredient) else { continue }
            if ingredient.isPantryStaple {
                used += GroceryAggregator.pantryCost(packPrice: price) / 3
            } else {
                used += price * base / max(ingredient.pack.amount, 0.0001)
            }
        }
        if used == 0 { used = list.total }
        return used / Double(max(1, recipe.baseServings))
    }

    // MARK: User recipes

    func delete(userRecipeId: String) {
        guard let model = userRecipeModel(id: userRecipeId) else { return }
        context.delete(model)
        try? context.save()
        refresh()
    }
}
