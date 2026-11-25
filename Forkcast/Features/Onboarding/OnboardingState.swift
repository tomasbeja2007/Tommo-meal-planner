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
    var countryId: String = OnboardingState.deviceCountryId()
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
    var nutritionTarget: NutritionTarget?
    var allergens: Set<Allergen> = []
    /// "No allergies" is preselected; picking any allergen clears it.
    var noAllergies: Bool = true
    var dislikes: Set<String> = []
    var appliances: Set<Appliance> = [.oven, .stovetop]
    var trialReminderDaysBefore: Int = 1

    // Answers stored in `OnboardingAnswers` (JSON on the profile).
    var obstacles: Set<OnboardingObstacle> = []
    /// Meals to plan on every chosen day. Dinner is preselected; at least one is required.
    var mealTypes: Set<MealType> = [.dinner]
    var mealPrepMode: Bool = false
    var extraDiets: Set<ExtraDiet> = []
    var pantry: Set<String> = []
    var requestedStore: String = ""

    init() {}

    /// The phone's region if we support it, otherwise the US.
    static func deviceCountryId(catalog: FoodCatalog = .bundled) -> String {
        let region: String = (Locale.current.region?.identifier ?? "US").lowercased()
        return catalog.country(id: region) != nil ? region : "us"
    }

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
        nutritionTarget = profile.nutritionTarget
        allergens = profile.allergens
        noAllergies = profile.allergens.isEmpty
        dislikes = profile.dislikedIngredientIds
        appliances = profile.appliances
        trialReminderDaysBefore = profile.trialReminderDaysBefore
        let answers: OnboardingAnswers = profile.onboardingAnswers
        obstacles = Set(answers.obstacles.compactMap { OnboardingObstacle(rawValue: $0) })
        mealTypes = profile.mealTypes
        mealPrepMode = answers.mealPrepMode
        extraDiets = Set(answers.extraDiets.compactMap { ExtraDiet(rawValue: $0) })
        pantry = Set(answers.pantry)
        requestedStore = answers.requestedStore ?? ""
    }

    /// Planning days per week.
    var dinnersPerWeek: Int { cookingDays.isEmpty ? 5 : cookingDays.count }

    /// Meals per week across every chosen meal type.
    var mealsPerWeek: Int { dinnersPerWeek * MealType.ordered(mealTypes).count }

    /// Allergens as the user sees them ("No allergies" clears the set).
    var effectiveAllergens: Set<Allergen> { noAllergies ? [] : allergens }

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
        budget = BudgetMath.defaultBudget(region: country.regionPriceKey, portions: portions, days: cookingDays.count, multiplier: country.priceMultiplier, mealTypes: mealTypes)
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
        profile.mealTypes = mealTypes.isEmpty ? [.dinner] : mealTypes
        profile.weeklyBudget = budget
        profile.vibes = Vibe.allCases.filter { vibes.contains($0) }
        profile.diet = diet
        profile.nutritionTarget = nutritionTarget
        profile.allergens = noAllergies ? [] : allergens
        profile.dislikedIngredientIds = dislikes
        profile.appliances = appliances.isEmpty ? [.stovetop] : appliances
        profile.trialReminderDaysBefore = trialReminderDaysBefore
        var answers: OnboardingAnswers = profile.onboardingAnswers
        answers.obstacles = OnboardingObstacle.allCases.filter { obstacles.contains($0) }.map { $0.rawValue }
        answers.mealPrepMode = mealPrepMode
        answers.extraDiets = ExtraDiet.allCases.filter { extraDiets.contains($0) }.map { $0.rawValue }
        if answers.pantry.sorted() != pantry.sorted() {
            // A new pantry answer applies to the week that starts today.
            answers.pantry = pantry.sorted()
            answers.pantryWeekStart = pantry.isEmpty ? nil : WeekMath.gregorian.startOfDay(for: Date())
        }
        let trimmedRequest: String = requestedStore.trimmingCharacters(in: .whitespacesAndNewlines)
        answers.requestedStore = trimmedRequest.isEmpty ? nil : trimmedRequest
        profile.onboardingAnswers = answers
    }
}

/// The onboarding screens, in order.
enum OnboardingStep: Int, CaseIterable, Hashable {
    case welcome
    // Questions
    case goals
    case obstacles
    case mirror
    case household
    case yourWeek
    case eating
    case nutrition
    case dislikes
    case vibes
    case kitchen
    case budget
    case pantry
    case store
    // The week
    case building
    case reveal
    // Wrap-up
    case reminders
    case trial
    case savePlan
    case home

    /// Steps with the top bar (back, progress, skip).
    var showsTopBar: Bool {
        switch self {
        case .welcome, .building, .reveal, .home: return false
        default: return true
        }
    }

    /// Optional steps offer "Skip" in the top bar.
    var isSkippable: Bool {
        switch self {
        case .obstacles, .dislikes, .pantry: return true
        default: return false
        }
    }

    /// Once the week is built there's no going back into the questions.
    var canGoBack: Bool {
        switch self {
        case .welcome, .goals, .building, .reveal, .reminders, .home: return false
        default: return true
        }
    }

    /// 0...1 across every step with a top bar.
    var progress: Double {
        let counted: [OnboardingStep] = OnboardingStep.allCases.filter { $0.showsTopBar }
        guard let index = counted.firstIndex(of: self) else { return self.rawValue > OnboardingStep.store.rawValue ? 1 : 0 }
        return Double(index + 1) / Double(counted.count)
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

    /// Phrase for the mirror screen: "So you want to **spend less**…".
    var mirrorPhrase: String {
        switch self {
        case .spendLess: return String(localized: "spend less")
        case .stopWondering: return String(localized: "stop wondering what's for dinner")
        case .eatHealthier: return String(localized: "eat healthier")
        case .saveTime: return String(localized: "save time")
        case .cookMore: return String(localized: "cook more at home")
        case .feedFamily: return String(localized: "feed the family")
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
