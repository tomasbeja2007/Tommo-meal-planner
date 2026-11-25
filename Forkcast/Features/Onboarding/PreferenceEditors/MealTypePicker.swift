import SwiftUI
import ForkcastCore

/// Breakfast / Lunch / Dinner / Snacks toggles. At least one stays on.
/// Used by onboarding's "Your week" and the You tab's Meals preference.
struct MealTypePicker: View {
    @Binding var selection: Set<MealType>

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(MealType.allCases) { meal in
                MealTypeChip(meal: meal, isOn: selection.contains(meal)) {
                    toggle(meal)
                }
            }
        }
    }

    /// The last meal type can't be switched off.
    private func toggle(_ meal: MealType) {
        if selection.contains(meal) {
            if selection.count > 1 { selection.remove(meal) }
        } else {
            selection.insert(meal)
        }
    }
}

/// A meal toggle chip with its emoji. On: tomato outline and a herb tick.
private struct MealTypeChip: View {
    let meal: MealType
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(meal.emoji)
                Text(meal.title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(isOn ? Theme.tomatoDeep : Theme.aubergine)
                if isOn {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.herb)
                        .transition(.scale(scale: 0.6).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .frame(minHeight: 44)
            .background(Capsule().fill(isOn ? Theme.tomatoSoft : Theme.creamDeep))
            .overlay(Capsule().stroke(isOn ? Theme.tomato : Color.clear, lineWidth: 2))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(Theme.spring, value: isOn)
        .sensoryFeedback(.impact(weight: .light), trigger: isOn)
        .accessibilityLabel(Text(meal.title))
        .accessibilityAddTraits(isOn ? [.isButton, .isSelected] : [.isButton])
    }
}

#Preview {
    MealTypePicker(selection: .constant([.breakfast, .dinner])).padding().creamBackground()
}
