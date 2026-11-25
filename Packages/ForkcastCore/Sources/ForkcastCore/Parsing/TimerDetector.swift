import Foundation

public struct StepTimer: Hashable, Sendable, Identifiable {
    /// The matched text, e.g. "20 minutes".
    public let label: String
    public let seconds: Int
    public let usesUpperBound: Bool
    public var id: String { "\(label)-\(seconds)" }
}

/// Finds durations like "for 20 minutes", "6 to 8 minutes", "1 hour" in step text.
public enum TimerDetector {
    private static let pattern: String = #"(\d+(?:[.,]\d+)?)(?:\s*(?:-|–|to)\s*(\d+(?:[.,]\d+)?))?\s*(seconds?|secs?|minutes?|mins?|hours?|hrs?)\b"#

    public static func timers(in text: String) -> [StepTimer] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return [] }
        let ns: NSString = text as NSString
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: ns.length))
        var result: [StepTimer] = []
        for match in matches {
            let first: String = ns.substring(with: match.range(at: 1)).replacingOccurrences(of: ",", with: ".")
            var value: Double = Double(first) ?? 0
            let isRange = match.range(at: 2).location != NSNotFound
            if isRange {
                let second: String = ns.substring(with: match.range(at: 2)).replacingOccurrences(of: ",", with: ".")
                // The UI identifies the upper bound as the timer’s default.
                value = max(value, Double(second) ?? value)
            }
            let unit: String = ns.substring(with: match.range(at: 3)).lowercased()
            let multiplier: Double
            if unit.hasPrefix("h") {
                multiplier = 3600
            } else if unit.hasPrefix("m") {
                multiplier = 60
            } else {
                multiplier = 1
            }
            guard let seconds = Int(exactly: (value * multiplier).rounded()), seconds > 0 else { continue }
            result.append(StepTimer(label: ns.substring(with: match.range), seconds: seconds, usesUpperBound: isRange))
        }
        return result
    }

    /// "12:00" / "1:05:00"
    public static func clock(_ seconds: Int) -> String {
        let s: Int = max(0, seconds)
        let hours: Int = s / 3600
        let minutes: Int = (s % 3600) / 60
        let secs: Int = s % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        }
        return String(format: "%d:%02d", minutes, secs)
    }
}

/// Which of a recipe's ingredients a step mentions (for cook-mode chips).
public enum StepIngredientMatcher {
    public static func ingredients(in step: String, recipe: Recipe, catalog: FoodCatalog) -> [RecipeIngredient] {
        let text: String = IngredientMatcher.normalize(step)
        let padded: String = " " + text + " "
        var result: [RecipeIngredient] = []
        for item in recipe.ingredients {
            var names: [String] = []
            if let id = item.ingredientId, let ingredient = catalog.ingredient(id: id) {
                names = [ingredient.name, ingredient.pluralName] + (ingredient.ukName.map { [$0] } ?? [])
            }
            if let custom = item.name { names.append(custom) }
            var found: Bool = false
            for name in names {
                let normalized: String = IngredientMatcher.normalize(name)
                if normalized.isEmpty { continue }
                if padded.contains(" " + normalized + " ") || padded.contains(" " + normalized + "s ") {
                    found = true
                    break
                }
                // Fall back to the last meaningful word ("chicken thighs" -> "chicken").
                let words: [String] = normalized.split(separator: " ").map(String.init)
                if words.count > 1 {
                    let head: String = words[words.count - 2]
                    let last: String = words[words.count - 1]
                    for word in [head, last] where word.count >= 4 && !["fresh", "ground", "dried", "boneless", "raw", "canned", "frozen", "plain", "sauce", "paste", "powder"].contains(word) {
                        if padded.contains(" " + word + " ") || padded.contains(" " + word + "s ") {
                            found = true
                            break
                        }
                    }
                }
                if found { break }
            }
            if found { result.append(item) }
        }
        return result
    }
}
