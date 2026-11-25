import SwiftUI
import ForkcastCore

/// Big animated currency number, slider, live verdict card and stat tiles.
struct BudgetEditor: View {
    @Binding var budget: Double
    @State private var sliderTick = 0
    let country: Country
    let portions: Double
    let days: Int
    /// Meal types planned on each day (dinner only by default).
    var mealTypes: Set<MealType> = [.dinner]
    var onUserChange: (() -> Void)? = nil

    private var range: ClosedRange<Double> {
        BudgetMath.range(region: country.regionPriceKey, portions: portions, days: days, multiplier: country.priceMultiplier, mealTypes: mealTypes)
    }

    private var verdict: BudgetMath.Verdict {
        BudgetMath.verdict(budget: budget, portions: portions, days: days, region: country.regionPriceKey, multiplier: country.priceMultiplier, mealTypes: mealTypes)
    }

    private var perServing: Double {
        BudgetMath.costPerServing(budget: budget, portions: portions, days: days, mealTypes: mealTypes)
    }

    private var mealsPerWeek: Int { max(1, days) * MealType.ordered(mealTypes).count }

    private var servingsPerWeek: Int {
        Int((portions * Double(mealsPerWeek)).rounded())
    }

    private var isDinnersOnly: Bool { mealTypes == [.dinner] }

    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            Text(householdSummary)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.aubergineMuted)
                .frame(maxWidth: .infinity)
            VStack(spacing: 2) {
                Text(MoneyFormat.string(budget, currencyCode: country.currencyCode, fractionDigits: 0))
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergine)
                    .contentTransition(.numericText(value: budget))
                    .animation(Theme.spring, value: budget)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text("per week")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineFaint)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .combine)

            VStack(spacing: Theme.Spacing.xs) {
                Slider(value: sliderBinding, in: range, step: BudgetMath.step(region: country.regionPriceKey))
                    .tint(Theme.tomato)
                    .sensoryFeedback(.selection, trigger: sliderTick)
                    .accessibilityLabel(Text("Weekly budget"))
                    .accessibilityValue(Text(MoneyFormat.string(budget, currencyCode: country.currencyCode, fractionDigits: 0)))
                HStack {
                    Text(MoneyFormat.string(range.lowerBound, currencyCode: country.currencyCode, fractionDigits: 0))
                    Spacer()
                    Text(MoneyFormat.string(range.upperBound, currencyCode: country.currencyCode, fractionDigits: 0))
                }
                .font(.caption)
                .monospacedDigit()
                .foregroundStyle(Theme.aubergineFaint)
            }

            VerdictCard(verdict: verdict, perServingText: MoneyFormat.string(perServing, currencyCode: country.currencyCode))
                .animation(Theme.spring, value: verdict)

            HStack(spacing: Theme.Spacing.s) {
                StatTile(value: MoneyFormat.string(perServing, currencyCode: country.currencyCode), label: String(localized: "per serving"))
                StatTile(value: "\(servingsPerWeek)", label: String(localized: "servings a week"))
                StatTile(value: "\(mealsPerWeek)", label: isDinnersOnly ? String(localized: "dinners") : String(localized: "meals"))
            }
            if let note = country.priceNote {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineFaint)
            }
        }
    }

    private var sliderBinding: Binding<Double> {
        Binding<Double>(
            get: { min(max(budget, range.lowerBound), range.upperBound) },
            set: { newValue in
                guard newValue != budget else { return }
                budget = newValue
                sliderTick += 1
                onUserChange?()
            }
        )
    }

    private var householdSummary: String {
        let portionsText: String = FractionFormatter.string(portions)
        return isDinnersOnly
            ? String(localized: "\(portionsText) portions · \(days) dinners a week")
            : String(localized: "\(portionsText) portions · \(mealsPerWeek) meals a week")
    }
}

private struct VerdictCard: View {
    let verdict: BudgetMath.Verdict
    let perServingText: String

    private var tint: Color { verdict == .tight ? Theme.saffron : Theme.herb }
    private var fill: Color { verdict == .tight ? Theme.saffronSoft : Theme.herbSoft }

    private var message: String {
        switch verdict {
        case .tight:
            return String(localized: "About \(perServingText) a serving. We'll lean on beans, eggs and pasta, and keep repeats low.")
        case .comfortable:
            return String(localized: "About \(perServingText) a serving. Room for a good mix, with a few treats.")
        case .plenty:
            return String(localized: "About \(perServingText) a serving. Lots of choice. We'll still find you savings.")
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            Image(systemName: verdict == .tight ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 4) {
                Text(verdict.title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(verdict == .tight ? Theme.aubergine : Theme.herb)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(Theme.Spacing.l)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(fill))
        .accessibilityElement(children: .combine)
    }
}

struct StatTile: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .monospacedDigit()
                .foregroundStyle(Theme.aubergine)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.aubergineMuted)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, Theme.Spacing.m)
        .padding(.horizontal, Theme.Spacing.xs)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(Theme.card))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    BudgetEditor(budget: .constant(60), country: FoodCatalog.bundled.defaultCountry, portions: 2.5, days: 5)
        .padding()
        .creamBackground()
}
