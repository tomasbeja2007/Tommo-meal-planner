import Foundation
import ForkcastCore

/// Every onboarding answer that has no column of its own on `UserProfile`.
/// Saved as JSON in `UserProfile.onboardingAnswersJSON` (a defaulted String, so CloudKit stays happy).
/// The core answers (household, days, budget, diet, allergies, dislikes, vibes, appliances, shops)
/// still live on `UserProfile`; `ProfileStore.plannerProfile` combines both for the planner.
struct OnboardingAnswers: Codable, Hashable {
    /// Bump when a field changes meaning.
    var version: Int = 1
    /// `OnboardingObstacle` raw values.
    var obstacles: [String] = []
    var mealPrepMode: Bool = false
    var mealPrepEdges: [Int]? = nil
    /// `ExtraDiet` raw values.
    var extraDiets: [String] = []
    /// Ingredient ids the user already has at home.
    var pantry: [String] = []
    /// Start of the week the pantry answer applies to (the first plan only).
    var pantryWeekStart: Date? = nil
    /// Free text from "Request your store".
    var requestedStore: String? = nil
    var completedAt: Date? = nil
    var generatedPlanCreatedAt: Date? = nil

    static func decode(_ json: String) -> OnboardingAnswers {
        guard !json.isEmpty, let data = json.data(using: .utf8),
              let answers = try? JSONDecoder().decode(OnboardingAnswers.self, from: data) else {
            return OnboardingAnswers()
        }
        return answers
    }

    var json: String {
        guard let data = try? JSONEncoder().encode(self) else { return "" }
        return String(decoding: data, as: UTF8.self)
    }

    /// Vibes implied by the extra diets ("High-protein" leans on the high-protein vibe).
    var impliedVibes: Set<Vibe> {
        Set(extraDiets.compactMap { ExtraDiet(rawValue: $0)?.vibe })
    }

    var preferredCuisines: Set<Cuisine> {
        Set(extraDiets.compactMap { ExtraDiet(rawValue: $0)?.cuisine })
    }
}

/// "What gets in the way?"
enum OnboardingObstacle: String, CaseIterable, Identifiable {
    case overspend
    case dontKnowWhat
    case planningTakesLong
    case tooTired
    case foodGoesOff
    case noList
    case messyRecipes
    case sameMeals

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overspend: return String(localized: "I overspend at the shop")
        case .dontKnowWhat: return String(localized: "I don't know what to cook")
        case .planningTakesLong: return String(localized: "Planning takes too long")
        case .tooTired: return String(localized: "Too tired to cook")
        case .foodGoesOff: return String(localized: "Food goes off")
        case .noList: return String(localized: "I shop without a list")
        case .messyRecipes: return String(localized: "Saved recipes are a mess")
        case .sameMeals: return String(localized: "Same meals every week")
        }
    }

    var emoji: String {
        switch self {
        case .overspend: return "💸"
        case .dontKnowWhat: return "🤷"
        case .planningTakesLong: return "⏳"
        case .tooTired: return "😴"
        case .foodGoesOff: return "🥬"
        case .noList: return "🛒"
        case .messyRecipes: return "📚"
        case .sameMeals: return "🔁"
        }
    }

    /// Short phrase for the mirror screen: "…but **food goes off**".
    var mirrorPhrase: String {
        switch self {
        case .overspend: return String(localized: "the shop eats your budget")
        case .dontKnowWhat: return String(localized: "you're never sure what to cook")
        case .planningTakesLong: return String(localized: "planning takes forever")
        case .tooTired: return String(localized: "you're too tired to cook")
        case .foodGoesOff: return String(localized: "food goes off")
        case .noList: return String(localized: "you shop without a list")
        case .messyRecipes: return String(localized: "your saved recipes are a mess")
        case .sameMeals: return String(localized: "it's the same meals every week")
        }
    }
}

/// Display names for the core `MealType` (breakfast, lunch, dinner, snack).
extension MealType: Identifiable {
    public var id: String { rawValue }

    var title: String {
        switch self {
        case .breakfast: return String(localized: "Breakfast")
        case .lunch: return String(localized: "Lunch")
        case .dinner: return String(localized: "Dinner")
        case .snack: return String(localized: "Snacks")
        }
    }

    /// Singular, lower-case, for sentences: "add a lunch", "swap this snack".
    var noun: String {
        switch self {
        case .breakfast: return String(localized: "breakfast")
        case .lunch: return String(localized: "lunch")
        case .dinner: return String(localized: "dinner")
        case .snack: return String(localized: "snack")
        }
    }

    var emoji: String {
        switch self {
        case .breakfast: return "🥣"
        case .lunch: return "🥪"
        case .dinner: return "🍝"
        case .snack: return "🍎"
        }
    }
}

/// Extra eating styles the planner can honour (no Keto: no recipes fit; no GLP-1: a health claim).
enum ExtraDiet: String, CaseIterable, Identifiable {
    case highProtein
    case lowCalorie
    case mediterranean

    var id: String { rawValue }

    var title: String {
        switch self {
        case .highProtein: return String(localized: "High-protein")
        case .lowCalorie: return String(localized: "Lighter meals")
        case .mediterranean: return String(localized: "Mediterranean")
        }
    }

    var vibe: Vibe? {
        switch self {
        case .highProtein: return .highProtein
        case .lowCalorie: return .lowCalorie
        case .mediterranean: return nil
        }
    }

    var cuisine: Cuisine? { self == .mediterranean ? .mediterranean : nil }
}
