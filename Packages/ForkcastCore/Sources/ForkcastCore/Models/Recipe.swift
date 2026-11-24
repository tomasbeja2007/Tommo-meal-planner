import Foundation

public struct RecipeIngredient: Codable, Hashable, Sendable {
    /// Links to `ingredients.json`. Nil for unlinked user-entered ingredients.
    public var ingredientId: String?
    /// Free-text name (used when unlinked, or as an override for display).
    public var name: String?
    public var amount: Double
    public var unit: MeasureUnit
    public var note: String?

    public init(ingredientId: String?, name: String? = nil, amount: Double, unit: MeasureUnit, note: String? = nil) {
        self.ingredientId = ingredientId
        self.name = name
        self.amount = amount
        self.unit = unit
        self.note = note
    }

    public var isLinked: Bool { ingredientId != nil }
}

/// A recipe from either the bundled library or the user's own recipes.
/// This is Forkcast's single "recipe-like" type: plan, detail, swap and cook mode
/// all work on it regardless of source.
public struct Recipe: Codable, Identifiable, Hashable, Sendable {
    public var id: String
    public var title: String
    public var emoji: String
    public var cuisine: Cuisine
    public var vibes: [Vibe]
    public var appliances: [Appliance]
    public var prepMinutes: Int
    public var cookMinutes: Int
    public var baseServings: Int
    public var ingredients: [RecipeIngredient]
    public var steps: [String]
    public var imageName: String?
    public var isLeftoverFriendly: Bool
    /// Breakfast, lunch, dinner or snack. Older JSON without the key means dinner.
    public var mealType: MealType

    // User-recipe extras (absent from bundled JSON).
    public var source: RecipeSourceKind
    public var macroOverride: Macros?
    /// Free tags chosen by the user (vibes are stored in `vibes`).
    public var tags: [String]
    public var notes: String?
    public var sourceURL: String?

    public init(
        id: String,
        title: String,
        emoji: String,
        cuisine: Cuisine = .other,
        vibes: [Vibe] = [],
        appliances: [Appliance] = [],
        prepMinutes: Int = 0,
        cookMinutes: Int = 0,
        baseServings: Int = 2,
        ingredients: [RecipeIngredient] = [],
        steps: [String] = [],
        imageName: String? = nil,
        isLeftoverFriendly: Bool = false,
        mealType: MealType = .dinner,
        source: RecipeSourceKind = .bundled,
        macroOverride: Macros? = nil,
        tags: [String] = [],
        notes: String? = nil,
        sourceURL: String? = nil
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.cuisine = cuisine
        self.vibes = vibes
        self.appliances = appliances
        self.prepMinutes = prepMinutes
        self.cookMinutes = cookMinutes
        self.baseServings = baseServings
        self.ingredients = ingredients
        self.steps = steps
        self.imageName = imageName
        self.isLeftoverFriendly = isLeftoverFriendly
        self.mealType = mealType
        self.source = source
        self.macroOverride = macroOverride
        self.tags = tags
        self.notes = notes
        self.sourceURL = sourceURL
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, emoji, cuisine, vibes, appliances, prepMinutes, cookMinutes, baseServings, ingredients, steps, imageName, isLeftoverFriendly
        case mealType
        case source, macroOverride, tags, notes, sourceURL
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        emoji = try c.decodeIfPresent(String.self, forKey: .emoji) ?? "🍽️"
        cuisine = try c.decodeIfPresent(Cuisine.self, forKey: .cuisine) ?? .other
        vibes = try c.decodeIfPresent([Vibe].self, forKey: .vibes) ?? []
        appliances = try c.decodeIfPresent([Appliance].self, forKey: .appliances) ?? []
        prepMinutes = try c.decodeIfPresent(Int.self, forKey: .prepMinutes) ?? 0
        cookMinutes = try c.decodeIfPresent(Int.self, forKey: .cookMinutes) ?? 0
        baseServings = try c.decodeIfPresent(Int.self, forKey: .baseServings) ?? 2
        ingredients = try c.decodeIfPresent([RecipeIngredient].self, forKey: .ingredients) ?? []
        steps = try c.decodeIfPresent([String].self, forKey: .steps) ?? []
        imageName = try c.decodeIfPresent(String.self, forKey: .imageName)
        isLeftoverFriendly = try c.decodeIfPresent(Bool.self, forKey: .isLeftoverFriendly) ?? false
        mealType = try c.decodeIfPresent(MealType.self, forKey: .mealType) ?? .dinner
        source = try c.decodeIfPresent(RecipeSourceKind.self, forKey: .source) ?? .bundled
        macroOverride = try c.decodeIfPresent(Macros.self, forKey: .macroOverride)
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
        notes = try c.decodeIfPresent(String.self, forKey: .notes)
        sourceURL = try c.decodeIfPresent(String.self, forKey: .sourceURL)
    }

    public var totalMinutes: Int { prepMinutes + cookMinutes }

    /// Hands-on time. Slow-cooker recipes mostly look after themselves, so the
    /// planner's time limit applies to the prep only.
    public var handsOnMinutes: Int {
        appliances.contains(.slowCooker) ? prepMinutes + 10 : totalMinutes
    }

    public var isUserRecipe: Bool { source != .bundled }

    /// Prefix used for user recipe ids so they never collide with bundled slugs.
    public static let userIdPrefix: String = "user:"
}
