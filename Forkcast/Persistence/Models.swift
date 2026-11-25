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
    /// ISO weekdays (1 = Mon ... 7 = Sun), comma-separated. Every planned meal type uses these days.
    var cookingDaysRaw: String = "1,2,3,4,5"
    /// `MealType` raw values to plan, comma-separated (dinner only by default).
    var mealTypesRaw: String = "dinner"
    var weeklyBudget: Double = 50
    var nutritionTargetData: Data? = nil
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
    var appleEmail: String? = nil
    var includeUserRecipesInPlans: Bool = true
    /// `OnboardingAnswers` as JSON (obstacles, pantry, meal prep, extra diets…).
    var onboardingAnswersJSON: String = ""
    var createdAt: Date = Date()

    init() {}

    // MARK: Typed accessors (not persisted)

    var nutritionTarget: NutritionTarget? {
        get {
            nutritionTargetData.flatMap { try? JSONDecoder().decode(NutritionTarget.self, from: $0) }
        }
        set {
            nutritionTargetData = newValue.flatMap { try? JSONEncoder().encode($0) }
        }
    }

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

    /// Meal types to plan; never empty (falls back to dinner).
    var mealTypes: Set<MealType> {
        get {
            let parsed: Set<MealType> = Set(Self.strings(mealTypesRaw).compactMap { MealType(rawValue: $0) })
            return parsed.isEmpty ? [.dinner] : parsed
        }
        set { mealTypesRaw = MealType.ordered(newValue).map { $0.rawValue }.joined(separator: ",") }
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

    /// By day, then breakfast → lunch → dinner → snack, then the user's order.
    var sortedMeals: [PlannedMeal] {
        let calendar: Calendar = WeekMath.gregorian
        return (meals ?? []).sorted { lhs, rhs in
            let lhsDay: Date = calendar.startOfDay(for: lhs.date)
            let rhsDay: Date = calendar.startOfDay(for: rhs.date)
            if lhsDay != rhsDay { return lhsDay < rhsDay }
            if lhs.isSide != rhs.isSide { return !lhs.isSide }
            if lhs.mealType != rhs.mealType { return lhs.mealType < rhs.mealType }
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
    var isSide: Bool = false
    var isCooked: Bool = false
    var cookedAt: Date? = nil
    var weekPlan: WeekPlan? = nil
    /// Set when the meal is one of the user's own recipes (recipeId also holds "user:<uuid>").
    var userRecipe: UserRecipe? = nil
    /// `MealType` raw value. Meals saved before meal types existed are dinners.
    var mealTypeRaw: String = "dinner"
    var plannerMealID: UUID? = nil
    var leftoversFromMealID: UUID? = nil
    var planningReasonData: Data? = nil

    func ensurePlannerMealID() -> UUID {
        if let plannerMealID { return plannerMealID }
        let id = UUID()
        plannerMealID = id
        return id
    }

    init(date: Date, recipeId: String, servings: Double, orderIndex: Int, mealType: MealType = .dinner) {
        self.date = date
        self.recipeId = recipeId
        self.servings = servings
        self.orderIndex = orderIndex
        self.mealTypeRaw = mealType.rawValue
    }

    var mealType: MealType {
        get { MealType(rawValue: mealTypeRaw) ?? .dinner }
        set { mealTypeRaw = newValue.rawValue }
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
final class GroceryCollection {
    var id: String = UUID().uuidString
    var title: String = ""
    var createdAt: Date = Date()

    init(title: String) { self.title = title }
}

@Model
final class ExtraGroceryItem {
    var name: String = ""
    var quantityText: String = ""
    var listID: String? = nil
    var ingredientID: String? = nil
    var isChecked: Bool = false
    var createdAt: Date = Date()

    init(name: String, quantityText: String, listID: String? = nil, ingredientID: String? = nil) {
        self.name = name
        self.quantityText = quantityText
        self.listID = listID
        self.ingredientID = ingredientID
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
    var isFavorite: Bool = false
    var cookedAt: Date? = nil
    @Attribute(.externalStorage) var photoData: Data? = nil
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
final class RecipeCollection {
    var id: String = UUID().uuidString
    var title: String = ""
    var recipeIDsJSON: String = "[]"
    var createdAt: Date = Date()

    init(title: String) { self.title = title }

    var recipeIDs: [String] {
        get { (try? JSONDecoder().decode([String].self, from: Data(recipeIDsJSON.utf8))) ?? [] }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            recipeIDsJSON = String(decoding: data, as: UTF8.self)
        }
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
    /// `MealType` raw value; the user picks it when creating the recipe.
    var mealTypeRaw: String = "dinner"

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

    var mealType: MealType {
        get { MealType(rawValue: mealTypeRaw) ?? .dinner }
        set { mealTypeRaw = newValue.rawValue }
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
            mealType: mealType,
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

/// Append-only observations, except when undoing a meal's cooked checkbox.
@Model
final class RecipeBehavior {
    var recipeId: String = ""
    var kindRaw: String = ""
    var occurredAt: Date = Date()
    var stars: Int? = nil
    var mealID: UUID? = nil

    init(recipeId: String, kind: TasteEvent.Kind, date: Date, stars: Int? = nil, mealID: UUID? = nil) {
        self.recipeId = recipeId
        kindRaw = kind.rawValue
        occurredAt = date
        self.stars = stars
        self.mealID = mealID
    }

    var event: TasteEvent? {
        guard let kind = TasteEvent.Kind(rawValue: kindRaw), !recipeId.isEmpty else { return nil }
        return TasteEvent(recipeId: recipeId, kind: kind, date: occurredAt, stars: stars)
    }
}

@MainActor
enum RecipeBehaviorLog {
    static func record(_ kind: TasteEvent.Kind, recipeId: String, in context: ModelContext,
                       date: Date = Date(), stars: Int? = nil, mealID: UUID? = nil) {
        context.insert(RecipeBehavior(recipeId: recipeId, kind: kind, date: date, stars: stars, mealID: mealID))
    }

    static func matchingMeal(_ id: UUID, in context: ModelContext) -> [RecipeBehavior] {
        let target: UUID? = id
        let descriptor = FetchDescriptor<RecipeBehavior>(predicate: #Predicate { $0.mealID == target })
        return (try? context.fetch(descriptor)) ?? []
    }

    static func recordCook(recipeId: String, in context: ModelContext, date: Date, mealID: UUID?) {
        let cooked = TasteEvent.Kind.cooked.rawValue
        let repeated = TasteEvent.Kind.cookedAgain.rawValue
        var descriptor = FetchDescriptor<RecipeBehavior>(predicate: #Predicate {
            $0.recipeId == recipeId && ($0.kindRaw == cooked || $0.kindRaw == repeated)
        })
        descriptor.fetchLimit = 1
        let count = (try? context.fetchCount(descriptor)) ?? 0
        record(count > 0 ? .cookedAgain : .cooked, recipeId: recipeId, in: context, date: date, mealID: mealID)
    }

    static func events(in context: ModelContext, asOf: Date) -> [TasteEvent] {
        let stored = (try? context.fetch(FetchDescriptor<RecipeBehavior>())) ?? []
        var events = stored.compactMap(\.event)
        let calendar = WeekMath.gregorian
        let cutoff = asOf.addingTimeInterval(-26 * 7 * 24 * 3600)
        let plans = (try? context.fetch(FetchDescriptor<WeekPlan>(sortBy: [
            SortDescriptor(\WeekPlan.createdAt, order: .reverse)
        ]))) ?? []
        let recordedSkips = Set(stored.filter { $0.kindRaw == TasteEvent.Kind.skipped.rawValue }.compactMap(\.mealID))
        let recordedCooks = Set(stored.filter {
            $0.kindRaw == TasteEvent.Kind.cooked.rawValue || $0.kindRaw == TasteEvent.Kind.cookedAgain.rawValue
        }.compactMap(\.mealID))
        var seenWeeks: Set<Date> = []
        var writes = false
        for plan in plans where seenWeeks.insert(calendar.startOfDay(for: plan.weekStartDate)).inserted {
            guard let end = calendar.date(byAdding: .day, value: 7, to: plan.weekStartDate) else { continue }
            for meal in plan.sortedMeals {
                if plan.createdAt <= asOf {
                    events.append(TasteEvent(recipeId: meal.recipeId, kind: .planned, date: plan.createdAt))
                }
                // Leftovers are a second serving of a cook, so they carry no separate learning signal.
                guard meal.leftoversFromMealID == nil else { continue }
                if let cookedAt = meal.cookedAt, meal.plannerMealID.map(recordedCooks.contains) != true {
                    events.append(TasteEvent(recipeId: meal.recipeId, kind: .cooked, date: cookedAt))
                }
                guard !meal.isCooked, end <= asOf, end >= cutoff else { continue }
                let id = meal.ensurePlannerMealID()
                guard !recordedSkips.contains(id) else { continue }
                record(.skipped, recipeId: meal.recipeId, in: context, date: end, mealID: id)
                events.append(TasteEvent(recipeId: meal.recipeId, kind: .skipped, date: end))
                writes = true
            }
        }
        if writes { try? context.save() }

        let ratingKinds: Set<TasteEvent.Kind> = [.liked, .notForMe, .ratingCleared]
        let recordedRatings = Set(events.filter { ratingKinds.contains($0.kind) }.map(\.recipeId))
        let recordedStars = Set(events.filter { $0.kind == .stars }.map(\.recipeId))
        for row in (try? context.fetch(FetchDescriptor<RecipeFeedback>())) ?? [] {
            if let rating = row.rating, !recordedRatings.contains(row.recipeId) {
                events.append(TasteEvent(recipeId: row.recipeId, kind: rating == .like ? .liked : .notForMe, date: row.date))
            }
            if row.stars > 0 && !recordedStars.contains(row.recipeId) {
                events.append(TasteEvent(recipeId: row.recipeId, kind: .stars, date: row.date, stars: row.stars))
            }
        }
        for row in (try? context.fetch(FetchDescriptor<SavedRecipe>())) ?? [] {
            events.append(TasteEvent(recipeId: row.recipeId, kind: .saved, date: row.savedAt))
        }
        return events
    }
}
