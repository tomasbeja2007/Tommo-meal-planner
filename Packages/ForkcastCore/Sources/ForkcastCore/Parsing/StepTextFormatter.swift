import Foundation

/// Rewrites the measurements written inside recipe steps for the reader's unit system.
///
/// - "200°C (400°F)" keeps only the reader's half; a lone temperature is converted.
/// - Volumes ("350 ml", "1.5 litres", "2 cups"), weights ("400 g", "14 oz") and lengths
///   ("1 cm", "8-inch") are converted when written in the other system.
/// - A range ("2–3 cm") is left as written rather than half-converted.
/// Text already in the reader's system comes back unchanged.
public enum StepTextFormatter {
    public static func string(_ text: String, system: UnitSystem) -> String {
        var result: String = pairedTemperatures(text, system: system)
        result = loneTemperatures(result, system: system)
        result = volumes(result, system: system)
        result = masses(result, system: system)
        result = lengths(result, system: system)
        return result
    }

    // MARK: Temperatures

    /// "200°C (400°F)", "400°F (200°C)" and "200°C / 400°F": keep the reader's one.
    static func pairedTemperatures(_ text: String, system: UnitSystem) -> String {
        let pattern: String = #"(\d+)\s*°\s*([CF])\s*(?:\(\s*(\d+)\s*°\s*([CF])\s*\)|/\s*(\d+)\s*°\s*([CF]))"#
        return replace(text, pattern) { groups in
            guard let firstValue = groups[1], let firstScale = groups[2]?.uppercased(),
                  let secondValue = groups[3] ?? groups[5], let secondScale = (groups[4] ?? groups[6])?.uppercased(),
                  firstScale != secondScale else { return nil }
            let wanted: String = system == .metric ? "C" : "F"
            return firstScale == wanted ? "\(firstValue)°\(firstScale)" : "\(secondValue)°\(secondScale)"
        }
    }

    static func loneTemperatures(_ text: String, system: UnitSystem) -> String {
        let pattern: String = #"(\d+)\s*°\s*([CF])\b"#
        return replace(text, pattern) { groups in
            guard let raw = groups[1], let value = Double(raw), let scale = groups[2]?.uppercased() else { return nil }
            switch (scale, system) {
            case ("C", .imperial):
                return "\(Int(fahrenheit(celsius: value)))°F"
            case ("F", .metric):
                return "\(Int(celsius(fahrenheit: value)))°C"
            default:
                return "\(raw)°\(scale)"
            }
        }
    }

    /// Oven temperatures land on the usual dial steps (200°C → 400°F); food temperatures stay close (75°C → 165°F).
    static func fahrenheit(celsius: Double) -> Double {
        let exact: Double = celsius * 9 / 5 + 32
        let step: Double = celsius >= 120 ? 25 : 5
        return (exact / step).rounded() * step
    }

    static func celsius(fahrenheit: Double) -> Double {
        let exact: Double = (fahrenheit - 32) * 5 / 9
        let step: Double = fahrenheit >= 250 ? 10 : 1
        return (exact / step).rounded() * step
    }

    // MARK: Volumes, weights, lengths

    /// A number, optionally with a fraction ("1½", "1 1/2", "½", "1.5", "1,5").
    private static let number: String = #"(\d+\s+\d+/\d+|\d+\s*[½¼¾⅓⅔⅛]|\d+/\d+|\d+(?:[.,]\d+)?|[½¼¾⅓⅔⅛])"#
    /// Set when the number is the end of a range ("2–3 cm"), which is left as written.
    private static let rangeStart: String = #"(\d\s*[-–]\s*|\bto\s+)?"#

    static func volumes(_ text: String, system: UnitSystem) -> String {
        switch system {
        case .imperial:
            let pattern: String = rangeStart + number + #"\s*(ml|millilit(?:re|er)s?|l|lit(?:re|er)s?)\b"#
            return replace(text, pattern) { groups in
                guard groups[1] == nil, let amount = parse(groups[2]), let unit = groups[3]?.lowercased() else { return nil }
                let ml: Double = unit.hasPrefix("m") ? amount : amount * 1000
                return imperialVolume(ml: ml)
            }
        case .metric:
            let pattern: String = rangeStart + number + #"\s*(cups?|fl\.?\s?oz|fluid ounces?)\b"#
            return replace(text, pattern) { groups in
                guard groups[1] == nil, let amount = parse(groups[2]), let unit = groups[3]?.lowercased() else { return nil }
                let ml: Double = unit.hasPrefix("c") ? amount * 240 : amount * 29.5735
                return QuantityFormatter.volume(ml: ml, system: .metric)
            }
        }
    }

    /// Cups for liquids, rounded to the quarter cup above one cup ("1 litre" → "4¼ cups").
    static func imperialVolume(ml: Double) -> String {
        let cups: Double = ml / 240
        guard cups >= 1 else { return QuantityFormatter.volume(ml: ml, system: .imperial) }
        let rounded: Double = (cups * 4).rounded() / 4
        return "\(FractionFormatter.string(rounded)) \(rounded > 1.0001 ? "cups" : "cup")"
    }

    static func masses(_ text: String, system: UnitSystem) -> String {
        switch system {
        case .imperial:
            let pattern: String = rangeStart + number + #"\s*(g|grams?|kg|kilograms?)\b"#
            return replace(text, pattern) { groups in
                guard groups[1] == nil, let amount = parse(groups[2]), let unit = groups[3]?.lowercased() else { return nil }
                let grams: Double = unit.hasPrefix("k") ? amount * 1000 : amount
                return QuantityFormatter.mass(grams: grams, system: .imperial)
            }
        case .metric:
            let pattern: String = rangeStart + number + #"\s*(oz|ounces?|lbs?|pounds?)\b"#
            return replace(text, pattern) { groups in
                guard groups[1] == nil, let amount = parse(groups[2]), let unit = groups[3]?.lowercased() else { return nil }
                let grams: Double = unit.hasPrefix("o") ? amount * 28.3495 : amount * 453.592
                return QuantityFormatter.mass(grams: grams, system: .metric)
            }
        }
    }

    /// Words after a length that describe it ("1 cm thick") rather than name a thing ("1 cm pieces").
    private static let lengthDescriptors: Set<String> = ["thick", "thin", "wide", "long", "deep", "apart", "high", "tall", "across", "in", "of", "from", "to", "and", "or", "each", "per"]

    /// "1 cm thick" → "½ inch thick", "1 cm pieces" → "½-inch pieces", "a 20 cm circle" → "an 8-inch circle".
    static func lengths(_ text: String, system: UnitSystem) -> String {
        let unit: String = system == .imperial ? #"(?:cm|mm)\b"# : #"(?:\s*-\s*)?(?:inch(?:es)?|in\.)(?=\W|$)"#
        let pattern: String = #"(\b(?:a|an)\s+)?"# + rangeStart + number + #"\s*("# + unit + #")(\s+[A-Za-z]+)?"#
        return replace(text, pattern) { groups in
            guard groups[2] == nil, let amount = parse(groups[3]), let written = groups[4]?.lowercased() else { return nil }
            let next: String? = groups[5]
            let namesAThing: Bool = next.map { !lengthDescriptors.contains($0.trimmingCharacters(in: .whitespaces).lowercased()) } ?? false
            let value: String
            let label: String
            switch system {
            case .imperial:
                let inches: Double = (written == "mm" ? amount / 10 : amount) / 2.54
                // Small cuts to the quarter inch, pans and circles to the half inch.
                let step: Double = inches < 3 ? 0.25 : 0.5
                let rounded: Double = max(0.25, (inches / step).rounded() * step)
                value = FractionFormatter.string(rounded)
                label = namesAThing ? "-inch" : (rounded > 1.0001 ? " inches" : " inch")
            case .metric:
                let cm: Double = amount * 2.54
                let rounded: Double = cm < 2 ? max(0.5, (cm * 2).rounded() / 2) : cm.rounded()
                value = rounded == rounded.rounded() ? String(Int(rounded)) : String(format: "%.1f", rounded)
                label = " cm"
            }
            var article: String = ""
            if let original = groups[1] {
                let spoken: String = ["8", "11", "18"].contains(where: { value.hasPrefix($0) }) && !value.hasPrefix("1⅛") ? "an " : "a "
                article = original.first?.isUppercase == true ? spoken.prefix(1).uppercased() + spoken.dropFirst() : spoken
            }
            return article + value + label + (next ?? "")
        }
    }

    // MARK: Helpers

    static func parse(_ raw: String?) -> Double? {
        guard let raw else { return nil }
        let cleaned: String = raw.replacingOccurrences(of: ",", with: ".")
        if let value = Double(cleaned) { return value }
        return FractionFormatter.parse(cleaned)
    }

    /// Replaces each match with `transform(groups)`; nil keeps the matched text.
    static func replace(_ text: String, _ pattern: String, _ transform: ([String?]) -> String?) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return text }
        let source = text as NSString
        let matches: [NSTextCheckingResult] = regex.matches(in: text, range: NSRange(location: 0, length: source.length))
        guard !matches.isEmpty else { return text }
        var output: String = ""
        var cursor: Int = 0
        for match in matches {
            let groups: [String?] = (0..<match.numberOfRanges).map { index in
                let range: NSRange = match.range(at: index)
                return range.location == NSNotFound ? nil : source.substring(with: range)
            }
            output += source.substring(with: NSRange(location: cursor, length: match.range.location - cursor))
            output += transform(groups) ?? source.substring(with: match.range)
            cursor = match.range.location + match.range.length
        }
        output += source.substring(from: cursor)
        return output
    }
}
