import Foundation

/// Budget defaults, verdicts and the honest "savings moment" estimate.
public enum BudgetMath {
    public enum Verdict: String, Sendable {
        case tight
        case comfortable
        case plenty

        public var title: String {
            switch self {
            case .tight: return "Tight"
            case .comfortable: return "Comfortable"
            case .plenty: return "Plenty of room"
            }
        }
    }

    /// Portions per meal: adults count 1, kids count ½.
    public static func portions(adults: Int, kids: Int) -> Double {
        Double(max(1, adults)) + Double(max(0, kids)) * 0.5
    }

    /// Typical planned cost per portion in the region's currency.
    public static func plannedCostPerPortion(region: RegionPriceKey) -> Double {
        switch region {
        case .US: return 3.5
        case .UK: return 2.6
        case .EU: return 3.0
        }
    }

    /// Typical cost of an unplanned dinner (takeaway, top-up shops, waste) per portion.
    public static func unplannedCostPerPortion(region: RegionPriceKey) -> Double {
        switch region {
        case .US: return 9.0
        case .UK: return 7.0
        case .EU: return 7.5
        }
    }

    public static func step(region: RegionPriceKey) -> Double { 5 }

    /// Slider range. US default $35–$250, widened for big households.
    public static func range(region: RegionPriceKey, portions: Double, days: Int, multiplier: Double = 1) -> ClosedRange<Double> {
        let base: (Double, Double)
        switch region {
        case .US: base = (35, 250)
        case .UK: base = (25, 200)
        case .EU: base = (30, 220)
        }
        let suggested: Double = defaultBudget(region: region, portions: portions, days: days, multiplier: multiplier)
        let lower: Double = roundTo5(base.0 * multiplier)
        let upper: Double = roundTo5(max(base.1 * multiplier, suggested * 2.5))
        return lower...max(upper, lower + 50)
    }

    public static func defaultBudget(region: RegionPriceKey, portions: Double, days: Int, multiplier: Double = 1) -> Double {
        let raw: Double = portions * Double(max(1, days)) * plannedCostPerPortion(region: region) * multiplier
        return max(roundTo5(raw), 20)
    }

    public static func costPerServing(budget: Double, portions: Double, days: Int) -> Double {
        let servings: Double = portions * Double(max(1, days))
        return servings > 0 ? budget / servings : 0
    }

    public static func verdict(budget: Double, portions: Double, days: Int, region: RegionPriceKey, multiplier: Double = 1) -> Verdict {
        let perServing: Double = costPerServing(budget: budget, portions: portions, days: days)
        let typical: Double = plannedCostPerPortion(region: region) * multiplier
        if perServing < typical * 0.8 { return .tight }
        if perServing < typical * 1.6 { return .comfortable }
        return .plenty
    }

    /// estimatedWeeklySavings = max(5, portionsPerWeek × unplanned − planned × portionsPerWeek) × 0.25,
    /// capped at a believable value. Returns (weekly, yearly).
    public static func estimatedSavings(budget: Double, portions: Double, days: Int, region: RegionPriceKey, multiplier: Double = 1) -> (weekly: Double, yearly: Double) {
        let portionsPerWeek: Double = portions * Double(max(1, days))
        let plannedPerPortion: Double = portionsPerWeek > 0 ? budget / portionsPerWeek : 0
        let unplanned: Double = unplannedCostPerPortion(region: region) * multiplier
        let gap: Double = portionsPerWeek * unplanned - plannedPerPortion * portionsPerWeek
        var weekly: Double = max(5, gap) * 0.25
        weekly = min(weekly, 40 * multiplier)
        weekly = (weekly * 2).rounded() / 2
        return (weekly, (weekly * 52).rounded())
    }

    static func roundTo5(_ value: Double) -> Double {
        (value / 5).rounded() * 5
    }
}
