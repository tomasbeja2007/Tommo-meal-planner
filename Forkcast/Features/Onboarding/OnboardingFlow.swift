import SwiftUI
import ForkcastCore

/// Questions → savings → catalog → reminders → subscriptions → plan → account.
/// Answers live in `OnboardingState`; they're written to `UserProfile` when the week is built,
/// and onboarding is marked complete on the last screen.
struct OnboardingFlow: View {
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    @State private var state: OnboardingState = OnboardingState()
    @State private var step: OnboardingStep = .welcome
    @State private var goingForward: Bool = true
    @State private var crossDissolve = false
    @State private var didLoadExisting: Bool = false

    private var visibleSteps: [OnboardingStep] {
        OnboardingStep.allCases.filter { $0.showsTopBar && shouldShow($0) }
    }

    private var stepNumber: Int { (visibleSteps.firstIndex(of: step) ?? 0) + 1 }

    private var progress: Double {
        let questions = visibleSteps.filter { $0.rawValue <= OnboardingStep.savings.rawValue }
        guard let index = questions.firstIndex(of: step) else { return 1 }
        return Double(index + 1) / Double(questions.count)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if step.showsTopBar {
                    OnboardingTopBar(
                        progress: progress,
                        stepDescription: String(localized: "Step \(stepNumber) of \(visibleSteps.count)"),
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

    }

    private var transition: AnyTransition {
        if reduceMotion || crossDissolve { return .opacity }
        // A short glide instead of a full-screen slide: the next question arrives from 32 pt
        // in the direction of travel and the old one leaves 20 pt the other way, a little faster.
        let direction: CGFloat = goingForward ? 1 : -1
        return .asymmetric(
            insertion: .offset(x: 32 * direction).combined(with: .opacity)
                .animation(Animation.open(0.28)),
            removal: .offset(x: -20 * direction).combined(with: .opacity)
                .animation(.easeIn(duration: 0.16))
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
        case .obstacles:
            ObstaclesStepView(state: state) { advance() }
        case .mirror:
            MirrorStep(state: state) { advance() }
        case .household:
            HouseholdStepView(state: state) { advance() }
        case .yourWeek:
            YourWeekStep(state: state) { advance() }
        case .timeSaved:
            TimeSavedStep(state: state) { advance() }
        case .eating:
            EatingStep(state: state) { advance() }
        case .nutrition:
            NutritionTargetStep(state: state) { advance() }
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
        case .locating:
            LocatingStep(state: state) { advance() }
        case .store:
            StoreStepView(state: state) { advance() }
        case .heardAbout:
            HeardAboutStep(state: state) { advance() }
        case .savings:
            SavingsStep(state: state) { advance() }
        case .catalog:
            CatalogPreviewStep(state: state) { advance() }
        case .building:
            BuildingWeekStep(state: state) { advance() }
        case .reveal:
            PlanRevealStep(state: state) { advance() }
        case .shops:
            ShopsStep(state: state) { advance() }
        case .reminders:
            StayOnTrackStep { advance() }
        case .subscriptions:
            PaywallView(onBack: { back() }, onClose: {
                if step == .subscriptions { advance() }
            })
        case .savePlan:
            SaveAccountStep { advance() }
        case .home:
            WelcomeHomeStep { finish() }
        }
    }

    // MARK: Navigation

    /// Subscribers go directly to their plan.
    private func shouldShow(_ candidate: OnboardingStep) -> Bool {
        if candidate == .subscriptions { return !subscriptions.isPro }
        return true
    }

    private func advance() {
        guard var next = step.next else { return }
        while !shouldShow(next), let after = next.next { next = after }
        if next == .budget { state.refreshSuggestedBudget(catalog: FoodCatalog.bundled) }
        navigate(to: next, forward: true)
    }

    private func back() {
        guard step.canGoBack, var previous = step.previous else { return }
        // The globe is a moment, not a question: going back skips over it.
        while !shouldShow(previous) || previous == .locating, let before = previous.previous { previous = before }
        navigate(to: previous, forward: false)
    }

    private func navigate(to destination: OnboardingStep, forward: Bool) {
        goingForward = forward
        let dissolveSteps: Set<OnboardingStep> = [.timeSaved, .locating, .savings, .catalog, .subscriptions]
        crossDissolve = dissolveSteps.contains(step) || dissolveSteps.contains(destination)
        withAnimation(reduceMotion ? .easeOut(duration: 0.14) : .easeInOut(duration: 0.24)) {
            step = destination
        }
    }

    /// "Skip" on optional steps clears that answer and moves on.
    private func skip() {
        switch step {
        case .obstacles: state.obstacles.removeAll()
        case .pantry: state.pantry.removeAll()
        case .heardAbout: state.referralSource = nil
        default: break
        }
        advance()
    }

    private func finish() {
        if let profile = profileStore.profile {
            var answers: OnboardingAnswers = profile.onboardingAnswers
            answers.completedAt = Date()
            answers.generatedPlanCreatedAt = nil
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
            if let readyPlan = profile.onboardingAnswers.generatedPlanCreatedAt,
               planStore.currentPlan?.createdAt == readyPlan {
                step = profile.appleUserId == nil ? .savePlan : .home
            }
        }
    }
}

#Preview { OnboardingFlow().previewEnvironment() }
