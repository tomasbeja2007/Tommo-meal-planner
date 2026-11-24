import SwiftUI

struct GoalsPicker: View {
    @Binding var selection: Set<String>
    /// `.grid`: the onboarding's 2-column big tiles. `.row`: the list used in preferences.
    var layout: OptionTile.Layout = .row

    private var columns: [GridItem] {
        let count: Int = layout == .grid ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.m), count: count)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
            ForEach(OnboardingGoal.allCases) { goal in
                OptionTile(
                    title: goal.title,
                    systemImage: goal.systemImage,
                    illustration: "goal-\(goal.rawValue)",
                    isSelected: selection.contains(goal.rawValue),
                    layout: layout,
                    minHeight: layout == .grid ? 140 : 64
                ) {
                    if selection.contains(goal.rawValue) {
                        selection.remove(goal.rawValue)
                    } else {
                        selection.insert(goal.rawValue)
                    }
                }
            }
        }
    }
}

#Preview {
    GoalsPicker(selection: .constant(["spendLess"])).padding().creamBackground()
}
