import Foundation

public struct ParsedIngredient: Hashable, Sendable {
    public var amount: Double?
    public var unit: MeasureUnit?
    public var name: String

    public init(amount: Double?, unit: MeasureUnit?, name: String) {
        self.amount = amount
        self.unit = unit
        self.name = name
    }
}

public struct ParsedRecipe: Hashable, Sendable {
    public var title: String?
    public var servings: Int?
    public var minutes: Int?
    public var ingredients: [ParsedIngredient]
    public var steps: [String]

    public init(title: String? = nil, servings: Int? = nil, minutes: Int? = nil, ingredients: [ParsedIngredient] = [], steps: [String] = []) {
        self.title = title
        self.servings = servings
        self.minutes = minutes
        self.ingredients = ingredients
        self.steps = steps
    }

    /// True when we found something worth pre-filling beyond the title.
    public var hasContent: Bool { !ingredients.isEmpty || !steps.isEmpty }
}

/// Heuristic parser for recipe captions (TikTok, Instagram, pasted text).
/// Used when Apple's on-device model is unavailable.
public enum RecipeTextParser {
    enum Section {
        case unknown
        case ingredients
        case steps
    }

    private static let ingredientHeaders: [String] = ["ingredients", "ingredient", "you'll need", "youll need", "you will need", "what you need", "shopping list", "for the"]
    private static let stepHeaders: [String] = ["method", "steps", "instructions", "directions", "how to make", "how to", "recipe steps", "preparation", "prep"]
    private static let bulletPattern: String = #"^\s*(?:[-•*·▪︎▪️✅✔️☑️🔸🔹👉➡️→]+|\d{1,2}\s*[.):]|step\s*\d+\s*[:.)-]?)\s*"#
    private static let verbs: [String] = ["add", "cook", "bake", "boil", "stir", "mix", "heat", "fry", "chop", "serve", "season", "simmer", "pour", "place", "put", "roast", "whisk", "combine", "preheat", "air fry", "toss", "drain", "slice", "top", "blend", "marinate", "transfer", "bring", "let", "remove", "sprinkle", "spread", "fold", "garnish", "cut", "dice", "melt", "saute", "sauté", "grill"]

    public static func parse(_ text: String) -> ParsedRecipe {
        var result = ParsedRecipe()
        let cleaned: String = stripSocialNoise(text)
        result.servings = findServings(cleaned)
        result.minutes = findMinutes(cleaned)

        var lines: [String] = splitLines(cleaned)
        if lines.isEmpty { return result }

        var section: Section = .unknown
        var sawHeader: Bool = false
        var remaining: [String] = []

        // Title: first line that isn't a header, bullet or ingredient.
        if let first = lines.first, header(for: first) == nil, !isBulleted(first), !looksLikeQuantityLine(first), first.count <= 100 {
            result.title = tidyTitle(first)
            lines.removeFirst()
        }

        for line in lines {
            if let newSection = header(for: line) {
                section = newSection
                sawHeader = true
                // "Ingredients: 2 eggs, 1 cup flour" on the same line.
                let rest: String = textAfterHeader(line)
                if !rest.isEmpty {
                    if section == .ingredients {
                        for part in rest.split(separator: ",") {
                            if let ingredient = parseIngredientLine(String(part)) { result.ingredients.append(ingredient) }
                        }
                    } else {
                        result.steps.append(contentsOf: splitSentences(rest))
                    }
                }
                continue
            }
            switch section {
            case .ingredients:
                if looksLikeStep(line) && !looksLikeIngredient(line) {
                    // Unlabelled switch to steps.
                    section = .steps
                    result.steps.append(stripBullet(line))
                } else if let ingredient = parseIngredientLine(line) {
                    result.ingredients.append(ingredient)
                }
            case .steps:
                let step: String = stripBullet(line)
                if !step.isEmpty { result.steps.append(step) }
            case .unknown:
                remaining.append(line)
            }
        }

        // No headers at all: classify each line.
        if !sawHeader || !remaining.isEmpty {
            for line in remaining {
                if looksLikeIngredient(line), let ingredient = parseIngredientLine(line) {
                    result.ingredients.append(ingredient)
                } else if looksLikeStep(line) || isNumbered(line) {
                    result.steps.append(contentsOf: splitSentences(stripBullet(line)))
                }
            }
        }

        result.steps = result.steps.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { $0.count > 2 }
        return result
    }

    // MARK: Ingredient lines

    public static func parseIngredientLine(_ raw: String) -> ParsedIngredient? {
        var line: String = stripBullet(raw).trimmingCharacters(in: .whitespacesAndNewlines)
        line = line.trimmingCharacters(in: CharacterSet(charactersIn: ",.;"))
        guard !line.isEmpty, line.count < 120 else { return nil }

        var amount: Double? = nil
        var unit: MeasureUnit? = nil
        if let quantity = leadingQuantity(line) {
            amount = quantity.value
            line = String(line[quantity.end...]).trimmingCharacters(in: .whitespaces)
            // Unit glued to the number ("200g") or the next word.
            let tokens: [String] = line.split(separator: " ", maxSplits: 1).map(String.init)
            if let firstToken = tokens.first, let parsed = MeasureUnit.parse(firstToken) {
                unit = parsed
                line = tokens.count > 1 ? tokens[1] : ""
            } else if let glued = quantity.gluedUnit {
                unit = glued
            }
        }
        // Trailing "(200g)" or ", to taste"
        if line.lowercased().hasSuffix("to taste") {
            unit = unit ?? .toTaste
            line = String(line.dropLast("to taste".count)).trimmingCharacters(in: CharacterSet(charactersIn: " ,"))
        }
        if line.lowercased().hasPrefix("of ") { line = String(line.dropFirst(3)) }
        let name: String = line.trimmingCharacters(in: CharacterSet(charactersIn: " ,-:")).trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty, name.rangeOfCharacter(from: .letters) != nil else { return nil }
        return ParsedIngredient(amount: amount, unit: unit, name: name)
    }

    struct Quantity {
        let value: Double
        let end: String.Index
        let gluedUnit: MeasureUnit?
    }

    /// Leading number: "2", "1/2", "1 1/2", "½", "1½", "1.5", "2-3", "200g".
    static func leadingQuantity(_ raw: String) -> Quantity? {
        let line: String = stripBullet(raw)
        let pattern: String = #"^\s*(\d+\s+\d+/\d+|\d+/\d+|\d*[½⅓⅔¼¾⅛]|\d+(?:[.,]\d+)?(?:\s*(?:-|–|to)\s*\d+(?:[.,]\d+)?)?)\s*([a-zA-Z]+)?"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
        let ns: NSString = line as NSString
        guard let match = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: ns.length)) else { return nil }
        let number: String = ns.substring(with: match.range(at: 1))
        guard let value = FractionFormatter.parse(number) else { return nil }
        var endLocation: Int = match.range(at: 1).location + match.range(at: 1).length
        var glued: MeasureUnit? = nil
        if match.range(at: 2).location != NSNotFound {
            let word: String = ns.substring(with: match.range(at: 2))
            let between: Int = match.range(at: 2).location - endLocation
            if between == 0, let unit = MeasureUnit.parse(word) {
                // "200g": unit glued to the number.
                glued = unit
                endLocation = match.range(at: 2).location + match.range(at: 2).length
            }
        }
        guard let swiftRange = Range(NSRange(location: endLocation, length: 0), in: line) else { return nil }
        return Quantity(value: value, end: swiftRange.lowerBound, gluedUnit: glued)
    }

    /// Starts with a quantity, but not "5 minute pasta" / "3-ingredient soup".
    static func looksLikeQuantityLine(_ line: String) -> Bool {
        guard let quantity = leadingQuantity(line) else { return false }
        let rest: String = String(stripBullet(line)[quantity.end...]).lowercased().trimmingCharacters(in: CharacterSet(charactersIn: " -"))
        for word in ["min", "minute", "minutes", "ingredient", "ingredients", "hour", "step", "day"] where rest.hasPrefix(word) {
            return false
        }
        return true
    }

    static func looksLikeIngredient(_ line: String) -> Bool {
        let stripped: String = stripBullet(line)
        if looksLikeQuantityLine(stripped) && stripped.count < 70 { return true }
        let lower: String = stripped.lowercased()
        if lower.hasSuffix("to taste") { return true }
        return false
    }

    static func looksLikeStep(_ line: String) -> Bool {
        let lower: String = stripBullet(line).lowercased()
        for verb in verbs where lower.hasPrefix(verb + " ") || lower.hasPrefix(verb + ",") {
            return true
        }
        return lower.count > 60
    }

    // MARK: Helpers

    static func stripSocialNoise(_ text: String) -> String {
        var result: String = text
        let patterns: [String] = [#"#[\p{L}\p{N}_]+"#, #"@[\p{L}\p{N}_.]+"#, #"https?://\S+"#]
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let ns: NSString = result as NSString
                result = regex.stringByReplacingMatches(in: result, options: [], range: NSRange(location: 0, length: ns.length), withTemplate: "")
            }
        }
        return result
    }

    static func splitLines(_ text: String) -> [String] {
        var prepared: String = text
        // "... Ingredients: 2 eggs ... Method: whisk ..." on one line: break before inline headers.
        if let regex = try? NSRegularExpression(pattern: #"(?<=\S)\s+(?=(?:ingredients|method|steps|instructions|directions)\s*:)"#, options: [.caseInsensitive]) {
            let ns: NSString = prepared as NSString
            prepared = regex.stringByReplacingMatches(in: prepared, options: [], range: NSRange(location: 0, length: ns.length), withTemplate: "\n")
        }
        var lines: [String] = prepared.components(separatedBy: .newlines)
            .flatMap { $0.components(separatedBy: CharacterSet(charactersIn: "•|")) }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        // Single-line captions: also split on softer bullet characters.
        if lines.count <= 2 {
            var expanded: [String] = []
            for line in lines {
                let separators: CharacterSet = CharacterSet(charactersIn: "·▪✅🔸🔹")
                let parts: [String] = line.components(separatedBy: separators)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                expanded.append(contentsOf: parts)
            }
            lines = expanded
        }
        return lines
    }

    static func header(for line: String) -> Section? {
        let lower: String = IngredientMatcher.normalize(line.replacingOccurrences(of: "’", with: "'").replacingOccurrences(of: "'", with: ""))
        let words: [String] = lower.split(separator: " ").map(String.init)
        guard !words.isEmpty, words.count <= 8 || line.contains(":") else { return nil }
        for header in ingredientHeaders {
            let normalizedHeader: String = IngredientMatcher.normalize(header.replacingOccurrences(of: "'", with: ""))
            if lower == normalizedHeader || lower.hasPrefix(normalizedHeader + " ") && (line.contains(":") || words.count <= 3) {
                return .ingredients
            }
        }
        for header in stepHeaders {
            let normalizedHeader: String = IngredientMatcher.normalize(header)
            if lower == normalizedHeader || lower.hasPrefix(normalizedHeader + " ") && (line.contains(":") || words.count <= 3) {
                return .steps
            }
        }
        return nil
    }

    static func textAfterHeader(_ line: String) -> String {
        guard let colon = line.firstIndex(of: ":") else { return "" }
        return String(line[line.index(after: colon)...]).trimmingCharacters(in: .whitespaces)
    }

    static func isBulleted(_ line: String) -> Bool {
        stripBullet(line) != line.trimmingCharacters(in: .whitespaces)
    }

    static func isNumbered(_ line: String) -> Bool {
        let pattern: String = #"^\s*(?:\d{1,2}\s*[.):]|step\s*\d+)"#
        return line.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    static func stripBullet(_ line: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: bulletPattern, options: [.caseInsensitive]) else { return line }
        let ns: NSString = line as NSString
        let stripped: String = regex.stringByReplacingMatches(in: line, options: [], range: NSRange(location: 0, length: ns.length), withTemplate: "")
        return stripped.trimmingCharacters(in: .whitespaces)
    }

    static func splitSentences(_ text: String) -> [String] {
        let parts: [String] = text.components(separatedBy: ". ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return parts.map { $0.hasSuffix(".") ? $0 : $0 + "." }
    }

    static func tidyTitle(_ line: String) -> String {
        var title: String = line
        // Captions often continue after an emoji ("best pasta ever 😭🍝 recipe in the video").
        if let emojiIndex = title.firstIndex(where: { isEmoji($0) }), emojiIndex != title.startIndex {
            title = String(title[..<emojiIndex])
        }
        // Drop trailing punctuation and decorative emoji.
        while let last = title.last, !(last.isLetter || last.isNumber || last == ")") {
            title.removeLast()
        }
        while let first = title.first, !(first.isLetter || first.isNumber) {
            title.removeFirst()
        }
        return title.trimmingCharacters(in: .whitespaces)
    }

    static func isEmoji(_ character: Character) -> Bool {
        guard let scalar = character.unicodeScalars.first else { return false }
        return scalar.properties.isEmojiPresentation || (scalar.properties.isEmoji && scalar.value > 0x238C)
    }

    static func findServings(_ text: String) -> Int? {
        let patterns: [String] = [#"serves\s*(\d+)"#, #"(\d+)\s*servings?"#, #"for\s*(\d+)\s*people"#, #"makes\s*(\d+)\s*(?:portions|bowls|servings)"#]
        for pattern in patterns {
            if let value = firstInt(pattern, in: text), value > 0, value < 20 { return value }
        }
        return nil
    }

    static func findMinutes(_ text: String) -> Int? {
        if let total = firstInt(#"(?:ready in|takes|total(?: time)?:?|in just|in only|only)\s*(\d+)\s*(?:min|mins|minutes)"#, in: text) {
            return total
        }
        if let value = firstInt(#"(\d+)\s*[- ]?(?:min|mins|minute|minutes)\b(?:\s+(?:meal|dinner|recipe))"#, in: text) {
            return value
        }
        return nil
    }

    static func firstInt(_ pattern: String, in text: String) -> Int? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return nil }
        let ns: NSString = text as NSString
        guard let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: ns.length)), match.numberOfRanges > 1 else { return nil }
        return Int(ns.substring(with: match.range(at: 1)))
    }
}
