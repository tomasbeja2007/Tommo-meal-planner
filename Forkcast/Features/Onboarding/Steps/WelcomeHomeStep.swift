import SwiftUI
import ForkcastCore

struct WelcomeHomeStep: View {
    let onFinish: () -> Void

    @Environment(PlanStore.self) private var planStore
    @Environment(ProfileStore.self) private var profileStore
    @State private var appeared = false

    private var ready: Bool { !planStore.meals.isEmpty }

    private var budgetStat: (value: String, label: String) {
        guard ready, let estimate = planStore.basketEstimate, let budget = GroceryEstimate(planStore.budget), budget.amount > 0 else {
            return ("—", String(localized: "estimate unavailable"))
        }
        let difference = budget.difference(from: estimate)
        let value = profileStore.formatMoney(abs(difference))
        if difference == 0 { return (value, String(localized: "on budget")) }
        return (value, difference > 0 ? String(localized: "under budget") : String(localized: "over budget"))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.l) {
                if ready { ProduceCelebration() }
                else { MascotView(size: 128, mood: .idle) }
                VStack(spacing: Theme.Spacing.s) {
                    Text("Welcome to Tommo")
                        .font(Theme.questionFont)
                        .foregroundStyle(Theme.aubergine)
                        .accessibilityAddTraits(.isHeader)
                    Text(ready ? "Your week of meals is ready. Time to cook something good." : "You're ready to start planning meals.")
                        .foregroundStyle(Theme.aubergineMuted)
                }
                if ready {
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: Theme.Spacing.s) { stats }
                        VStack(spacing: Theme.Spacing.s) { stats }
                    }
                    if planStore.currentPlanIsSaved {
                        Label("Your plan is saved to this device", systemImage: "checkmark.circle")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Theme.herb)
                    }
                }
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(Theme.Spacing.gutter)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(String(localized: "Let's go"), action: onFinish)
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.vertical, Theme.Spacing.s)
                .background(Theme.cream)
        }
        .sensoryFeedback(.success, trigger: appeared)
        .onAppear { appeared = ready }
    }

    @ViewBuilder
    private var stats: some View {
        StatTile(value: planStore.meals.count.formatted(), label: String(localized: "meals planned"))
        StatTile(value: budgetStat.value, label: budgetStat.label)
        StatTile(value: "1", label: String(localized: "shopping list"))
    }
}

private struct ProduceCelebration: View {
    private let ingredients = ["tomato", "carrot", "avocado", "lemon", "broccoli", "onion", "eggplant", "bell-pepper"]
    @State private var visible = false

    var body: some View {
        LoopClock(period: 4_800, paused: !visible) { time in
            ZStack {
                Circle().fill(Theme.herbSoft).frame(width: 138, height: 138)
                Circle().strokeBorder(Theme.herb.opacity(0.2), lineWidth: 1).frame(width: 156, height: 156)
                Image(systemName: "checkmark")
                    .font(.system(size: 52, weight: .heavy))
                    .foregroundStyle(Theme.herb)
                ForEach(Array(ingredients.enumerated()), id: \.offset) { index, id in
                    let angle = 2 * Double.pi * Double(index) / Double(ingredients.count)
                    let pulse = sin(angle + 2 * .pi * time / 4_800)
                    IngredientThumbnail(ingredientID: id, size: 41, showsBackground: false)
                        .scaleEffect(1 + 0.08 * pulse)
                        .offset(x: cos(angle) * 104, y: sin(angle) * (89 + 4 * pulse))
                }
            }
            .frame(width: 254, height: 222)
            .accessibilityHidden(true)
        }
        .onAppear { visible = true }
        .onDisappear { visible = false }
    }
}

#Preview { WelcomeHomeStep {}.previewEnvironment().creamBackground() }
