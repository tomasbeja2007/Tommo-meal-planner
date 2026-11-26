import SwiftUI
import ForkcastCore

/// Approx. total against budget, with status chip and the ⓘ explainer.
struct BudgetCard: View {
    let total: Double
    let budget: Double
    let currencyCode: String
    let onInfo: () -> Void

    private var ratio: Double { budget > 0 ? total / budget : 0 }

    private var barTint: Color {
        if ratio > 1 { return Theme.tomatoDeep }
        if ratio >= 0.9 { return Theme.saffron }
        return Theme.tomato
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            HStack(alignment: .firstTextBaseline) {
                Text("approx. total")
                    .font(.caption.weight(.semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(Theme.aubergineMuted)
                Spacer()
                Button(action: onInfo) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Theme.aubergineMuted)
                        .frame(width: 44, height: 32)
                }
                .accessibilityLabel(Text("Why is the list cheaper than the meals added up?"))
            }
            HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.xs) {
                MoneyText(amount: total, currencyCode: currencyCode, font: .system(size: 34, weight: .bold, design: .rounded), countUp: true)
                    .fixedSize()
                Text("/ \(MoneyFormat.string(budget, currencyCode: currencyCode, fractionDigits: 0))")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergineMuted)
            }
            ProgressBar(value: ratio, tint: barTint, height: 10)
            statusChip
        }
        .cardStyle()
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var statusChip: some View {
        if total <= budget {
            let under: String = MoneyFormat.string(budget - total, currencyCode: currencyCode)
            TagLabel(text: String(localized: "\(under) under budget"), tint: Theme.herb, fill: Theme.herbSoft)
        } else {
            let over: String = MoneyFormat.string(total - budget, currencyCode: currencyCode)
            TagLabel(text: String(localized: "over by \(over)"), tint: Theme.tomatoDeep, fill: Theme.tomatoSoft)
        }
    }
}

/// "Grocery list · 31 items · 0 checked"
struct GroceryShortcutCard: View {
    let itemCount: Int
    let checkedCount: Int
    var estimate: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.m) {
                Image(systemName: "cart.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Theme.tomato))
                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text("Grocery list")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Theme.aubergine)
                    Text("\(itemCount) items · \(checkedCount) checked")
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundStyle(Theme.aubergineMuted)
                    if let estimate {
                        Text("Estimated total: \(estimate)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.tomatoDeep)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.aubergineFaint)
            }
            .cardStyle()
        }
        .buttonStyle(.plain)
        .accessibilityHint(Text("Opens the grocery list"))
    }
}

/// "how was this week?" prompt at the top of the Plan tab.
struct FeedbackPromptCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.m) {
                MascotView(size: 52, mood: .idle)
                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text("how was this week?")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Theme.aubergine)
                    Text("rate your meals and we'll plan next week")
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").foregroundStyle(Theme.tomato)
            }
            .padding(Theme.Spacing.l)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.saffronSoft))
        }
        .buttonStyle(.plain)
    }
}

/// Mascot toast + sparkle burst when the first plan lands.
struct PlanRevealToast: View {
    let name: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            MascotView(size: 56, mood: .cheer)
            Text(name.isEmpty ? String(localized: "your week is ready") : String(localized: "your week is ready, \(name)"))
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.aubergine)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(Theme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                .fill(Theme.card)
                .elevation(Theme.Elevation.lifted)
        )
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.top, Theme.Spacing.s)
        .onTapGesture(perform: onDismiss)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Plan cards") {
    ScrollView {
        VStack(spacing: Theme.Spacing.l) {
            BudgetCard(total: 71.4, budget: 85, currencyCode: "USD") {}
            BudgetCard(total: 89.2, budget: 85, currencyCode: "USD") {}
            GroceryShortcutCard(itemCount: 31, checkedCount: 4) {}
            FeedbackPromptCard {}
            PlanRevealToast(name: "Sam") {}
        }
        .padding()
    }
    .creamBackground()
}
