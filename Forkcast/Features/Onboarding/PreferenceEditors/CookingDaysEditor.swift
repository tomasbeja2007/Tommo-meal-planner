import SwiftUI
import ForkcastCore

/// Seven round day toggles (M T W T F S S).
struct CookingDaysEditor: View {
    @Binding var days: Set<Int>
    /// "5 dinners a week" under the days (off where the screen shows its own line).
    var showsSummary: Bool = true
    var showsConnectors = false
    var prepEdges: Binding<Set<Int>>? = nil

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            VStack(spacing: 0) {
                HStack(spacing: Theme.Spacing.xxs) {
                    ForEach(1...7, id: \.self) { day in
                        DayToggle(
                            initial: String(DateText.isoShortWeekdays[day - 1].prefix(1)),
                            fullName: dayName(day),
                            isOn: days.contains(day)
                        ) {
                            if days.contains(day) {
                                guard days.count > 1 else { return }
                                days.remove(day)
                                if let prepEdges {
                                    prepEdges.wrappedValue.subtract([day - 1, day])
                                }
                            } else {
                                days.insert(day)
                            }
                        }
                    }
                }
                if showsConnectors, let prepEdges {
                    HStack(spacing: 0) {
                        ForEach(1...6, id: \.self) { day in
                            connector(after: day, edges: prepEdges)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.s)
                    .transition(.opacity)
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

    private func dayName(_ day: Int) -> String {
        Calendar.current.weekdaySymbols[day % 7]
    }

    @ViewBuilder
    private func connector(after day: Int, edges: Binding<Set<Int>>) -> some View {
        let linked = edges.wrappedValue.contains(day)
        if days.contains(day), days.contains(day + 1), linked || canJoin(after: day, edges: edges.wrappedValue) {
            Button {
                if linked { edges.wrappedValue.remove(day) }
                else { edges.wrappedValue.insert(day) }
            } label: {
                Image(systemName: linked ? "link" : "plus")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(linked ? Color.white : Theme.tomatoDeep)
                    .frame(width: 27, height: 27)
                    .background(linked ? Theme.tomatoDeep : Theme.tomatoSoft, in: Circle())
                    .contentTransition(reduceMotion ? .identity : .symbolEffect(.replace))
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: linked)
            .sensoryFeedback(.selection, trigger: linked)
            .accessibilityLabel(linked ? Text("Split \(dayName(day)) and \(dayName(day + 1))")
                : Text("Link \(dayName(day)) and \(dayName(day + 1))"))
        } else {
            Color.clear.frame(height: 44).accessibilityHidden(true)
        }
    }

    private func canJoin(after day: Int, edges: Set<Int>) -> Bool {
        var first = day
        while first > 1, edges.contains(first - 1), days.contains(first - 1) { first -= 1 }
        var last = day + 1
        while last < 7, edges.contains(last), days.contains(last + 1) { last += 1 }
        return last - first < 5
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
                .frame(minHeight: 44)
                .background(Circle().fill(isOn ? Theme.tomato : Theme.card))
                .overlay(Circle().stroke(isOn ? Theme.tomato : Theme.line, lineWidth: 1))
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.herb)
                        .background(Theme.card, in: Circle())
                        .opacity(isOn ? 1 : 0)
                        .accessibilityHidden(true)
                }
                .contentShape(Rectangle())
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
