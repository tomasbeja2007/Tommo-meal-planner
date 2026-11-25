import Foundation

/// Everything derived from a recipe's ingredients: allergens, diet, main protein.
public struct RecipeProfile: Hashable, Sendable {
    public let allergens: Set<Allergen>
    public let diet: RecipeDiet
    public let mainProtein: ProteinGroup
    public let proteinGroups: Set<ProteinGroup>
    /// Linked (or matched) ingredient ids.
    public let ingredientIds: Set<String>
    /// Non-staple ingredient ids (used for overlap scoring).
    public let keyIngredientIds: Set<String>
    public let ingredientTags: Set<String>

    public var isGlutenFree: Bool { !allergens.contains(.gluten) }
    public var isDairyFree: Bool { !allergens.contains(.dairy) }
    public var isSpicy: Bool { ingredientTags.contains("spicy") }
}

public enum RecipeClassifier {
    public static func profile(for recipe: Recipe, catalog: FoodCatalog) -> RecipeProfile {
        var allergens: Set<Allergen> = []
        var ids: Set<String> = []
        var keyIds: Set<String> = []
        var tags: Set<String> = []
        var groups: Set<ProteinGroup> = []
        var hasMeat: Bool = false
        var hasFish: Bool = false
        var hasAnimal: Bool = false
        var proteinGrams: [ProteinGroup: Double] = [:]

        for item in recipe.ingredients {
            var resolved: Ingredient? = nil
            if let id = item.ingredientId {
                resolved = catalog.ingredient(id: id)
            } else if let name = item.name {
                // Best effort for unlinked user ingredients, so hard filters stay safe.
                resolved = IngredientMatcher.bestMatch(for: name, in: catalog)
            }
            guard let ingredient = resolved else { continue }
            ids.insert(ingredient.id)
            if !ingredient.isPantryStaple { keyIds.insert(ingredient.id) }
            allergens.formUnion(ingredient.allergens)
            tags.formUnion(ingredient.tags)
            if ingredient.dietFlags.isMeat { hasMeat = true }
            if ingredient.dietFlags.isFish { hasFish = true }
            if ingredient.dietFlags.isAnimalProduct { hasAnimal = true }
            if let group = ingredient.proteinGroup {
                groups.insert(group)
                let grams: Double = UnitConverter.grams(amount: item.amount, unit: item.unit, ingredient: ingredient) ?? 0
                proteinGrams[group, default: 0] += grams * max(ingredient.per100g.protein, 1)
            }
        }

        let diet: RecipeDiet
        if hasMeat {
            diet = .omnivore
        } else if hasFish {
            diet = .pescatarian
        } else if hasAnimal {
            diet = .vegetarian
        } else {
            diet = .vegan
        }

        // Meat and fish beat cheese/egg/legume as the "main" protein.
        let priority: [ProteinGroup] = [.chicken, .beef, .pork, .turkey, .lamb, .fish, .shellfish]
        var main: ProteinGroup = .veg
        let animal = proteinGrams.filter { priority.contains($0.key) }
        let byProteinAmount: ((key: ProteinGroup, value: Double), (key: ProteinGroup, value: Double)) -> Bool = { lhs, rhs in
            lhs.value == rhs.value ? lhs.key.rawValue > rhs.key.rawValue : lhs.value < rhs.value
        }
        if let best = animal.max(by: byProteinAmount) {
            main = best.key
        } else if let best = proteinGrams.max(by: byProteinAmount) {
            main = best.key
        }

        return RecipeProfile(
            allergens: allergens,
            diet: diet,
            mainProtein: main,
            proteinGroups: groups,
            ingredientIds: ids,
            keyIngredientIds: keyIds,
            ingredientTags: tags
        )
    }
}
