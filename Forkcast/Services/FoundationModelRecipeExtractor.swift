import Foundation
import ForkcastCore

// Apple's on-device Foundation Models (iOS 26+, Apple Intelligence devices).
// Compiled only with an SDK that has the framework; used only at runtime on iOS 26.
#if canImport(FoundationModels)
import FoundationModels

@available(iOS 26.0, *)
@Generable
struct GeneratedIngredient {
    @Guide(description: "The quantity exactly as written, e.g. \"2\", \"1/2\", \"200\". Empty if none.")
    var amount: String
    @Guide(description: "The unit exactly as written, e.g. \"g\", \"tbsp\", \"cup\", \"clove\". Empty if none.")
    var unit: String
    @Guide(description: "The ingredient name only, e.g. \"red onion\".")
    var name: String
}

@available(iOS 26.0, *)
@Generable
struct GeneratedRecipe {
    @Guide(description: "A short dish name taken from the text.")
    var title: String
    @Guide(description: "Number of servings if stated, otherwise 0.")
    var servings: Int
    @Guide(description: "Total minutes if stated, otherwise 0.")
    var minutes: Int
    @Guide(description: "Only ingredients that appear in the text.")
    var ingredients: [GeneratedIngredient]
    @Guide(description: "Method steps in order, only as written in the text.")
    var steps: [String]
}

@available(iOS 26.0, *)
enum FoundationModelRecipeExtractor {
    static var isAvailable: Bool {
        if case .available = SystemLanguageModel.default.availability {
            return true
        }
        return false
    }

    static func extract(from text: String) async throws -> ParsedRecipe {
        let instructions: String = """
        You extract recipes from social media captions. Use ONLY information present in the text. \
        Never invent ingredients, quantities or steps. If something isn't in the text, leave it empty or 0.
        """
        let session = LanguageModelSession(instructions: instructions)
        let response = try await session.respond(to: "Extract the recipe from this caption:\n\n\(text)", generating: GeneratedRecipe.self)
        let generated: GeneratedRecipe = response.content
        let ingredients: [ParsedIngredient] = generated.ingredients.compactMap { item in
            let name: String = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { return nil }
            return ParsedIngredient(
                amount: FractionFormatter.parse(item.amount),
                unit: MeasureUnit.parse(item.unit),
                name: name
            )
        }
        return ParsedRecipe(
            title: generated.title.isEmpty ? nil : generated.title,
            servings: generated.servings > 0 ? generated.servings : nil,
            minutes: generated.minutes > 0 ? generated.minutes : nil,
            ingredients: ingredients,
            steps: generated.steps.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        )
    }
}
#endif
