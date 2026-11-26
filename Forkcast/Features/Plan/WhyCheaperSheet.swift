import SwiftUI
import ForkcastCore

/// Explains why the basket total is lower than each meal bought on its own.
struct WhyCheaperSheet: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                HStack(spacing: Theme.Spacing.m) {
                    Image(systemName: "basket.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.tomato)
                        .frame(width: 52, height: 52)
                        .background(Circle().fill(Theme.tomatoSoft))
                    Text("why is the list cheaper than the meals added up?")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.aubergine)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text("Most things come in whole packs: a bag of onions, a tin of tomatoes, a bottle of oil. When you plan the week together, one pack gets used across several meals, so you only buy it once.")
                    .foregroundStyle(Theme.aubergine)
                    .fixedSize(horizontal: false, vertical: true)
                Text("The total on your plan is what the whole list should cost at the till. If you shopped for each meal on its own, you'd buy some of the same packs again, and it would add up to more.")
                    .foregroundStyle(Theme.aubergine)
                    .fixedSize(horizontal: false, vertical: true)
                comparison
                Text("Prices are approximate and vary by shop and season.")
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineFaint)
                PrimaryButton(String(localized: "Got it")) { dismiss() }
            }
            .padding(Theme.Spacing.xl)
        }
        .background(Theme.cream.ignoresSafeArea())
    }

    private var comparison: some View {
        let list: GroceryList = planStore.groceryList
        return VStack(spacing: Theme.Spacing.s) {
            ComparisonRow(label: String(localized: "each meal bought on its own"), value: profileStore.formatMoney(list.standaloneTotal), emphasised: false)
            ComparisonRow(label: String(localized: "your one tidy list"), value: profileStore.formatMoney(list.total), emphasised: true)
            if list.savingsFromSharing > 0.01 {
                HStack {
                    Image(systemName: "sparkles").foregroundStyle(Theme.saffron)
                    Text("about \(profileStore.formatMoney(list.savingsFromSharing)) saved by sharing packs")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                }
                .padding(.top, Theme.Spacing.xs)
            }
        }
        .cardStyle()
    }
}

private struct ComparisonRow: View {
    let label: String
    let value: String
    let emphasised: Bool

    var body: some View {
        HStack {
            Text(label)
                .font(emphasised ? .subheadline.weight(.semibold) : .subheadline)
                .foregroundStyle(emphasised ? Theme.aubergine : Theme.aubergineMuted)
            Spacer()
            Text(value)
                .font(emphasised ? .headline : .subheadline)
                .monospacedDigit()
                .strikethrough(!emphasised, color: Theme.aubergineFaint)
                .foregroundStyle(emphasised ? Theme.aubergine : Theme.aubergineMuted)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview { WhyCheaperSheet().previewEnvironment() }
