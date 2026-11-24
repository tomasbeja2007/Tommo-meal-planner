import Foundation
import Observation
import ForkcastCore

/// Draft answers. Written to `UserProfile` only at the end of onboarding.
@MainActor
@Observable
final class OnboardingState {
    var name: String = ""
    var goals: Set<String> = []
    /// 0 = "I don't mind".
    var maxCookMinutes: Int = 30
    var countryId: String = "us"
    /// Shops in the order they were picked. The first one is the main shop and sets prices.
    var storeIds: [String] = []
    var adults: Int = 2
    var kids: Int = 0
    var cookingDays: Set<Int> = [1, 2, 3, 4, 5]
    var budget: Double = 35
    /// Once the user moves the slider we stop auto-suggesting a budget.
    var budgetTouched: Bool = false
    var vibes: Set<Vibe> = []
    var diet: Diet = .none
    var allergens: Set<Allergen> = []
    var noAllergies: Bool = false
    var dislikes: Set<String> = []
    var appliances: Set<Appliance> = [.oven, .stovetop, .microwave]
    var trialReminderDaysBefore: Int = 1

    init() {}

    /// Pre-fill from an existing profile ("Start over" keeps the old answers).
    init(profile: UserProfile) {
        name = profile.name
        goals = Set(profile.goals)
        maxCookMinutes = profile.maxCookMinutes
        countryId = profile.countryId
        storeIds = profile.storeIds
        adults = profile.householdAdults
        kids = profile.householdKids
        cookingDays = profile.cookingDays
        budget = profile.weeklyBudget
        budgetTouched = true
        vibes = Set(profile.vibes)
        diet = profile.diet
        allergens = profile.allergens
        noAllergies = profile.allergens.isEmpty
        dislikes = profile.dislikedIngredientIds
        appliances = profile.appliances
        trialReminderDaysBefore = profile.trialReminderDaysBefore
    }

    var portions: Double { BudgetMath.portions(adults: adults, kids: kids) }

    /// The main shop, or "" before anything is picked.
    var mainStoreId: String { storeIds.first ?? "" }

    /// Drops shops that don't exist in `countryId` (after the country changes).
    func keepOnlyStores(availableIn countryId: String, catalog: FoodCatalog) {
        let available: Set<String> = Set(catalog.stores(forCountry: countryId).map { $0.id })
        storeIds = storeIds.filter { available.contains($0) }
    }

    func country(in catalog: FoodCatalog) -> Country {
        catalog.country(id: countryId) ?? catalog.defaultCountry
    }

    /// Re-suggest a budget from the household and days (until the user picks one).
    func refreshSuggestedBudget(catalog: FoodCatalog) {
        guard !budgetTouched else { return }
        let country: Country = country(in: catalog)
        budget = BudgetMath.defaultBudget(region: country.regionPriceKey, portions: portions, days: cookingDays.count, multiplier: country.priceMultiplier)
    }

    func apply(to profile: UserProfile) {
        profile.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.goals = goals.sorted()
        profile.maxCookMinutes = maxCookMinutes
        profile.countryId = countryId
        profile.storeIds = storeIds.isEmpty ? [Store.localStoreId] : storeIds
        profile.householdAdults = max(1, adults)
        profile.householdKids = max(0, kids)
        profile.cookingDays = cookingDays.isEmpty ? [1, 2, 3, 4, 5] : cookingDays
        profile.weeklyBudget = budget
        profile.vibes = Vibe.allCases.filter { vibes.contains($0) }
        profile.diet = diet
        profile.allergens = noAllergies ? [] : allergens
        profile.dislikedIngredientIds = dislikes
        profile.appliances = appliances.isEmpty ? [.stovetop] : appliances
        profile.trialReminderDaysBefore = trialReminderDaysBefore
    }
}

/// The quiz steps, in order.
enum OnboardingStep: Int, CaseIterable, Hashable {
    case welcome
    case name
    case goals
    case time
    case country
    case store
    case household
    case cookingDays
    case budget
    case vibes
    case diet
    case allergies
    case dislikes
    case appliances
    case savings
    case socialProof
    case notifications
    case building

    var showsProgress: Bool { self != .welcome && self != .building }

    /// 0...1 for the progress bar.
    var progress: Double {
        let first: Int = OnboardingStep.name.rawValue
        let last: Int = OnboardingStep.notifications.rawValue
        return Double(rawValue - first + 1) / Double(last - first + 1)
    }

    var next: OnboardingStep? { OnboardingStep(rawValue: rawValue + 1) }
    var previous: OnboardingStep? { OnboardingStep(rawValue: rawValue - 1) }
}

/// Goal options (stored as ids).
enum OnboardingGoal: String, CaseIterable, Identifiable {
    case spendLess
    case stopWondering
    case eatHealthier
    case saveTime
    case cookMore
    case feedFamily

    var id: String { rawValue }

    var title: String {
        switch self {
        case .spendLess: return String(localized: "Spend less on food")
        case .stopWondering: return String(localized: "Stop wondering what's for dinner")
        case .eatHealthier: return String(localized: "Eat healthier")
        case .saveTime: return String(localized: "Save time")
        case .cookMore: return String(localized: "Cook more at home")
        case .feedFamily: return String(localized: "Feed my family")
        }
    }

    var systemImage: String {
        switch self {
        case .spendLess: return "banknote"
        case .stopWondering: return "questionmark.bubble"
        case .eatHealthier: return "carrot"
        case .saveTime: return "clock"
        case .cookMore: return "frying.pan"
        case .feedFamily: return "figure.2.and.child.holdinghands"
        }
    }
}

/// "How long on a weeknight?" options.
enum CookTimeOption: Int, CaseIterable, Identifiable {
    case quick = 20
    case medium = 30
    case relaxed = 45
    case dontMind = 0

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .quick: return String(localized: "15–20 min")
        case .medium: return String(localized: "20–30 min")
        case .relaxed: return String(localized: "30–45 min")
        case .dontMind: return String(localized: "I don't mind")
        }
    }

    var subtitle: String {
        switch self {
        case .quick: return String(localized: "in and out of the kitchen")
        case .medium: return String(localized: "the weeknight sweet spot")
        case .relaxed: return String(localized: "happy to take my time")
        case .dontMind: return String(localized: "show me everything")
        }
    }

    var systemImage: String {
        switch self {
        case .quick: return "hare"
        case .medium: return "timer"
        case .relaxed: return "tortoise"
        case .dontMind: return "infinity"
        }
    }
}
