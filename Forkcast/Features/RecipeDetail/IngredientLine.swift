import Foundation
import ForkcastCore

/// Display-ready ingredient row for a recipe scaled to `servings`.
struct IngredientLine: Identifiable, Hashable {
    let id: Int
    let ingredientID: String?
    let name: String
    let amountText: String
    let note: String?
    let isPantryStaple: Bool
    let isLinked: Bool

    static func lines(for recipe: Recipe, servings: Double, catalog: FoodCatalog, system: UnitSystem) -> [IngredientLine] {
        let scale: Double = servings / Double(max(1, recipe.baseServings))
        return recipe.ingredients.enumerated().map { index, item in
            let ingredient: Ingredient? = item.ingredientId.flatMap { catalog.ingredient(id: $0) }
            let amount: Double = item.amount * scale
            let amountText: String = QuantityFormatter.string(amount: amount, unit: item.unit, system: system, ingredient: ingredient)
            let plural: Bool = item.unit == .piece && amount > 1.0001
            let name: String
            if let ingredient {
                name = ingredient.displayName(for: system, plural: plural)
            } else {
                name = item.name ?? String(localized: "ingredient")
            }
            return IngredientLine(
                id: index,
                ingredientID: ingredient?.id,
                name: name,
                amountText: amountText,
                note: item.note,
                isPantryStaple: ingredient?.isPantryStaple ?? false,
                isLinked: ingredient != nil
            )
        }
    }
}

enum RecipeShareText {
    static func make(recipe: Recipe, servings: Double, catalog: FoodCatalog, system: UnitSystem) -> String {
        var lines: [String] = ["\(recipe.emoji) \(recipe.title)", "Serves \(FractionFormatter.string(servings)) · \(recipe.totalMinutes) min", "", "Ingredients"]
        for line in IngredientLine.lines(for: recipe, servings: servings, catalog: catalog, system: system) {
            let note: String = line.note.map { ", \($0)" } ?? ""
            lines.append("• \(line.amountText) \(line.name)\(note)".replacingOccurrences(of: "  ", with: " "))
        }
        lines.append("")
        lines.append("Method")
        for (index, step) in recipe.steps.enumerated() {
            lines.append("\(index + 1). \(step)")
        }
        lines.append("")
        lines.append("Planned with Tommo")
        return lines.joined(separator: "\n")
    }
}
