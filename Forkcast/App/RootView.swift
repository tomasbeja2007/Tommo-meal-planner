import SwiftUI
import ForkcastCore

/// Onboarding until the profile is complete, then the main tabs.
struct RootView: View {
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(\.scenePhase) private var scenePhase: ScenePhase

    var body: some View {
        ZStack {
            Theme.cream.ignoresSafeArea()
            if profileStore.hasCompletedOnboarding {
                MainTabView()
                    .transition(.opacity)
            } else {
                OnboardingFlow()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: profileStore.hasCompletedOnboarding)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                repository.refresh()
                planStore.reload()
            }
        }
    }
}
