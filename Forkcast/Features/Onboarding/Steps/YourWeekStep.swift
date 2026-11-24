import SwiftUI
import ForkcastCore

/// 5. Which meals, which days, how long on a weeknight, and meal prep mode, on one screen.
/// Every chosen meal is planned on every chosen day. Dinner is preselected; at least one meal stays on.
struct YourWeekStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "your week"),
            subtitle: String(localized: "which meals and which days should we plan?"),
            isButtonEnabled: !state.cookingDays.isEmpty && !state.mealTypes.isEmpty,
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                section(String(localized: "Meals")) {
                    MealTypePicker(selection: $state.mealTypes)
                        .onChange(of: state.mealTypes) { _, _ in state.refreshSuggestedBudget(catalog: .bundled) }
                }
                section(String(localized: "Days")) {
                    CookingDaysEditor(days: $state.cookingDays, showsSummary: false)
                }
                Text(mealsLine)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .contentTransition(.numericText())
                    .animation(Theme.spring, value: state.mealsPerWeek)
                    .frame(maxWidth: .infinity)
                section(String(localized: "Weeknight cooking time")) {
                    FlowLayout(spacing: 8) {
                        ForEach(CookTimeOption.allCases) { option in
                            Chip(title: option.title, isSelected: state.maxCookMinutes == option.rawValue) {
                                state.maxCookMinutes = option.rawValue
                            }
                        }
                    }
                }
                MealPrepToggle(isOn: $state.mealPrepMode)
            }
        }
    }

    /// "That's 10 meals a week" (or "5 dinners a week" when it's dinners only).
    private var mealsLine: String {
        let count: Int = state.mealsPerWeek
        if state.mealTypes == [.dinner] {
            return count == 1 ? String(localized: "That's 1 dinner a week") : String(localized: "That's \(count) dinners a week")
        }
        return count == 1 ? String(localized: "That's 1 meal a week") : String(localized: "That's \(count) meals a week")
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

/// "Meal prep mode" with a NEW badge: leans the plan towards dinners that keep well.
private struct MealPrepToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: Theme.Spacing.s) {
                    Text("Meal prep mode")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                    TagLabel(text: String(localized: "NEW"), tint: Color.white, fill: Theme.tomato)
                }
                Text("Cook once, eat twice. We'll favour dinners that keep well.")
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
