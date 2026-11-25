import SwiftUI
import ForkcastCore

/// 18. "Sam, your week is ready": Chef Tomato cheers, confetti, three real stats, then the Plan tab.
struct WelcomeHomeStep: View {
    let state: OnboardingState
    let onFinish: () -> Void

    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @State private var appeared: Bool = false

    private var headline: String {
        let name: String = profileStore.name
        return name.isEmpty ? String(localized: "You're all set, your week is ready") : String(localized: "\(name), your week is ready")
    }

    private var budgetStat: (value: String, label: String) {
        let difference: Double = planStore.budget - planStore.total
        let money: String = MoneyFormat.string(abs(difference), currencyCode: profileStore.currencyCode, fractionDigits: 0)
        return difference >= 0 ? (money, String(localized: "under budget")) : (money, String(localized: "over budget"))
    }

    var body: some View {
        ZStack {
            VStack(spacing: Theme.Spacing.xl) {
                Spacer()
                MascotView(size: 180, mood: .cheer)
                Text(headline)
                    .font(Theme.questionFont)
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)
                    .padding(.horizontal, Theme.Spacing.gutter)
                HStack(spacing: Theme.Spacing.s) {
                    StatTile(value: "\(planStore.meals.count)", label: String(localized: "meals planned"))
                    StatTile(value: budgetStat.value, label: budgetStat.label)
                    StatTile(value: "\(planStore.groceryList.itemCount)", label: String(localized: "shopping list items"))
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                Spacer()
                PrimaryButton(String(localized: "Let's cook"), action: onFinish)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .padding(.bottom, Theme.Spacing.m)
            }
            ConfettiView(play: appeared)
                .ignoresSafeArea()
        }
        .sensoryFeedback(.success, trigger: appeared)
        .onAppear { appeared = true }
    }
}

#Preview { WelcomeHomeStep(state: OnboardingState()) {}.previewEnvironment().creamBackground() }
