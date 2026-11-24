import SwiftUI

struct GoalsPicker: View {
    @Binding var selection: Set<String>

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            ForEach(OnboardingGoal.allCases) { goal in
                OptionTile(
                    title: goal.title,
                    systemImage: goal.systemImage,
                    isSelected: selection.contains(goal.rawValue)
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
