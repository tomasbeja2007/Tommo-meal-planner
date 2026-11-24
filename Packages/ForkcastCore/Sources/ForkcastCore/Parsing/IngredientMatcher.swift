import Foundation

/// Fuzzy matching of free-text ingredient names to `ingredients.json`.
public enum IngredientMatcher {
    private static let fillerWords: Set<String> = [
        "fresh", "freshly", "chopped", "diced", "sliced", "minced", "grated", "large", "small", "medium",
        "of", "a", "an", "the", "some", "finely", "roughly", "thinly", "crushed", "peeled", "ripe",
        "boneless", "skinless", "organic", "frozen", "tinned", "canned", "dried", "ground", "whole",
        "cooked", "raw", "to", "taste", "optional", "for", "serving", "and", "or", "handful", "big", "pinch"
    ]

    public static func normalize(_ text: String) -> String {
        let lowered: String = text.lowercased()
        let cleaned: String = String(lowered.map { ch -> Character in
            (ch.isLetter || ch == " ") ? ch : " "
        })
        return cleaned.split(separator: " ").map(String.init).joined(separator: " ")
    }

    static func keywords(_ text: String) -> [String] {
        normalize(text).split(separator: " ").map(String.init).filter { !fillerWords.contains($0) }
    }

    static func names(for ingredient: Ingredient) -> [String] {
        var all: [String] = [ingredient.name, ingredient.pluralName, ingredient.id.replacingOccurrences(of: "-", with: " ")]
        if let uk = ingredient.ukName { all.append(uk) }
        return all.map { normalize($0) }
    }

    /// Score how well `query` matches `ingredient`; 0 = no match.
    static func score(query: String, ingredient: Ingredient) -> Double {
        let words: [String] = keywords(query)
        guard !words.isEmpty else { return 0 }
        let joined: String = words.joined(separator: " ")
        var best: Double = 0
        for candidate in names(for: ingredient) {
            if candidate == joined {
                best = max(best, 100)
                continue
            }
            let candidateWords: [String] = candidate.split(separator: " ").map(String.init)
            let candidateSet: Set<String> = Set(candidateWords)
            let querySet: Set<String> = Set(words)
            if candidateSet.isSubset(of: querySet) {
                // "olive oil" inside "extra virgin olive oil"
                best = max(best, 50 + Double(candidate.count))
            } else if querySet.isSubset(of: candidateSet) {
                best = max(best, 30 + Double(joined.count))
            } else {
                let overlap: Int = candidateSet.intersection(querySet).count
                if overlap > 0 {
                    best = max(best, 10 * Double(overlap) + Double(overlap == candidateSet.count ? 5 : 0))
                }
            }
        }
        return best
    }

    public static func bestMatch(for query: String, in catalog: FoodCatalog, minimumScore: Double = 30) -> Ingredient? {
        var bestIngredient: Ingredient? = nil
        var bestScore: Double = 0
        for ingredient in catalog.ingredients {
            let value: Double = score(query: query, ingredient: ingredient)
            if value > bestScore {
                bestScore = value
                bestIngredient = ingredient
            }
        }
        return bestScore >= minimumScore ? bestIngredient : nil
    }

    /// Autocomplete suggestions while typing.
    public static func suggestions(for query: String, in catalog: FoodCatalog, limit: Int = 5) -> [Ingredient] {
        let q: String = normalize(query)
        guard q.count >= 2 else { return [] }
        var scored: [(Ingredient, Double)] = []
        for ingredient in catalog.ingredients {
            var value: Double = score(query: query, ingredient: ingredient)
            for name in names(for: ingredient) where name.hasPrefix(q) {
                value = max(value, 80 - Double(name.count) * 0.1)
            }
            if value == 0 {
                for name in names(for: ingredient) where name.contains(q) {
                    value = max(value, 20)
                }
            }
            if value > 0 { scored.append((ingredient, value)) }
        }
        return scored.sorted { $0.1 > $1.1 }.prefix(limit).map { $0.0 }
    }
}
