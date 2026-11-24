import Foundation

/// Turns 0.333 into "⅓" and 1.5 into "1½".
public enum FractionFormatter {
    private static let fractions: [(value: Double, glyph: String)] = [
        (0, ""),
        (0.125, "⅛"),
        (0.25, "¼"),
        (1.0 / 3.0, "⅓"),
        (0.5, "½"),
        (2.0 / 3.0, "⅔"),
        (0.75, "¾"),
        (1, "")
    ]

    /// Nearest "nice" fraction string. Values above `maxFractionValue` are
    /// rounded to whole numbers (nobody wants "12⅓ oz").
    public static func string(_ value: Double, maxFractionValue: Double = 10) -> String {
        guard value.isFinite, value > 0 else { return "0" }
        if value >= maxFractionValue {
            return String(Int(value.rounded()))
        }
        let whole: Double = value.rounded(.down)
        let remainder: Double = value - whole
        var best: (value: Double, glyph: String) = fractions[0]
        var bestDistance: Double = .greatestFiniteMagnitude
        for candidate in fractions {
            let distance: Double = abs(candidate.value - remainder)
            if distance < bestDistance - 1e-9 {
                best = candidate
                bestDistance = distance
            }
        }
        var wholeInt: Int = Int(whole)
        var glyph: String = best.glyph
        if best.value == 1 {
            wholeInt += 1
            glyph = ""
        }
        if wholeInt == 0 && glyph.isEmpty {
            // Tiny but non-zero: show the smallest fraction rather than "0".
            return "⅛"
        }
        if wholeInt == 0 { return glyph }
        return glyph.isEmpty ? String(wholeInt) : "\(wholeInt)\(glyph)"
    }

    /// Parses "1/2", "1 1/2", "½", "1½", "1.5", "2-3" (takes the first number).
    public static func parse(_ text: String) -> Double? {
        let unicode: [Character: Double] = ["½": 0.5, "⅓": 1.0 / 3.0, "⅔": 2.0 / 3.0, "¼": 0.25, "¾": 0.75, "⅛": 0.125, "⅕": 0.2, "⅙": 1.0 / 6.0]
        var trimmed: String = text.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return nil }
        // Ranges: keep the first number.
        for separator in ["-", "–", "to"] {
            if let range = trimmed.range(of: separator), range.lowerBound != trimmed.startIndex {
                trimmed = String(trimmed[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
            }
        }
        // Unicode fraction, optionally after a whole number ("1½").
        if let last = trimmed.last, let frac = unicode[last] {
            let head: String = String(trimmed.dropLast()).trimmingCharacters(in: .whitespaces)
            if head.isEmpty { return frac }
            if let whole = Double(head) { return whole + frac }
            return nil
        }
        let parts: [String] = trimmed.split(separator: " ").map(String.init)
        if parts.count == 2, let whole = Double(parts[0]), let frac = simpleFraction(parts[1]) {
            return whole + frac
        }
        if parts.count == 1 {
            if let frac = simpleFraction(parts[0]) { return frac }
            return Double(parts[0].replacingOccurrences(of: ",", with: "."))
        }
        return nil
    }

    private static func simpleFraction(_ text: String) -> Double? {
        let pieces: [String] = text.split(separator: "/").map(String.init)
        guard pieces.count == 2, let n = Double(pieces[0]), let d = Double(pieces[1]), d != 0 else { return nil }
        return n / d
    }
}
