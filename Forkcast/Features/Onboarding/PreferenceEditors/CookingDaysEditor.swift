import SwiftUI
import ForkcastCore

/// Seven round day toggles (M T W T F S S).
struct CookingDaysEditor: View {
    @Binding var days: Set<Int>
    /// "5 dinners a week" under the days (off where the screen shows its own line).
    var showsSummary: Bool = true

    private let fullNames: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            HStack(spacing: 6) {
                ForEach(1...7, id: \.self) { day in
                    DayToggle(
                        initial: WeekMath.englishInitials[day - 1],
                        fullName: fullNames[day - 1],
                        isOn: days.contains(day)
                    ) {
                        if days.contains(day) {
                            if days.count > 1 { days.remove(day) }
                        } else {
                            days.insert(day)
                        }
                    }
                }
            }
            if showsSummary {
                Text(summary)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .contentTransition(.numericText())
                    .animation(Theme.spring, value: days.count)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var summary: String {
        days.count == 1 ? String(localized: "1 dinner a week") : String(localized: "\(days.count) dinners a week")
    }
}

private struct DayToggle: View {
    let initial: String
    let fullName: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(initial)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(isOn ? Color.white : Theme.aubergine)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .frame(minWidth: 40, minHeight: 44)
                .background(Circle().fill(isOn ? Theme.tomato : Theme.card))
                .overlay(Circle().stroke(isOn ? Theme.tomato : Theme.line, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isOn)
        .accessibilityLabel(Text(fullName))
        .accessibilityAddTraits(isOn ? [.isButton, .isSelected] : [.isButton])
    }
}

#Preview {
    CookingDaysEditor(days: .constant([1, 2, 3, 4, 5])).padding().creamBackground()
}
