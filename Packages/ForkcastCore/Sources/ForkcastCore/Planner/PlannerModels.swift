import Foundation

/// The user's rules, as the planner sees them.
public struct PlannerProfile: Hashable, Sendable {
    public var allergens: Set<Allergen>
    public var diet: Diet
    /// Ingredient ids, or group ids like "group:spicy" (see `DislikeCatalog`).
    public var dislikes: Set<String>
    public var appliances: Set<Appliance>
    /// nil = "I don't mind".
    public var maxCookMinutes: Int?
    public var vibes: Set<Vibe>
    public var includeUserRecipes: Bool
    /// Ingredient ids the user already has at home: left off the shopping list and the total.
    public var onHand: Set<String>
    /// "Meal prep mode": lean towards dinners that keep well as leftovers.
    public var prefersMealPrep: Bool
    /// Cuisines the user leans towards (e.g. "Mediterranean" from the diet screen). A soft preference.
    public var preferredCuisines: Set<Cuisine>

    public init(allergens: Set<Allergen> = [], diet: Diet = .none, dislikes: Set<String> = [], appliances: Set<Appliance> = Set(Appliance.allCases), maxCookMinutes: Int? = nil, vibes: Set<Vibe> = [], includeUserRecipes: Bool = true, onHand: Set<String> = [], prefersMealPrep: Bool = false, preferredCuisines: Set<Cuisine> = []) {
        self.preferredCuisines = preferredCuisines
        self.onHand = onHand
        self.prefersMealPrep = prefersMealPrep
        self.allergens = allergens
        self.diet = diet
        self.dislikes = dislikes
        self.appliances = appliances
        self.maxCookMinutes = maxCookMinutes
        self.vibes = vibes
        self.includeUserRecipes = includeUserRecipes
    }
}

public struct FeedbackSummary: Hashable, Sendable {
    public var liked: Set<String>
    public var notForMe: Set<String>
    /// recipeId -> 1...5
    public var stars: [String: Int]

    public init(liked: Set<String> = [], notForMe: Set<String> = [], stars: [String: Int] = [:]) {
        self.liked = liked
        self.notForMe = notForMe
        self.stars = stars
    }
}

public struct PlanSlot: Hashable, Sendable {
    public let index: Int
    public let date: Date
    /// ISO weekday 1...7
    public let weekday: Int
    /// Only recipes of this meal type fill the slot.
    public let mealType: MealType

    public init(index: Int, date: Date, weekday: Int, mealType: MealType = .dinner) {
        self.index = index
        self.date = date
        self.weekday = weekday
        self.mealType = mealType
    }
}

public struct LockedMeal: Hashable, Sendable {
    public let recipeId: String
    public let servings: Double

    public init(recipeId: String, servings: Double) {
        self.recipeId = recipeId
        self.servings = servings
    }
}

public struct PlannerRequest: Sendable {
    public var profile: PlannerProfile
    /// Candidate pool: bundled recipes plus any eligible user recipes.
    public var recipes: [Recipe]
    public var feedback: FeedbackSummary
    /// recipeId -> weeks since it was last planned (1 = last week).
    public var history: [String: Int]
    public var slots: [PlanSlot]
    /// Portions per meal (adults + 0.5 × kids), rounded up by the caller if desired.
    public var servings: Double
    public var budget: Double
    public var pricing: PriceContext
    public var unitSystem: UnitSystem
    public var seed: UInt64
    /// Slot index -> meal to keep (cooked or liked meals on regenerate).
    public var locked: [Int: LockedMeal]

    public init(profile: PlannerProfile, recipes: [Recipe], feedback: FeedbackSummary = FeedbackSummary(), history: [String: Int] = [:], slots: [PlanSlot], servings: Double, budget: Double, pricing: PriceContext, unitSystem: UnitSystem = .metric, seed: UInt64 = 1, locked: [Int: LockedMeal] = [:]) {
        self.profile = profile
        self.recipes = recipes
        self.feedback = feedback
        self.history = history
        self.slots = slots
        self.servings = servings
        self.budget = budget
        self.pricing = pricing
        self.unitSystem = unitSystem
        self.seed = seed
        self.locked = locked
    }
}

public struct PlannedMealDraft: Hashable, Sendable {
    public let slotIndex: Int
    public let date: Date
    public let weekday: Int
    public let mealType: MealType
    public let recipeId: String
    public let servings: Double
    /// This meal's share of the basket.
    public let allocatedCost: Double
}

public struct PlanResult: Sendable {
    public let meals: [PlannedMealDraft]
    public let estimatedTotal: Double
    public let budget: Double
    /// > 0 when even the cheapest valid plan is over budget.
    public let overBudgetBy: Double
    /// True when the time limit had to be relaxed to find enough recipes.
    public let relaxedTimeLimit: Bool
    public let groceryList: GroceryList
}

public struct SwapSuggestion: Hashable, Sendable {
    public let recipeId: String
    /// Change in the basket total if this swap is made (negative = cheaper).
    public let costDelta: Double
    public let score: Double
}

/// Common dislikes that map to more than one ingredient.
public enum DislikeCatalog {
    public struct Option: Hashable, Sendable, Identifiable {
        public let id: String
        public let label: String
        public let emoji: String
    }

    public static let spicy: String = "group:spicy"
    public static let pork: String = "group:pork"
    public static let beef: String = "group:beef"

    /// "Common picks" chips in onboarding.
    public static let commonPicks: [Option] = [
        Option(id: "mushrooms", label: "Mushrooms", emoji: "🍄"),
        Option(id: "olives", label: "Olives", emoji: "🫒"),
        Option(id: "cilantro", label: "Cilantro / coriander", emoji: "🌿"),
        Option(id: "eggplant", label: "Eggplant / aubergine", emoji: "🍆"),
        Option(id: "blue-cheese", label: "Blue cheese", emoji: "🧀"),
        Option(id: "tofu", label: "Tofu", emoji: "🧊"),
        Option(id: "shrimp", label: "Shrimp / prawns", emoji: "🍤"),
        Option(id: spicy, label: "Spicy food", emoji: "🌶️"),
        Option(id: pork, label: "Pork", emoji: "🐖"),
        Option(id: beef, label: "Beef", emoji: "🐄")
    ]

    public static func label(for id: String, catalog: FoodCatalog, system: UnitSystem) -> String {
        if let pick = commonPicks.first(where: { $0.id == id }) { return pick.label }
        if let ingredient = catalog.ingredient(id: id) { return ingredient.displayName(for: system).capitalizedFirst }
        return id
    }

    public static func isDisliked(_ profile: RecipeProfile, dislikes: Set<String>) -> Bool {
        if dislikes.isEmpty { return false }
        if !profile.ingredientIds.isDisjoint(with: dislikes) { return true }
        if dislikes.contains(spicy) && profile.isSpicy { return true }
        if dislikes.contains(pork) && profile.proteinGroups.contains(.pork) { return true }
        if dislikes.contains(beef) && profile.proteinGroups.contains(.beef) { return true }
        return false
    }
}

extension String {
    /// "olive oil" -> "Olive oil"
    public var capitalizedFirst: String {
        guard let first = first else { return self }
        return String(first).uppercased() + dropFirst()
    }
}
