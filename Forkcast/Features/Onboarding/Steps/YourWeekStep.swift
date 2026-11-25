import SwiftUI
import ForkcastCore

/// 5. Which meals, which days, how long on a weeknight, and meal prep mode, on one screen.
/// Every chosen meal is planned on every chosen day. Dinner is preselected; at least one meal stays on.
struct YourWeekStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        QuestionScaffold(
            title: String(localized: "Which days are you cooking?"),
            subtitle: String(localized: "We'll only plan meals for the days you pick."),
            buttonTitle: String(localized: "Next"),
            isButtonEnabled: !state.cookingDays.isEmpty && !state.mealTypes.isEmpty,
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                CookingDaysEditor(days: $state.cookingDays, showsSummary: false, showsConnectors: state.mealPrepMode, prepEdges: $state.mealPrepEdges)
                Text(daysLine)
                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .contentTransition(.numericText())
                    .animation(reduceMotion ? nil : Theme.Motion.update, value: state.cookingDays.count)
                    .frame(maxWidth: .infinity)
                MealPrepToggle(isOn: $state.mealPrepMode)
                section(String(localized: "Meals")) {
                    MealTypePicker(selection: $state.mealTypes)
                        .onChange(of: state.mealTypes) { _, _ in state.refreshSuggestedBudget(catalog: .bundled) }
                }
                section(String(localized: "Weeknight cooking time")) {
                    FlowLayout(spacing: Theme.Spacing.s) {
                        ForEach(CookTimeOption.allCases) { option in
                            Chip(title: option.title, isSelected: state.maxCookMinutes == option.rawValue) {
                                state.maxCookMinutes = option.rawValue
                            }
                        }
                    }
                }
            }
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: state.mealPrepMode)
        }
    }

    private var daysLine: String {
        let count = state.cookingDays.count
        return count == 1 ? String(localized: "Planning 1 day this week") : String(localized: "Planning \(count) days this week")
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            Text(title)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.aubergine)
            content()
        }
    }
}

/// Explains how adjacent cooking days can share a batch.
struct MealPrepToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                HStack(spacing: Theme.Spacing.s) {
                    Label("Meal Prep Mode", systemImage: "frying.pan")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                }
                Text(isOn ? "Tap + between days to share meals. Tap a link to split them. Up to 5 days." : "Cook once, eat it for 2–5 days.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .tint(Theme.tomato)
        .padding(Theme.Spacing.l)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(Theme.creamDeep))
        .sensoryFeedback(.selection, trigger: isOn)
    }
}

#Preview {
    YourWeekStep(state: OnboardingState()) {}.creamBackground()
}
