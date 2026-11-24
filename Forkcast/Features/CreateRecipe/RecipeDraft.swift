import Foundation
import SwiftData
import ForkcastCore

/// Editable form state for Create / Edit recipe (and pre-filled imports).
struct RecipeDraft: Identifiable, Hashable {
    struct DraftIngredient: Identifiable, Hashable {
        let id: UUID
        var amountText: String
        var unit: MeasureUnit
        var name: String
        var ingredientId: String?

        init(id: UUID = UUID(), amountText: String = "", unit: MeasureUnit = .piece, name: String = "", ingredientId: String? = nil) {
            self.id = id
            self.amountText = amountText
            self.unit = unit
            self.name = name
            self.ingredientId = ingredientId
        }

        var amount: Double { FractionFormatter.parse(amountText) ?? (unit == .toTaste ? 0 : 1) }
        var isEmpty: Bool { name.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    struct DraftStep: Identifiable, Hashable {
        let id: UUID
        var text: String

        init(id: UUID = UUID(), text: String = "") {
            self.id = id
            self.text = text
        }
    }

    let id: UUID = UUID()
    var title: String = ""
    var emoji: String = "🍲"
    var servings: Int = 2
    var totalMinutes: Int = 30
    var tags: Set<String> = []
    var ingredients: [DraftIngredient] = [DraftIngredient()]
    var steps: [DraftStep] = [DraftStep()]
    var useManualMacros: Bool = false
    var kcalText: String = ""
    var proteinText: String = ""
    var carbsText: String = ""
    var fatText: String = ""
    var notes: String = ""
    var sourceURL: String = ""
    var sourceKind: RecipeSourceKind = .manual
    /// Shown above the form after an import ("this one's recipe is probably spoken in the video").
    var importNote: String? = nil
    /// The model being edited, if any.
    var editingRecipeId: String? = nil

    static func == (lhs: RecipeDraft, rhs: RecipeDraft) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    /// Tag choices: vibes + diet-ish labels.
    static let extraTags: [String] = ["vegetarian", "vegan", "gluten-free", "dairy-free"]

    static func tagTitle(_ tag: String) -> String {
        if let vibe = Vibe(rawValue: tag) { return vibe.displayName }
        switch tag {
        case "vegetarian": return String(localized: "Vegetarian")
        case "vegan": return String(localized: "Vegan")
        case "gluten-free": return String(localized: "Gluten-free")
        case "dairy-free": return String(localized: "Dairy-free")
        default: return tag
        }
    }

    // MARK: Building

    init() {}

    init(model: UserRecipe) {
        title = model.title
        emoji = model.emoji
        servings = model.servings
        totalMinutes = model.totalMinutes
        tags = Set(model.tags)
        ingredients = model.sortedIngredients.map { item in
            DraftIngredient(amountText: FractionFormatter.string(item.amount, maxFractionValue: 1000), unit: item.unit, name: item.name, ingredientId: item.ingredientId)
        }
        if ingredients.isEmpty { ingredients = [DraftIngredient()] }
        steps = model.steps.map { DraftStep(text: $0) }
        if steps.isEmpty { steps = [DraftStep()] }
        if let override = model.macroOverride {
            useManualMacros = true
            kcalText = String(Int(override.kcal.rounded()))
            proteinText = String(Int(override.protein.rounded()))
            carbsText = String(Int(override.carbs.rounded()))
            fatText = String(Int(override.fat.rounded()))
        }
        notes = model.notes
        sourceURL = model.sourceURL ?? ""
        sourceKind = model.sourceKind
        editingRecipeId = model.recipeId
    }

    /// Pre-fill from parsed text, auto-linking ingredients to the catalog.
    init(parsed: ParsedRecipe, sourceURL: String?, kind: RecipeSourceKind, catalog: FoodCatalog) {
        title = parsed.title ?? ""
        servings = parsed.servings ?? 2
        totalMinutes = parsed.minutes ?? 30
        ingredients = parsed.ingredients.map { item in
            let match: Ingredient? = IngredientMatcher.bestMatch(for: item.name, in: catalog)
            let amountText: String = item.amount.map { FractionFormatter.string($0, maxFractionValue: 1000) } ?? ""
            let unit: MeasureUnit = item.unit ?? (item.amount == nil ? .toTaste : .piece)
            return DraftIngredient(amountText: amountText, unit: unit, name: item.name, ingredientId: match?.id)
        }
        if ingredients.isEmpty { ingredients = [DraftIngredient()] }
        steps = parsed.steps.map { DraftStep(text: $0) }
        if steps.isEmpty { steps = [DraftStep()] }
        self.sourceURL = sourceURL ?? ""
        sourceKind = kind
        emoji = RecipeDraft.guessEmoji(for: title)
        if !parsed.hasContent {
            importNote = String(localized: "this one's recipe is probably spoken in the video. Add the ingredients and we'll do the rest.")
        }
    }

    static func guessEmoji(for title: String) -> String {
        let lower: String = title.lowercased()
        let table: [(String, String)] = [
            ("pasta", "🍝"), ("spaghetti", "🍝"), ("taco", "🌮"), ("burrito", "🌯"), ("wrap", "🌯"), ("curry", "🍛"),
            ("soup", "🍲"), ("stew", "🍲"), ("salad", "🥗"), ("noodle", "🍜"), ("ramen", "🍜"), ("pizza", "🍕"),
            ("burger", "🍔"), ("chicken", "🍗"), ("salmon", "🐟"), ("fish", "🐟"), ("shrimp", "🍤"), ("prawn", "🍤"),
            ("rice", "🍚"), ("egg", "🍳"), ("steak", "🥩"), ("beef", "🥩"), ("sushi", "🍣"), ("dumpling", "🥟")
        ]
        for (keyword, emoji) in table where lower.contains(keyword) {
            return emoji
        }
        return "🍲"
    }

    // MARK: Validation

    var titleError: String? {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? String(localized: "Give your recipe a name") : nil
    }

    var ingredientsError: String? {
        ingredients.contains { !$0.isEmpty } ? nil : String(localized: "Add at least one ingredient")
    }

    var isValid: Bool { titleError == nil && ingredientsError == nil }

    var manualMacros: Macros? {
        guard useManualMacros, let kcal = Double(kcalText.replacingOccurrences(of: ",", with: ".")) else { return nil }
        func value(_ text: String) -> Double { Double(text.replacingOccurrences(of: ",", with: ".")) ?? 0 }
        return Macros(kcal: kcal, protein: value(proteinText), carbs: value(carbsText), fat: value(fatText))
    }

    /// A `Recipe` for live nutrition/preview (not saved).
    func previewRecipe() -> Recipe {
        Recipe(
            id: editingRecipeId ?? "draft",
            title: title,
            emoji: emoji,
            baseServings: max(1, servings),
            ingredients: ingredients.filter { !$0.isEmpty }.map { RecipeIngredient(ingredientId: $0.ingredientId, name: $0.name, amount: $0.amount, unit: $0.unit) },
            steps: steps.map { $0.text }.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
            source: sourceKind,
            macroOverride: nil
        )
    }

    // MARK: Saving

    @MainActor
    @discardableResult
    func save(in context: ModelContext, existing: UserRecipe?) -> UserRecipe {
        let model: UserRecipe = existing ?? UserRecipe(title: title)
        if existing == nil {
            context.insert(model)
        }
        model.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        model.emoji = emoji
        model.servings = max(1, servings)
        model.totalMinutes = max(0, totalMinutes)
        model.tags = tags.sorted()
        model.steps = steps.map { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        model.macroOverride = manualMacros
        model.notes = notes
        model.sourceURL = sourceURL.trimmingCharacters(in: .whitespaces).isEmpty ? nil : sourceURL.trimmingCharacters(in: .whitespaces)
        model.sourceKind = sourceKind
        for old in model.ingredients ?? [] {
            context.delete(old)
        }
        var order: Int = 0
        for item in ingredients where !item.isEmpty {
            let row = UserRecipeIngredient(name: item.name.trimmingCharacters(in: .whitespaces), ingredientId: item.ingredientId, amount: item.amount, unit: item.unit, orderIndex: order)
            row.recipe = model
            context.insert(row)
            order += 1
        }
        try? context.save()
        return model
    }
}
