import Foundation

public struct NutritionResult: Hashable, Sendable {
    /// Per serving.
    public let macros: Macros
    /// True when some ingredients couldn't be counted (unlinked or unconvertible).
    public let hasIncompleteData: Bool
    /// True when the user typed the macros by hand.
    public let isManualOverride: Bool

    public init(macros: Macros, hasIncompleteData: Bool, isManualOverride: Bool = false) {
        self.macros = macros
        self.hasIncompleteData = hasIncompleteData
        self.isManualOverride = isManualOverride
    }
}

/// Computes macros from ingredients. Macros are never typed into the recipe data.
public enum NutritionCalculator {
    public static func totalMacros(for ingredients: [RecipeIngredient], catalog: FoodCatalog) -> (macros: Macros, incomplete: Bool) {
        var total: Macros = .zero
        var incomplete: Bool = false
        for item in ingredients {
            guard let id = item.ingredientId, let ingredient = catalog.ingredient(id: id) else {
                incomplete = true
                continue
            }
            guard let grams = UnitConverter.grams(amount: item.amount, unit: item.unit, ingredient: ingredient) else {
                incomplete = true
                continue
            }
            total += ingredient.per100g.scaled(by: grams / 100.0)
        }
        return (total, incomplete)
    }

    public static func perServing(_ recipe: Recipe, catalog: FoodCatalog) -> NutritionResult {
        if let override = recipe.macroOverride {
            return NutritionResult(macros: override, hasIncompleteData: false, isManualOverride: true)
        }
        let result = totalMacros(for: recipe.ingredients, catalog: catalog)
        let servings: Double = Double(max(1, recipe.baseServings))
        return NutritionResult(macros: result.macros.scaled(by: 1.0 / servings), hasIncompleteData: result.incomplete)
    }
}
