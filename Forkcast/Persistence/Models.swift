import Foundation
import SwiftData
import ForkcastCore

// CloudKit-compatible SwiftData models.
// Rules (the app crashes on launch with CloudKit if these are broken):
//  • every stored property is optional or has a default value
//  • no @Attribute(.unique)
//  • every relationship is optional and has an inverse
// Arrays and sets are stored as comma-separated strings or JSON strings.

@Model
final class UserProfile {
    var name: String = ""
    var countryId: String = "us"
    /// The main shop. It sets the price tier for the whole plan.
    var storeId: String = "local"
    /// Other shops the user also uses, comma-separated, in the order they were picked.
    var extraStoreIdsRaw: String = ""
    /// nil = follow the country; "imperial" / "metric" = user override.
    var unitSystemOverride: String? = nil
    var householdAdults: Int = 2
    var householdKids: Int = 0
    /// ISO weekdays (1 = Mon ... 7 = Sun), comma-separated.
    var cookingDaysRaw: String = "1,2,3,4,5"
    var weeklyBudget: Double = 50
    var vibesRaw: String = ""
    var dietRaw: String = "none"
    var allergensRaw: String = ""
    var dislikedIngredientIdsRaw: String = ""
    var appliancesRaw: String = "oven,stovetop,microwave"
    /// 0 = "I don't mind".
    var maxCookMinutes: Int = 0
    var goalsRaw: String = ""
    var referralSource: String? = nil
    var onboardingCompletedAt: Date? = nil
    var weeklyReminderEnabled: Bool = true
    /// ISO weekday (7 = Sunday).
    var weeklyReminderWeekday: Int = 7
    var weeklyReminderHour: Int = 10
    var trialReminderDaysBefore: Int = 1
    var appleUserId: String? = nil
    var includeUserRecipesInPlans: Bool = true
    /// `OnboardingAnswers` as JSON (obstacles, pantry, meal prep, extra diets…).
    var onboardingAnswersJSON: String = ""
    var createdAt: Date = Date()

    init() {}

    // MARK: Typed accessors (not persisted)

    var cookingDays: Set<Int> {
        get { Set(Self.ints(cookingDaysRaw)) }
        set { cookingDaysRaw = newValue.sorted().map(String.init).joined(separator: ",") }
    }

    var onboardingAnswers: OnboardingAnswers {
        get { OnboardingAnswers.decode(onboardingAnswersJSON) }
        set { onboardingAnswersJSON = newValue.json }
    }

    /// Every shop the user picked, main shop first.
    var storeIds: [String] {
        get { [storeId] + Self.strings(extraStoreIdsRaw).filter { $0 != storeId } }
        set {
            storeId = newValue.first ?? Store.localStoreId
            extraStoreIdsRaw = newValue.dropFirst().joined(separator: ",")
        }
    }

    var vibes: [Vibe] {
        get { Self.strings(vibesRaw).compactMap { Vibe(rawValue: $0) } }
        set { vibesRaw = newValue.map { $0.rawValue }.joined(separator: ",") }
    }

    var diet: Diet {
        get { Diet(rawValue: dietRaw) ?? .none }
        set { dietRaw = newValue.rawValue }
    }

    var allergens: Set<Allergen> {
        get { Set(Self.strings(allergensRaw).compactMap { Allergen(rawValue: $0) }) }
        set { allergensRaw = newValue.map { $0.rawValue }.sorted().joined(separator: ",") }
    }

    var dislikedIngredientIds: Set<String> {
        get { Set(Self.strings(dislikedIngredientIdsRaw)) }
        set { dislikedIngredientIdsRaw = newValue.sorted().joined(separator: ",") }
    }

    var appliances: Set<Appliance> {
        get { Set(Self.strings(appliancesRaw).compactMap { Appliance(rawValue: $0) }) }
        set { appliancesRaw = newValue.map { $0.rawValue }.sorted().joined(separator: ",") }
    }

    var goals: [String] {
        get { Self.strings(goalsRaw) }
        set { goalsRaw = newValue.joined(separator: ",") }
    }

    var maxCookMinutesOrNil: Int? {
        maxCookMinutes > 0 ? maxCookMinutes : nil
    }

    var portionsPerMeal: Double {
        BudgetMath.portions(adults: householdAdults, kids: householdKids)
    }

    static func strings(_ raw: String) -> [String] {
        raw.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }

    static func ints(_ raw: String) -> [Int] {
        strings(raw).compactMap { Int($0) }
    }
}

@Model
final class WeekPlan {
    var weekStartDate: Date = Date()
    var storeIdSnapshot: String = ""
    var budgetSnapshot: Double = 0
    var createdAt: Date = Date()
    var feedbackGiven: Bool = false
    var regenerationCount: Int = 0
    @Relationship(deleteRule: .cascade, inverse: \PlannedMeal.weekPlan)
    var meals: [PlannedMeal]? = []
    @Relationship(deleteRule: .cascade, inverse: \GroceryCheck.weekPlan)
    var groceryChecks: [GroceryCheck]? = []

    init(weekStartDate: Date, storeIdSnapshot: String, budgetSnapshot: Double) {
        self.weekStartDate = weekStartDate
        self.storeIdSnapshot = storeIdSnapshot
        self.budgetSnapshot = budgetSnapshot
        self.createdAt = Date()
    }

    var sortedMeals: [PlannedMeal] {
        (meals ?? []).sorted { lhs, rhs in
            if lhs.date != rhs.date { return lhs.date < rhs.date }
            return lhs.orderIndex < rhs.orderIndex
        }
    }

    var weekEndDate: Date {
        WeekMath.gregorian.date(byAdding: .day, value: 6, to: weekStartDate) ?? weekStartDate
    }
}

@Model
final class PlannedMeal {
    var date: Date = Date()
    /// Bundled slug, or "user:<uuid>" for a user recipe.
    var recipeId: String = ""
    var servings: Double = 2
    var orderIndex: Int = 0
    var isCooked: Bool = false
    var cookedAt: Date? = nil
    var weekPlan: WeekPlan? = nil
    /// Set when the meal is one of the user's own recipes (recipeId also holds "user:<uuid>").
    var userRecipe: UserRecipe? = nil

    init(date: Date, recipeId: String, servings: Double, orderIndex: Int) {
        self.date = date
        self.recipeId = recipeId
        self.servings = servings
        self.orderIndex = orderIndex
    }
}

@Model
final class GroceryCheck {
    var ingredientKey: String = ""
    var isChecked: Bool = false
    var weekPlan: WeekPlan? = nil

    init(ingredientKey: String, isChecked: Bool) {
        self.ingredientKey = ingredientKey
        self.isChecked = isChecked
    }
}

@Model
final class ExtraGroceryItem {
    var name: String = ""
    var quantityText: String = ""
    var isChecked: Bool = false
    var createdAt: Date = Date()

    init(name: String, quantityText: String) {
        self.name = name
        self.quantityText = quantityText
        self.createdAt = Date()
    }
}

@Model
final class RecipeFeedback {
    var recipeId: String = ""
    /// "like" / "notForMe" / nil (stars only).
    var ratingRaw: String? = nil
    /// 0 = no stars, otherwise 1...5.
    var stars: Int = 0
    var date: Date = Date()

    init(recipeId: String, rating: FeedbackRating?, stars: Int = 0) {
        self.recipeId = recipeId
        self.ratingRaw = rating?.rawValue
        self.stars = stars
        self.date = Date()
    }

    var rating: FeedbackRating? {
        get { ratingRaw.flatMap { FeedbackRating(rawValue: $0) } }
        set { ratingRaw = newValue?.rawValue }
    }
}

@Model
final class SavedRecipe {
    var recipeId: String = ""
    var savedAt: Date = Date()

    init(recipeId: String) {
        self.recipeId = recipeId
        self.savedAt = Date()
    }
}

@Model
final class UserRecipe {
    var uuid: String = UUID().uuidString
    var title: String = ""
    var emoji: String = "🍽️"
    var servings: Int = 2
    var totalMinutes: Int = 30
    var tagsRaw: String = ""
    /// JSON-encoded [String].
    var stepsJSON: String = "[]"
    @Relationship(deleteRule: .cascade, inverse: \UserRecipeIngredient.recipe)
    var ingredients: [UserRecipeIngredient]? = []
    @Relationship(deleteRule: .nullify, inverse: \PlannedMeal.userRecipe)
    var plannedMeals: [PlannedMeal]? = []
    var overrideKcal: Double? = nil
    var overrideProtein: Double? = nil
    var overrideCarbs: Double? = nil
    var overrideFat: Double? = nil
    var sourceURL: String? = nil
    var sourceKindRaw: String = "manual"
    var createdAt: Date = Date()
    var notes: String = ""

    init(title: String) {
        self.uuid = UUID().uuidString
        self.title = title
        self.createdAt = Date()
    }

    var recipeId: String { Recipe.userIdPrefix + uuid }

    var steps: [String] {
        get {
            guard let data = stepsJSON.data(using: .utf8),
                  let decoded = try? JSONDecoder().decode([String].self, from: data) else { return [] }
            return decoded
        }
        set {
            if let data = try? JSONEncoder().encode(newValue), let text = String(data: data, encoding: .utf8) {
                stepsJSON = text
            }
        }
    }

    var tags: [String] {
        get { UserProfile.strings(tagsRaw) }
        set { tagsRaw = newValue.joined(separator: ",") }
    }

    var sourceKind: RecipeSourceKind {
        get { RecipeSourceKind(rawValue: sourceKindRaw) ?? .manual }
        set { sourceKindRaw = newValue.rawValue }
    }

    var macroOverride: Macros? {
        get {
            guard let kcal = overrideKcal else { return nil }
            return Macros(kcal: kcal, protein: overrideProtein ?? 0, carbs: overrideCarbs ?? 0, fat: overrideFat ?? 0)
        }
        set {
            overrideKcal = newValue?.kcal
            overrideProtein = newValue?.protein
            overrideCarbs = newValue?.carbs
            overrideFat = newValue?.fat
        }
    }

    var sortedIngredients: [UserRecipeIngredient] {
        (ingredients ?? []).sorted { $0.orderIndex < $1.orderIndex }
    }

    /// The shared recipe type used by plan, detail, swap and cook mode.
    func asRecipe() -> Recipe {
        let tagSet: Set<String> = Set(tags)
        let vibes: [Vibe] = tags.compactMap { Vibe(rawValue: $0) }
        let items: [RecipeIngredient] = sortedIngredients.map { $0.asRecipeIngredient() }
        let prep: Int = min(15, totalMinutes / 3)
        return Recipe(
            id: recipeId,
            title: title.isEmpty ? String(localized: "Untitled recipe") : title,
            emoji: emoji,
            cuisine: .other,
            vibes: vibes,
            appliances: [],
            prepMinutes: prep,
            cookMinutes: max(0, totalMinutes - prep),
            baseServings: max(1, servings),
            ingredients: items,
            steps: steps,
            imageName: nil,
            isLeftoverFriendly: tagSet.contains(Vibe.batchFriendly.rawValue),
            source: sourceKind,
            macroOverride: macroOverride,
            tags: tags.filter { Vibe(rawValue: $0) == nil },
            notes: notes.isEmpty ? nil : notes,
            sourceURL: sourceURL
        )
    }
}

@Model
final class UserRecipeIngredient {
    var name: String = ""
    var ingredientId: String? = nil
    var amount: Double = 1
    var unitRaw: String = "piece"
    var orderIndex: Int = 0
    var recipe: UserRecipe? = nil

    init(name: String, ingredientId: String?, amount: Double, unit: MeasureUnit, orderIndex: Int) {
        self.name = name
        self.ingredientId = ingredientId
        self.amount = amount
        self.unitRaw = unit.rawValue
        self.orderIndex = orderIndex
    }

    var unit: MeasureUnit {
        get { MeasureUnit(rawValue: unitRaw) ?? .piece }
        set { unitRaw = newValue.rawValue }
    }

    func asRecipeIngredient() -> RecipeIngredient {
        RecipeIngredient(ingredientId: ingredientId, name: name.isEmpty ? nil : name, amount: amount, unit: unit)
    }
}
