import Foundation

public enum RecipeBudgetBand: String, Hashable, Sendable {
    case cheap, typical, treat
}

public enum RecipeEffortBand: String, Hashable, Sendable {
    case easy, moderate, involved
}

public struct RecipeTraits: Hashable, Sendable {
    public let effort: Double
    public let everyday: Double
    public let kidFriendly: Double
    public let costPerServing: Double
    public let budgetBand: RecipeBudgetBand
    public let perishability: Double
    public let healthiness: Double
    public let proteinPerServing: Double
    public let leftoverValue: Double
    public let batchFriendly: Bool
    public let onePan: Bool

    public var effortBand: RecipeEffortBand {
        if effort < 0.35 { return .easy }
        return effort < 0.65 ? .moderate : .involved
    }
}

struct IngredientUse: Sendable {
    let id: String
    let packsPerServing: Double
    let staple: Bool
    /// Relative urgency based on typical storage life of the fresh ingredient.
    let urgency: Double
}

struct RecipeAnalysis: Sendable {
    let profile: RecipeProfile
    let ingredients: [IngredientUse]
    let effort: Double
    let familiarity: Double
    let kidFriendly: Double
    let healthiness: Double
    let protein: Double
    let leftoverValue: Double
    let batchFriendly: Bool
    let onePan: Bool

    init(recipe: Recipe, catalog: FoodCatalog) {
        let profile = RecipeClassifier.profile(for: recipe, catalog: catalog)
        self.profile = profile
        var amounts: [String: Double] = [:]
        for item in recipe.ingredients {
            guard let id = item.ingredientId, let ingredient = catalog.ingredient(id: id) else { continue }
            let base = UnitConverter.baseAmount(amount: item.amount, unit: item.unit, ingredient: ingredient) ?? 0
            amounts[id, default: 0] += max(0, base)
        }
        ingredients = amounts.keys.sorted().compactMap { id in
            guard let ingredient = catalog.ingredient(id: id) else { return nil }
            let packs = (amounts[id] ?? 0) / max(0.0001, ingredient.pack.amount) / Double(max(1, recipe.baseServings))
            let urgency: Double
            switch ingredient.aisle {
            case .produce:
                let hardy = ["potato", "onion", "carrot", "cabbage", "garlic", "squash"]
                urgency = hardy.contains(where: id.contains) ? 0.25 : 0.75
            case .meatFish: urgency = ingredient.dietFlags.isFish ? 1 : 0.7
            case .dairyEggs: urgency = 0.4
            default: urgency = 0
            }
            return IngredientUse(id: id, packsPerServing: packs, staple: ingredient.isPantryStaple,
                                 urgency: ingredient.isPantryStaple ? 0 : urgency)
        }

        let instructions = recipe.steps.joined(separator: " ").lowercased()
        let techniques = ["knead", "caramel stage", "caramelise sugar", "marinate overnight", "deep-fry", "deep fry", "temper chocolate", "proof the dough"]
        let techniqueCount = techniques.filter(instructions.contains).count
        let nonStaples = recipe.ingredients.count - ingredients.filter(\.staple).count
        effort = 0.20 * unit(Double(recipe.totalMinutes) / 90)
            + 0.29 * unit(Double(recipe.handsOnMinutes) / 55)
            + 0.21 * unit(Double(nonStaples) / 15)
            + 0.13 * unit(Double(recipe.steps.count) / 12)
            + 0.07 * unit(Double(Set(recipe.appliances).count) / 3)
            + 0.10 * unit(Double(techniqueCount) / 2)

        let title = recipe.title.lowercased()
        let formats = ["pasta", "spaghetti", "macaroni", "taco", "wrap", "rice bowl", "nugget", "traybake", "tray bake", "sandwich", "pizza", "quesadilla"]
        familiarity = formats.contains(where: title.contains) ? 1 : (recipe.vibes.contains(.family) ? 0.8 : 0.45)
        let strong = ["anchovies", "blue-cheese", "olives", "kimchi", "capers", "horseradish"]
        let strongCount = strong.filter { profile.ingredientIds.contains($0) }.count
        kidFriendly = profile.isSpicy ? 0 : unit(0.49 + 0.34 * familiarity
            + (recipe.vibes.contains(.family) ? 0.14 : 0) - 0.13 * Double(strongCount))

        let macros = NutritionCalculator.perServing(recipe, catalog: catalog).macros
        protein = macros.protein
        let energyFit = macros.kcal > 0 ? unit(1 - abs(macros.kcal - 550 * recipe.mealType.budgetWeight) / 650) : 0
        healthiness = unit(0.42 * unit(macros.protein / max(macros.kcal, 100) * 15)
            + 0.31 * unit(macros.fiber / (8 * recipe.mealType.budgetWeight))
            + 0.21 * energyFit + (recipe.vibes.contains(.healthyish) ? 0.06 : 0))
        onePan = recipe.vibes.contains(.onePan)
        batchFriendly = recipe.isLeftoverFriendly || recipe.vibes.contains(.batchFriendly)
        leftoverValue = recipe.isLeftoverFriendly ? (recipe.vibes.contains(.batchFriendly) ? 1 : 0.8) : (batchFriendly ? 0.5 : 0)
    }

    func traits(recipe: Recipe, pricing: PriceContext, prices: [String: Double]) -> RecipeTraits {
        var cost = 0.0
        var fresh = 0.0
        for item in ingredients {
            let price = prices[item.id] ?? 0
            let consumed = item.staple ? GroceryAggregator.pantryCost(packPrice: price) / Double(max(1, recipe.baseServings))
                : item.packsPerServing * price
            cost += consumed
            fresh += consumed * item.urgency
        }
        let typical = BudgetMath.plannedCostPerPortion(region: pricing.region) * pricing.countryMultiplier * recipe.mealType.budgetWeight
        let relative = cost / max(0.01, typical)
        let band: RecipeBudgetBand = relative < 0.65 ? .cheap : (relative <= 1.10 ? .typical : .treat)
        return RecipeTraits(effort: effort, everyday: unit(0.68 * (1 - effort) + 0.17 * familiarity + 0.15 * unit(1 - relative / 1.4)),
                            kidFriendly: kidFriendly, costPerServing: cost, budgetBand: band,
                            perishability: cost > 0 ? unit(fresh / cost) : 0, healthiness: healthiness,
                            proteinPerServing: protein, leftoverValue: leftoverValue, batchFriendly: batchFriendly, onePan: onePan)
    }
}

func unit(_ value: Double) -> Double {
    min(1, max(0, value))
}

/// Shared by copies of a planner, including background tasks. Recipe value equality
/// invalidates entries when an editable recipe changes without changing its ID.
final class RecipeAnalysisCache: @unchecked Sendable {
    private struct Entry {
        let recipe: Recipe
        let analysis: RecipeAnalysis
        var traits: [PriceContext: RecipeTraits] = [:]
    }

    private let lock = NSLock()
    private var entries: [String: Entry] = [:]
    private var prices: [PriceContext: [String: Double]] = [:]

    func analyze(_ recipes: [Recipe], catalog: FoodCatalog, pricing: PriceContext) -> ([(RecipeAnalysis, RecipeTraits)], [String: Double]) {
        lock.lock()
        defer { lock.unlock() }
        let packPrices = prices[pricing] ?? Dictionary(uniqueKeysWithValues: catalog.ingredients.map {
            ($0.id, catalog.packPrice(ingredientId: $0.id, context: pricing) ?? 0)
        })
        prices[pricing] = packPrices
        let analyzed = recipes.map { recipe -> (RecipeAnalysis, RecipeTraits) in
            var entry: Entry
            if let cached = entries[recipe.id], cached.recipe == recipe {
                entry = cached
            } else {
                entry = Entry(recipe: recipe, analysis: RecipeAnalysis(recipe: recipe, catalog: catalog))
            }
            let traits = entry.traits[pricing] ?? entry.analysis.traits(recipe: recipe, pricing: pricing, prices: packPrices)
            entry.traits[pricing] = traits
            entries[recipe.id] = entry
            return (entry.analysis, traits)
        }
        return (analyzed, packPrices)
    }
}
