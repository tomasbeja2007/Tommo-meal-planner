import Foundation

/// Converts recipe quantities into grams (for nutrition) and into the
/// ingredient's base unit (for grocery aggregation).
public enum UnitConverter {
    public static func millilitres(per unit: MeasureUnit) -> Double? {
        switch unit {
        case .ml: return 1
        case .l: return 1000
        case .tsp: return 5
        case .tbsp: return 15
        case .cup: return 240
        default: return nil
        }
    }

    public static func grams(perMassUnit unit: MeasureUnit) -> Double? {
        switch unit {
        case .g: return 1
        case .kg: return 1000
        case .oz: return 28.3495
        case .lb: return 453.592
        default: return nil
        }
    }

    /// Grams of an ingredient for an amount in any unit. Nil when impossible
    /// (e.g. "2 pieces" of something without a known piece weight).
    public static func grams(amount: Double, unit: MeasureUnit, ingredient: Ingredient?) -> Double? {
        if unit == .toTaste { return 0 }
        if let ingredient {
            if let explicit = ingredient.grams(perUnit: unit) {
                return amount * explicit
            }
            if ingredient.baseUnit == .piece, unit == .piece, let perPiece = ingredient.grams(perUnit: .piece) {
                return amount * perPiece
            }
        }
        if let factor = grams(perMassUnit: unit) {
            return amount * factor
        }
        if let ml = millilitres(per: unit) {
            return amount * ml * (ingredient?.gramsPerMl ?? 1)
        }
        if unit == .pinch {
            return amount * 0.4
        }
        return nil
    }

    /// Amount in the ingredient's base unit (g, ml or piece).
    public static func baseAmount(amount: Double, unit: MeasureUnit, ingredient: Ingredient) -> Double? {
        if unit == .toTaste { return 0 }
        switch ingredient.baseUnit {
        case .g:
            return grams(amount: amount, unit: unit, ingredient: ingredient)
        case .ml:
            if let ml = millilitres(per: unit) {
                return amount * ml
            }
            if let g = grams(amount: amount, unit: unit, ingredient: ingredient) {
                return g / (ingredient.gramsPerMl ?? 1)
            }
            return nil
        case .piece:
            if unit == .piece { return amount }
            if let g = grams(amount: amount, unit: unit, ingredient: ingredient),
               let perPiece = ingredient.grams(perUnit: .piece), perPiece > 0 {
                return g / perPiece
            }
            return nil
        }
    }
}

/// Human-friendly quantity strings in the user's unit system.
public enum QuantityFormatter {
    /// e.g. "400 g", "14 oz", "2 tbsp", "1½ cups", "3 cloves", "2".
    public static func string(amount: Double, unit: MeasureUnit, system: UnitSystem, ingredient: Ingredient?) -> String {
        if unit == .toTaste { return "to taste" }
        switch unit {
        case .g, .kg, .oz, .lb:
            let grams: Double = amount * (UnitConverter.grams(perMassUnit: unit) ?? 1)
            return mass(grams: grams, system: system)
        case .ml, .l:
            let ml: Double = amount * (UnitConverter.millilitres(per: unit) ?? 1)
            return volume(ml: ml, system: system)
        case .cup:
            if system == .metric {
                let ml: Double = amount * 240
                if let ingredient, ingredient.baseUnit == .g, let g = UnitConverter.grams(amount: amount, unit: .cup, ingredient: ingredient) {
                    return mass(grams: g, system: .metric)
                }
                return volume(ml: ml, system: .metric)
            }
            return "\(FractionFormatter.string(amount)) \(unit.label(for: amount))"
        case .tsp, .tbsp, .clove, .pinch, .slice, .bunch:
            return "\(FractionFormatter.string(amount)) \(unit.label(for: amount))"
        case .piece:
            return FractionFormatter.string(amount)
        case .toTaste:
            return "to taste"
        }
    }

    public static func mass(grams: Double, system: UnitSystem) -> String {
        switch system {
        case .metric:
            if grams >= 1000 {
                let kg: Double = (grams / 100).rounded() / 10
                return "\(trim(kg)) kg"
            }
            return "\(Int(roundMetric(grams))) g"
        case .imperial:
            let oz: Double = grams / 28.3495
            if oz >= 16 {
                let lb: Double = (oz / 16 * 4).rounded() / 4
                return "\(FractionFormatter.string(lb)) lb"
            }
            if oz < 0.25 {
                return "¼ oz"
            }
            return "\(FractionFormatter.string(oz, maxFractionValue: 4)) oz"
        }
    }

    public static func volume(ml: Double, system: UnitSystem) -> String {
        switch system {
        case .metric:
            if ml >= 1000 {
                let l: Double = (ml / 100).rounded() / 10
                return "\(trim(l)) l"
            }
            if ml < 15 {
                return "\(FractionFormatter.string(ml / 5)) tsp"
            }
            return "\(Int(roundMetric(ml))) ml"
        case .imperial:
            if ml < 14 {
                return "\(FractionFormatter.string(ml / 5)) tsp"
            }
            if ml < 59 {
                return "\(FractionFormatter.string(ml / 15)) tbsp"
            }
            let cups: Double = ml / 240
            return "\(FractionFormatter.string(cups)) \(cups > 1.0001 ? "cups" : "cup")"
        }
    }

    /// Display a base-unit amount for an ingredient (used by the grocery list).
    public static func baseString(_ base: Double, ingredient: Ingredient, system: UnitSystem) -> String {
        switch ingredient.baseUnit {
        case .g:
            if [.produce, .bakery].contains(ingredient.aisle), let perPiece = ingredient.grams(perUnit: .piece), perPiece > 0 {
                let count: Double = base / perPiece
                let noun: String = count > 1.0001 ? ingredient.displayName(for: system, plural: true) : ingredient.displayName(for: system)
                return "\(FractionFormatter.string(count)) \(noun)"
            }
            return mass(grams: base, system: system)
        case .ml:
            return volume(ml: base, system: system)
        case .piece:
            let noun: String = base > 1.0001 ? ingredient.pluralName : ingredient.name
            return "\(FractionFormatter.string(base)) \(noun)"
        }
    }

    static func roundMetric(_ value: Double) -> Double {
        if value < 20 { return max(1, value.rounded()) }
        if value < 100 { return (value / 5).rounded() * 5 }
        if value < 1000 { return (value / 10).rounded() * 10 }
        return (value / 50).rounded() * 50
    }

    static func trim(_ value: Double) -> String {
        if value == value.rounded() { return String(Int(value)) }
        return String(format: "%.1f", value)
    }
}
