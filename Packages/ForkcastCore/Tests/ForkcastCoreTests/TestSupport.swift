import Foundation
@testable import ForkcastCore

enum TestSupport {
    static let catalog: FoodCatalog = FoodCatalog.bundled

    static let usPricing: PriceContext = PriceContext(region: .US, tier: .standard)

    static func slots(days: Set<Int> = [1, 2, 3, 4, 5], mealTypes: Set<MealType> = [.dinner], start: Date = TestSupport.monday) -> [PlanSlot] {
        WeekMath.slots(from: start, cookingDays: days, mealTypes: mealTypes)
    }

    /// Monday 23 Nov 2026, 12:00 UTC.
    static let monday: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 11
        components.day = 23
        components.hour = 12
        return WeekMath.gregorian.date(from: components) ?? Date(timeIntervalSince1970: 1_795_000_000)
    }()

    static func request(
        profile: PlannerProfile = PlannerProfile(),
        days: Set<Int> = [1, 2, 3, 4, 5],
        mealTypes: Set<MealType> = [.dinner],
        servings: Double = 2,
        budget: Double = 500,
        seed: UInt64 = 42,
        feedback: FeedbackSummary = FeedbackSummary(),
        history: [String: Int] = [:],
        locked: [Int: LockedMeal] = [:],
        recipes: [Recipe]? = nil
    ) -> PlannerRequest {
        PlannerRequest(
            profile: profile,
            recipes: recipes ?? catalog.recipes,
            feedback: feedback,
            history: history,
            slots: slots(days: days, mealTypes: mealTypes),
            servings: servings,
            budget: budget,
            pricing: usPricing,
            unitSystem: .imperial,
            seed: seed,
            locked: locked
        )
    }
}
