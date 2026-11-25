import Foundation

public enum PlannerGoal: String, Hashable, Sendable {
    case spendLess, stopWondering, eatHealthier, saveTime, cookMore, feedFamily
}

public enum PlannerObstacle: String, Hashable, Sendable {
    case overspend, dontKnowWhat, planningTakesLong, tooTired, foodGoesOff, noList, messyRecipes, sameMeals
}

public struct TailoringWeights: Hashable, Sendable {
    public let everyday: Double
    public let effort: Double
    public let onePan: Double
    public let cheapness: Double
    public let reuse: Double
    public let family: Double
    public let health: Double
    public let protein: Double
    public let perishability: Double
    public let novelty: Double
    public let saved: Double
    public let pairsLeftovers: Bool

    public init(profile: PlannerProfile) {
        let goals = profile.goals
        let obstacles = profile.obstacles
        let saving = goals.contains(.spendLess) || obstacles.contains(.overspend)
        let tired = obstacles.contains(.tooTired)
        let time = goals.contains(.saveTime) || tired || obstacles.contains(.planningTakesLong)
        let variety = obstacles.contains(.sameMeals)
        let approachable = goals.contains(.stopWondering) || goals.contains(.cookMore) || obstacles.contains(.dontKnowWhat)
        let waste = obstacles.contains(.foodGoesOff)
        everyday = time ? 4.0 : (approachable ? 3.0 : 2.0)
        effort = time ? 4.0 : 1.2
        onePan = time ? 1.2 : 0.25
        cheapness = saving ? 4.0 : 1.15
        reuse = waste ? 7.0 : (saving || obstacles.contains(.noList) ? 2.3 : 0.9)
        family = profile.children > 0 ? 7 : (goals.contains(.feedFamily) ? 4.0 : 0)
        health = goals.contains(.eatHealthier) || profile.vibes.contains(.lowCalorie) ? 2.8 : 0.55
        protein = profile.vibes.contains(.highProtein) ? 5.0 : 0
        perishability = waste ? 4.0 : 0.7
        novelty = variety ? 2.0 : (approachable ? 1.2 : 0.65)
        saved = obstacles.contains(.messyRecipes) ? 1.1 : 0.35
        pairsLeftovers = profile.prefersMealPrep || tired
    }
}
