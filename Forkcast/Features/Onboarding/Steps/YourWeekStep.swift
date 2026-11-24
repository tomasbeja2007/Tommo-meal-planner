import SwiftUI
import ForkcastCore

/// 5. Which meals, which days, how long on a weeknight, and meal prep mode, on one screen.
/// Only dinners are planned today: breakfast, lunch and snacks are "coming soon" and a tap
/// just remembers the interest.
struct YourWeekStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "your week"),
            subtitle: String(localized: "which meals and which nights should we plan?"),
            isButtonEnabled: !state.cookingDays.isEmpty,
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                section(String(localized: "Meals")) {
                    FlowLayout(spacing: 8) {
                        ForEach(MealType.allCases) { meal in
                            MealTypeChip(
                                meal: meal,
                                isInterested: state.laterMealTypes.contains(meal)
                            ) {
                                if state.laterMealTypes.contains(meal) {
                                    state.laterMealTypes.remove(meal)
                                } else {
                                    state.laterMealTypes.insert(meal)
                                }
                            }
                        }
                    }
                    if !state.laterMealTypes.isEmpty {
                        Text("We'll tell you when \(laterMealsText) arrive.")
                            .font(.caption)
                            .foregroundStyle(Theme.aubergineMuted)
                            .transition(.opacity)
                    }
                }
                section(String(localized: "Nights")) {
                    CookingDaysEditor(days: $state.cookingDays)
                }
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
            .animation(Theme.spring, value: state.laterMealTypes)
        }
    }

    private var laterMealsText: String {
        let names: [String] = MealType.allCases.filter { state.laterMealTypes.contains($0) }.map { $0.title.lowercased() }
        return names.formatted(.list(type: .and))
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

/// Dinner is always on (with a herb tick). The others say "soon"; tapping one marks interest.
private struct MealTypeChip: View {
    let meal: MealType
    let isInterested: Bool
    let action: () -> Void

    var body: some View {
        if meal.isAvailable {
            label(trailing: AnyView(
                Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.herb)
            ), selected: true)
            .accessibilityLabel(Text("\(meal.title), planned"))
        } else {
            Button(action: action) {
                label(trailing: AnyView(TagLabel(text: isInterested ? String(localized: "notify me") : String(localized: "soon"), tint: Theme.aubergine, fill: Theme.saffronSoft)), selected: false)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isInterested)
            .accessibilityLabel(Text("\(meal.title), coming soon"))
            .accessibilityAddTraits(isInterested ? [.isSelected] : [])
        }
    }

    private func label(trailing: AnyView, selected: Bool) -> some View {
        HStack(spacing: 6) {
            Text(meal.emoji)
            Text(meal.title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(selected ? Theme.tomatoDeep : Theme.aubergineMuted)
            trailing
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .frame(minHeight: 44)
        .background(Capsule().fill(selected ? Theme.tomatoSoft : Theme.creamDeep))
        .overlay(Capsule().stroke(selected ? Theme.tomato : (isInterested ? Theme.saffron : Color.clear), lineWidth: selected ? 2 : 1.5))
        .contentShape(Capsule())
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
