import Foundation

public struct TasteEvent: Hashable, Sendable {
    public enum Kind: String, Hashable, Sendable {
        case planned, cooked, skipped, swappedAway, chosenAsSwap, liked, notForMe, stars, saved, cookedAgain
        case ratingCleared, unsaved

        var isRating: Bool {
            self == .liked || self == .notForMe || self == .ratingCleared
        }
    }

    public let recipeId: String
    public let kind: Kind
    public let date: Date
    public let stars: Int?

    public init(recipeId: String, kind: Kind, date: Date, stars: Int? = nil) {
        self.recipeId = recipeId
        self.kind = kind
        self.date = date
        self.stars = stars
    }

    var weight: Double {
        switch kind {
        case .planned, .ratingCleared, .unsaved: return 0
        case .cooked: return 0.75
        case .skipped: return -0.55
        case .swappedAway: return -0.85
        case .chosenAsSwap: return 0.9
        case .liked: return 2.6
        case .notForMe: return -3.0
        case .stars:
            guard let stars, (1...5).contains(stars) else { return 0 }
            return Double(stars - 3) * 1.35
        case .saved: return 0.65
        case .cookedAgain: return 1.15
        }
    }
}

public struct TasteProfile: Sendable {
    public private(set) var cuisines: [Cuisine: Double] = [:]
    public private(set) var proteins: [ProteinGroup: Double] = [:]
    public private(set) var ingredients: [String: Double] = [:]
    public private(set) var vibes: [Vibe: Double] = [:]
    public private(set) var effortBands: [RecipeEffortBand: Double] = [:]
    public private(set) var budgetBands: [RecipeBudgetBand: Double] = [:]
    public private(set) var knownRecipeIds: Set<String> = []
    public private(set) var positiveRecipeIds: Set<String> = []

    public init(events: [TasteEvent], recipes: [Recipe], planner: MealPlanner, pricing: PriceContext, asOf: Date) {
        let analyzed = planner.analysisCache.analyze(recipes, catalog: planner.catalog, pricing: pricing).0
        self.init(events: events, recipes: recipes, analyzed: analyzed, asOf: asOf)
    }

    init(events: [TasteEvent], recipes: [Recipe], analyzed: [(RecipeAnalysis, RecipeTraits)], asOf: Date) {
        guard !events.isEmpty else { return }
        let week: TimeInterval = 7 * 24 * 3600
        let ordered = Set(events).filter { $0.date <= asOf }.sorted { lhs, rhs in
            if lhs.date != rhs.date { return lhs.date > rhs.date }
            if lhs.recipeId != rhs.recipeId { return lhs.recipeId < rhs.recipeId }
            if lhs.kind != rhs.kind { return lhs.kind.rawValue < rhs.kind.rawValue }
            return (lhs.stars ?? 0) > (rhs.stars ?? 0)
        }
        var ratingIds: Set<String> = []
        var starIds: Set<String> = []
        var saveIds: Set<String> = []
        var impressions: [String: Double] = [:]
        for event in ordered {
            knownRecipeIds.insert(event.recipeId)
            let age = asOf.timeIntervalSince(event.date) / week
            guard age <= 26 else { continue }
            if event.kind.isRating && !ratingIds.insert(event.recipeId).inserted { continue }
            if event.kind == .stars && !starIds.insert(event.recipeId).inserted { continue }
            if (event.kind == .saved || event.kind == .unsaved) && !saveIds.insert(event.recipeId).inserted { continue }
            impressions[event.recipeId, default: 0] += event.weight * pow(0.5, age / 4)
        }
        positiveRecipeIds = Set(impressions.keys.filter { impressions[$0, default: 0] > 0.45 })
        var seen: Set<String> = []
        for (recipe, analysis) in zip(recipes, analyzed) where seen.insert(recipe.id).inserted {
            let evidence = min(4, max(-4, impressions[recipe.id, default: 0]))
            guard evidence != 0 else { continue }
            let (details, traits) = analysis
            cuisines[recipe.cuisine, default: 0] += evidence
            proteins[details.profile.mainProtein, default: 0] += evidence
            let ingredientEvidence = evidence / sqrt(Double(max(1, details.profile.keyIngredientIds.count)))
            for id in details.profile.keyIngredientIds { ingredients[id, default: 0] += ingredientEvidence }
            for vibe in Set(recipe.vibes) { vibes[vibe, default: 0] += evidence / sqrt(Double(max(1, recipe.vibes.count))) }
            effortBands[traits.effortBand, default: 0] += evidence
            budgetBands[traits.budgetBand, default: 0] += evidence
        }
        cuisines = cuisines.mapValues(affinity)
        proteins = proteins.mapValues(affinity)
        ingredients = ingredients.mapValues(affinity)
        vibes = vibes.mapValues(affinity)
        effortBands = effortBands.mapValues(affinity)
        budgetBands = budgetBands.mapValues(affinity)
    }

    public func score(recipe: Recipe, profile: RecipeProfile, traits: RecipeTraits) -> Double {
        let ingredient = mean(profile.keyIngredientIds.sorted().map { ingredients[$0, default: 0] })
        let vibe = mean(Set(recipe.vibes).sorted { $0.rawValue < $1.rawValue }.map { vibes[$0, default: 0] })
        return 2.4 * cuisines[recipe.cuisine, default: 0]
            + 0.75 * proteins[profile.mainProtein, default: 0]
            + 0.55 * ingredient + 0.45 * vibe
            + 0.25 * effortBands[traits.effortBand, default: 0] + 0.25 * budgetBands[traits.budgetBand, default: 0]
    }
}

private func affinity(_ evidence: Double) -> Double { evidence / (abs(evidence) + 4) }
private func mean(_ values: [Double]) -> Double { values.reduce(0, +) / Double(max(1, values.count)) }
