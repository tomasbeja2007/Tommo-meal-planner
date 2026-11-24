import SwiftUI
import SwiftData
import ForkcastCore

/// In-memory sample data for SwiftUI previews.
@MainActor
enum PreviewData {
    static let services: AppServices = {
        let services = AppServices(inMemory: true)
        let state = OnboardingState()
        state.name = "Sam"
        state.countryId = "us"
        state.storeId = "kroger"
        state.adults = 2
        state.kids = 1
        state.cookingDays = [1, 2, 3, 4, 5]
        state.budget = 85
        state.vibes = [.quickEasy, .family]
        state.appliances = [.oven, .stovetop, .microwave, .airFryer]
        services.profileStore.createProfile(from: state)
        services.planStore.generatePlanNow()
        if let first = services.planStore.meals.first {
            services.planStore.setCooked(first, cooked: true)
        }
        services.library.toggleSaved("shakshuka")
        services.library.toggleSaved("black-bean-tacos")
        return services
    }()

    static var catalog: FoodCatalog { FoodCatalog.bundled }

    static var sampleRecipe: Recipe {
        catalog.recipe(id: "chickpea-spinach-curry") ?? catalog.recipes[0]
    }

    static var firstMeal: PlannedMeal? {
        services.planStore.meals.first
    }
}

extension View {
    /// `#Preview { PlanView().previewEnvironment() }`
    @MainActor
    func previewEnvironment() -> some View {
        self
            .environment(services: PreviewData.services)
            .fontDesign(.rounded)
            .preferredColorScheme(.light)
            .tint(Theme.tomato)
    }
}
