import Foundation

public enum UnitSystem: String, Codable, CaseIterable, Hashable, Sendable {
    case imperial
    case metric
}

public enum RegionPriceKey: String, Codable, CaseIterable, Hashable, Sendable {
    case US
    case UK
    case EU
}

public enum StoreTier: String, Codable, CaseIterable, Hashable, Sendable {
    case budget
    case standard
    case premium

    /// Price multiplier relative to the `standard` price table.
    public var multiplier: Double {
        switch self {
        case .budget: return 0.85
        case .standard: return 1.0
        case .premium: return 1.25
        }
    }
}

/// Supermarket aisles, declared in a sensible walking order (Produce first, Frozen last).
public enum Aisle: String, Codable, CaseIterable, Hashable, Sendable, Comparable {
    case produce = "Produce"
    case bakery = "Bakery"
    case meatFish = "Meat & Fish"
    case dairyEggs = "Dairy & Eggs"
    case pasta = "Pasta"
    case riceGrains = "Rice & Grains"
    case tinsJars = "Tins & Jars"
    case saucesCondiments = "Sauces & Condiments"
    case spicesHerbs = "Spices & Herbs"
    case oilsVinegars = "Oils & Vinegars"
    case baking = "Baking"
    case other = "Other"
    case frozen = "Frozen"

    public var walkingOrder: Int {
        Aisle.allCases.firstIndex(of: self) ?? 0
    }

    public static func < (lhs: Aisle, rhs: Aisle) -> Bool {
        lhs.walkingOrder < rhs.walkingOrder
    }

    public var displayName: String { rawValue }

    public var emoji: String {
        switch self {
        case .produce: return "🥬"
        case .bakery: return "🥖"
        case .meatFish: return "🥩"
        case .dairyEggs: return "🧀"
        case .pasta: return "🍝"
        case .riceGrains: return "🍚"
        case .tinsJars: return "🥫"
        case .saucesCondiments: return "🍶"
        case .spicesHerbs: return "🌿"
        case .oilsVinegars: return "🫒"
        case .baking: return "🧁"
        case .other: return "🛒"
        case .frozen: return "🧊"
        }
    }
}

public enum Allergen: String, Codable, CaseIterable, Hashable, Sendable {
    case gluten
    case dairy
    case egg
    case peanut
    case treeNut
    case soy
    case fish
    case shellfish
    case sesame

    public var displayName: String {
        switch self {
        case .gluten: return "Gluten"
        case .dairy: return "Dairy"
        case .egg: return "Eggs"
        case .peanut: return "Peanuts"
        case .treeNut: return "Tree nuts"
        case .soy: return "Soy"
        case .fish: return "Fish"
        case .shellfish: return "Shellfish"
        case .sesame: return "Sesame"
        }
    }

    public var emoji: String {
        switch self {
        case .gluten: return "🌾"
        case .dairy: return "🥛"
        case .egg: return "🥚"
        case .peanut: return "🥜"
        case .treeNut: return "🌰"
        case .soy: return "🫘"
        case .fish: return "🐟"
        case .shellfish: return "🦐"
        case .sesame: return "⚪️"
        }
    }
}

public enum Appliance: String, Codable, CaseIterable, Hashable, Sendable {
    case oven
    case stovetop
    case microwave
    case airFryer
    case slowCooker
    case blender

    public var displayName: String {
        switch self {
        case .oven: return "Oven"
        case .stovetop: return "Stovetop"
        case .microwave: return "Microwave"
        case .airFryer: return "Air fryer"
        case .slowCooker: return "Slow cooker"
        case .blender: return "Blender"
        }
    }

    /// SF Symbol name (all available on iOS 17).
    public var systemImage: String {
        switch self {
        case .oven: return "oven"
        case .stovetop: return "flame"
        case .microwave: return "microwave"
        case .airFryer: return "fan"
        case .slowCooker: return "timer"
        case .blender: return "tornado"
        }
    }
}

public enum Vibe: String, Codable, CaseIterable, Hashable, Sendable {
    case quickEasy
    case highProtein
    case comfort
    case healthyish
    case family
    case fakeaway
    case lowCalorie
    case onePan
    case batchFriendly

    public var displayName: String {
        switch self {
        case .quickEasy: return "Quick & easy"
        case .highProtein: return "High protein"
        case .comfort: return "Comfort food"
        case .healthyish: return "Healthy-ish"
        case .family: return "Family favourites"
        case .fakeaway: return "Fakeaway"
        case .lowCalorie: return "Low calorie"
        case .onePan: return "One-pan"
        case .batchFriendly: return "Batch-friendly"
        }
    }

    public var systemImage: String {
        switch self {
        case .quickEasy: return "bolt.fill"
        case .highProtein: return "dumbbell.fill"
        case .comfort: return "heart.fill"
        case .healthyish: return "leaf.fill"
        case .family: return "person.3.fill"
        case .fakeaway: return "takeoutbag.and.cup.and.straw.fill"
        case .lowCalorie: return "flame"
        case .onePan: return "frying.pan.fill"
        case .batchFriendly: return "square.stack.3d.up.fill"
        }
    }

    /// Hex colour for the vibe tile icon.
    public var tintHex: String {
        switch self {
        case .quickEasy: return "#F2B544"
        case .highProtein: return "#C9402B"
        case .comfort: return "#E8553D"
        case .healthyish: return "#8A8F4A"
        case .family: return "#7A5C7E"
        case .fakeaway: return "#D9733B"
        case .lowCalorie: return "#B5754C"
        case .onePan: return "#A8435E"
        case .batchFriendly: return "#6E5F6B"
        }
    }
}

/// The user's dietary choice.
public enum Diet: String, Codable, CaseIterable, Hashable, Sendable {
    case none
    case vegetarian
    case vegan
    case pescatarian

    public var displayName: String {
        switch self {
        case .none: return "No restrictions"
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .pescatarian: return "Pescatarian"
        }
    }

    /// Minimum recipe diet level this user can eat.
    public var requiredLevel: RecipeDiet {
        switch self {
        case .none: return .omnivore
        case .pescatarian: return .pescatarian
        case .vegetarian: return .vegetarian
        case .vegan: return .vegan
        }
    }
}

/// A recipe's computed diet level. Higher = more restrictive diets can eat it.
public enum RecipeDiet: Int, Codable, CaseIterable, Hashable, Sendable, Comparable {
    case omnivore = 0
    case pescatarian = 1
    case vegetarian = 2
    case vegan = 3

    public static func < (lhs: RecipeDiet, rhs: RecipeDiet) -> Bool { lhs.rawValue < rhs.rawValue }

    public var displayName: String {
        switch self {
        case .omnivore: return "Contains meat"
        case .pescatarian: return "Pescatarian"
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        }
    }

    public func isCompatible(with diet: Diet) -> Bool {
        self >= diet.requiredLevel
    }
}

public enum Cuisine: String, Codable, CaseIterable, Hashable, Sendable {
    case italian = "Italian"
    case mexican = "Mexican"
    case indian = "Indian"
    case chinese = "Chinese"
    case japanese = "Japanese"
    case thai = "Thai"
    case mediterranean = "Mediterranean"
    case middleEastern = "Middle Eastern"
    case american = "American"
    case british = "British"
    case spanishPortuguese = "Spanish/Portuguese"
    case korean = "Korean"
    case other = "Other"

    public var displayName: String { rawValue }

    public var emoji: String {
        switch self {
        case .italian: return "🍝"
        case .mexican: return "🌮"
        case .indian: return "🍛"
        case .chinese: return "🥡"
        case .japanese: return "🍱"
        case .thai: return "🍜"
        case .mediterranean: return "🫒"
        case .middleEastern: return "🧆"
        case .american: return "🍔"
        case .british: return "🥧"
        case .spanishPortuguese: return "🥘"
        case .korean: return "🍚"
        case .other: return "🍽️"
        }
    }
}

/// Units a recipe ingredient may be written in.
public enum MeasureUnit: String, Codable, CaseIterable, Hashable, Sendable {
    case g
    case kg
    case ml
    case l
    case tsp
    case tbsp
    case cup
    case oz
    case lb
    case piece
    case clove
    case pinch
    case slice
    case bunch
    case toTaste = "to taste"

    public var isMass: Bool { self == .g || self == .kg || self == .oz || self == .lb }
    public var isVolume: Bool { self == .ml || self == .l || self == .tsp || self == .tbsp || self == .cup }
    public var isCount: Bool { self == .piece || self == .clove || self == .slice || self == .bunch }

    /// Label after a number, e.g. "2 cloves", "1 tbsp".
    public func label(for amount: Double) -> String {
        let plural: Bool = amount > 1.0001
        switch self {
        case .g, .kg, .ml, .l, .tsp, .tbsp, .oz: return rawValue
        case .lb: return plural ? "lb" : "lb"
        case .cup: return plural ? "cups" : "cup"
        case .piece: return ""
        case .clove: return plural ? "cloves" : "clove"
        case .pinch: return plural ? "pinches" : "pinch"
        case .slice: return plural ? "slices" : "slice"
        case .bunch: return plural ? "bunches" : "bunch"
        case .toTaste: return "to taste"
        }
    }

    /// Lenient parsing from free text ("tablespoons", "Tbsp", "grams"...).
    public static func parse(_ token: String) -> MeasureUnit? {
        let t: String = token.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: ". "))
        switch t {
        case "g", "gr", "gram", "grams", "gramme", "grammes": return .g
        case "kg", "kgs", "kilo", "kilos", "kilogram", "kilograms": return .kg
        case "ml", "mls", "millilitre", "millilitres", "milliliter", "milliliters": return .ml
        case "l", "litre", "litres", "liter", "liters": return .l
        case "tsp", "tsps", "teaspoon", "teaspoons", "t": return .tsp
        case "tbsp", "tbsps", "tbs", "tbl", "tablespoon", "tablespoons", "tbspn": return .tbsp
        case "cup", "cups", "c": return .cup
        case "oz", "ounce", "ounces": return .oz
        case "lb", "lbs", "pound", "pounds": return .lb
        case "clove", "cloves": return .clove
        case "pinch", "pinches": return .pinch
        case "slice", "slices": return .slice
        case "bunch", "bunches", "handful", "handfuls": return .bunch
        case "piece", "pieces", "pc", "pcs", "can", "cans", "tin", "tins", "x": return .piece
        default: return nil
        }
    }
}

/// The unit an ingredient is aggregated and packed in.
public enum BaseUnit: String, Codable, Hashable, Sendable {
    case g
    case ml
    case piece
}

public enum ProteinGroup: String, Codable, CaseIterable, Hashable, Sendable {
    case chicken
    case beef
    case pork
    case turkey
    case lamb
    case fish
    case shellfish
    case egg
    case tofu
    case legume
    case cheese
    case veg
}

public enum RecipeSourceKind: String, Codable, CaseIterable, Hashable, Sendable {
    case bundled
    case manual
    case tiktok
    case instagram
    case pasted
}

public enum FeedbackRating: String, Codable, Hashable, Sendable {
    case like
    case notForMe
}

/// Which meal of the day a recipe or plan slot is for. Raw values are stored in JSON and SwiftData.
public enum MealType: String, Codable, CaseIterable, Hashable, Sendable, Comparable {
    case breakfast
    case lunch
    case dinner
    case snack

    /// Order within a day.
    public var order: Int {
        switch self {
        case .breakfast: return 0
        case .lunch: return 1
        case .dinner: return 2
        case .snack: return 3
        }
    }

    public static func < (lhs: MealType, rhs: MealType) -> Bool { lhs.order < rhs.order }

    /// Share of a dinner's cost, used for budget suggestions and verdicts.
    public var budgetWeight: Double {
        switch self {
        case .breakfast: return 0.35
        case .lunch: return 0.6
        case .dinner: return 1
        case .snack: return 0.2
        }
    }

    /// How many times one recipe may appear in a week for this meal (people repeat breakfasts and snacks).
    public var maxUsesPerWeek: Int {
        switch self {
        case .breakfast, .snack: return 2
        case .lunch, .dinner: return 1
        }
    }

    /// Protein/cuisine variety rules only make sense for proper meals.
    public var usesVarietyRules: Bool { self == .lunch || self == .dinner }

    /// Calories per serving a bundled recipe of this type should land in (library validation).
    public var kcalRange: ClosedRange<Double> {
        switch self {
        case .breakfast: return 200...700
        case .lunch: return 250...850
        case .dinner: return 250...950
        case .snack: return 80...400
        }
    }

    /// Step count a bundled recipe of this type should have (library validation).
    public var stepRange: ClosedRange<Int> {
        switch self {
        case .breakfast, .lunch: return 4...10
        case .dinner: return 6...10
        case .snack: return 2...6
        }
    }

    /// Sorted, with dinner as the fallback for an empty set.
    public static func ordered(_ types: Set<MealType>) -> [MealType] {
        let sorted: [MealType] = types.sorted()
        return sorted.isEmpty ? [.dinner] : sorted
    }
}
