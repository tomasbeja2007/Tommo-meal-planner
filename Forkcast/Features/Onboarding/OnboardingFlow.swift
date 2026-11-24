import SwiftUI
import ForkcastCore

/// The ~17-step quiz. Answers live in `OnboardingState` and are written
/// to `UserProfile` only once the week is built.
struct OnboardingFlow: View {
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    @State private var state: OnboardingState = OnboardingState()
    @State private var step: OnboardingStep = .welcome
    @State private var goingForward: Bool = true
    @State private var didLoadExisting: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if step.showsProgress {
                    OnboardingHeader(progress: step.progress, canGoBack: step.previous != nil) { back() }
                        .transition(.opacity)
                }
                ZStack {
                    stepView
                        .id(step)
                        .transition(transition)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Theme.cream.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear(perform: loadExisting)
    }

    private var transition: AnyTransition {
        if reduceMotion { return .opacity }
        let insertion: Edge = goingForward ? .trailing : .leading
        let removal: Edge = goingForward ? .leading : .trailing
        return .asymmetric(
            insertion: .move(edge: insertion).combined(with: .opacity),
            removal: .move(edge: removal).combined(with: .opacity)
        )
    }

    // MARK: Steps

    @ViewBuilder
    private var stepView: some View {
        switch step {
        case .welcome:
            WelcomeStep { advance() }
        case .name:
            NameStep(state: state) { advance() }
        case .goals:
            GoalsStepView(state: state) { advance() }
        case .time:
            TimeStepView(state: state) { autoAdvance() }
        case .country:
            CountryStepView(state: state) { autoAdvance() }
        case .store:
            StoreStepView(state: state, onPick: { autoAdvance() }, onContinue: { advance() })
        case .household:
            HouseholdStepView(state: state) { advance() }
        case .cookingDays:
            CookingDaysStepView(state: state) { advance() }
        case .budget:
            BudgetStepView(state: state) { advance() }
        case .vibes:
            VibesStepView(state: state) { advance() }
        case .diet:
            DietStepView(state: state) { autoAdvance() }
        case .allergies:
            AllergiesStepView(state: state) { advance() }
        case .dislikes:
            DislikesStepView(state: state) { advance() }
        case .appliances:
            AppliancesStepView(state: state) { advance() }
        case .savings:
            SavingsStep(state: state) { advance() }
        case .socialProof:
            SocialProofStep { advance() }
        case .notifications:
            NotificationsPrimerStep { advance() }
        case .building:
            BuildingWeekStep(state: state) { finish() }
        }
    }

    // MARK: Navigation

    private func advance() {
        guard let next = step.next else { return }
        if next == .budget { state.refreshSuggestedBudget(catalog: FoodCatalog.bundled) }
        goingForward = true
        withAnimation(Theme.motion(reduceMotion) ?? .easeInOut(duration: 0.2)) { step = next }
    }

    /// Single-select screens advance after a short beat so the selection is visible.
    private func autoAdvance() {
        let current: OnboardingStep = step
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 250_000_000)
            if step == current { advance() }
        }
    }

    private func back() {
        guard let previous = step.previous else { return }
        goingForward = false
        withAnimation(Theme.motion(reduceMotion) ?? .easeInOut(duration: 0.2)) { step = previous }
    }

    private func finish() {
        profileStore.completeOnboarding()
        router.selectedTab = .plan
        router.showPlanReveal = true
    }

    /// "Start over" keeps the previous answers as defaults.
    private func loadExisting() {
        guard !didLoadExisting else { return }
        didLoadExisting = true
        if let profile = profileStore.profile {
            state = OnboardingState(profile: profile)
        }
    }
}

#Preview { OnboardingFlow().previewEnvironment() }
