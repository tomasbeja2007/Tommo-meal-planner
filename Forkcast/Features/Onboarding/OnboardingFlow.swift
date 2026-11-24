import SwiftUI
import ForkcastCore

/// Splash → welcome → 12 questions → building → plan reveal → reminders → trial → save → home.
/// Answers live in `OnboardingState`; they're written to `UserProfile` when the week is built,
/// and onboarding is marked complete on the last screen.
struct OnboardingFlow: View {
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    @State private var state: OnboardingState = OnboardingState()
    @State private var step: OnboardingStep = .welcome
    @State private var goingForward: Bool = true
    @State private var didLoadExisting: Bool = false
    @State private var isPaywallPresented: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if step.showsTopBar {
                    OnboardingTopBar(
                        progress: step.progress,
                        canGoBack: step.canGoBack,
                        onSkip: step.isSkippable ? { skip() } : nil
                    ) { back() }
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
        .fullScreenCover(isPresented: $isPaywallPresented, onDismiss: { advance() }) {
            PaywallView { isPaywallPresented = false }
        }
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
        case .goals:
            GoalsStepView(state: state) { advance() }
        case .obstacles:
            ObstaclesStepView(state: state) { advance() }
        case .mirror:
            MirrorStep(state: state) { advance() }
        case .household:
            HouseholdStepView(state: state) { advance() }
        case .yourWeek:
            YourWeekStep(state: state) { advance() }
        case .eating:
            EatingStep(state: state) { advance() }
        case .dislikes:
            DislikesStepView(state: state) { advance() }
        case .vibes:
            VibesStepView(state: state) { advance() }
        case .kitchen:
            AppliancesStepView(state: state) { advance() }
        case .budget:
            BudgetStepView(state: state) { advance() }
        case .pantry:
            PantryStep(state: state) { advance() }
        case .store:
            StoreStepView(state: state) { advance() }
        case .building:
            BuildingWeekStep(state: state) { advance() }
        case .reveal:
            PlanRevealStep(state: state) { advance() }
        case .reminders:
            StayOnTrackStep { advance() }
        case .trial:
            TrialTimelineStep(onStartTrial: { isPaywallPresented = true }, onNotNow: { advance() })
        case .savePlan:
            SaveAccountStep { advance() }
        case .home:
            WelcomeHomeStep(state: state) { finish() }
        }
    }

    // MARK: Navigation

    /// The trial screen only makes sense for people who can still start a trial.
    private func shouldShow(_ candidate: OnboardingStep) -> Bool {
        if candidate == .trial { return subscriptions.isEligibleForTrial && !subscriptions.isPro }
        return true
    }

    private func advance() {
        guard var next = step.next else { return }
        while !shouldShow(next), let after = next.next { next = after }
        if next == .budget { state.refreshSuggestedBudget(catalog: FoodCatalog.bundled) }
        goingForward = true
        withAnimation(Theme.motion(reduceMotion) ?? .easeInOut(duration: 0.2)) { step = next }
    }

    private func back() {
        guard step.canGoBack, var previous = step.previous else { return }
        while !shouldShow(previous), let before = previous.previous { previous = before }
        goingForward = false
        withAnimation(Theme.motion(reduceMotion) ?? .easeInOut(duration: 0.2)) { step = previous }
    }

    /// "Skip" on optional steps clears that answer and moves on.
    private func skip() {
        switch step {
        case .obstacles: state.obstacles.removeAll()
        case .pantry: state.pantry.removeAll()
        default: break
        }
        advance()
    }

    private func finish() {
        if let profile = profileStore.profile {
            var answers: OnboardingAnswers = profile.onboardingAnswers
            answers.completedAt = Date()
            profile.onboardingAnswers = answers
        }
        router.showPlanReveal = false
        router.selectedTab = .plan
        profileStore.completeOnboarding()
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
