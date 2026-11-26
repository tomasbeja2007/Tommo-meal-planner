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
    /// Shown as a context chip when known (Profile).
    var storeName: String? = nil
    var onUserChange: (() -> Void)? = nil
    @State private var isTypingAmount = false
    @State private var typedAmount = ""

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
            // What the budget covers, as small chips: days, meals, servings, shop.
            FlowLayout(spacing: Theme.Spacing.inline) {
                ForEach(contextChips, id: \.self) { chip in
                    Text(chip)
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergineMuted)
                        .padding(.horizontal, Theme.Spacing.s)
                        .padding(.vertical, Theme.Spacing.xs)
                        .overlay(Capsule().stroke(Theme.line, lineWidth: 1))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)

            HStack(spacing: Theme.Spacing.m) {
                stepButton(systemImage: "minus", delta: -BudgetMath.step(region: country.regionPriceKey))
                Button {
                    typedAmount = String(Int(budget.rounded()))
                    isTypingAmount = true
                } label: {
                    VStack(spacing: Theme.Spacing.xxs) {
                        HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.xs) {
                            Text(MoneyFormat.string(budget, currencyCode: country.currencyCode, fractionDigits: 0))
                                .font(.system(size: 56, weight: .heavy, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(Theme.aubergine)
                                .contentTransition(.numericText(value: budget))
                                .animation(Theme.spring, value: budget)
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                            Image(systemName: "pencil")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.aubergineFaint)
                        }
                        Text("per week")
                            .font(.subheadline)
                            .foregroundStyle(Theme.aubergineFaint)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Weekly budget \(MoneyFormat.string(budget, currencyCode: country.currencyCode, fractionDigits: 0)) per week"))
                .accessibilityHint(Text("Double tap to type an amount"))
                stepButton(systemImage: "plus", delta: BudgetMath.step(region: country.regionPriceKey))
            }
            .alert(String(localized: "Weekly budget"), isPresented: $isTypingAmount) {
                TextField(String(localized: "Amount"), text: $typedAmount)
                    .keyboardType(.numberPad)
                Button(String(localized: "Set")) {
                    if let value = Double(typedAmount.filter(\.isNumber)) { setBudget(value) }
                }
                Button(String(localized: "Cancel"), role: .cancel) {}
            } message: {
                Text("Between \(MoneyFormat.string(range.lowerBound, currencyCode: country.currencyCode, fractionDigits: 0)) and \(MoneyFormat.string(range.upperBound, currencyCode: country.currencyCode, fractionDigits: 0)).")
            }

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

    private var contextChips: [String] {
        let portionsText: String = FractionFormatter.string(portions)
        var chips: [String] = [
            String(localized: "\(max(1, days)) days"),
            MealType.ordered(mealTypes).map { $0.title }.joined(separator: ", "),
            portions == 1 ? String(localized: "1 serving") : String(localized: "\(portionsText) servings")
        ]
        if let storeName, !storeName.isEmpty { chips.append(storeName) }
        return chips
    }

    private func setBudget(_ value: Double) {
        let clamped = min(max(value, range.lowerBound), range.upperBound)
        guard clamped != budget else { return }
        budget = clamped
        sliderTick += 1
        onUserChange?()
    }

    /// − (outlined) and + (filled) on either side of the amount.
    private func stepButton(systemImage: String, delta: Double) -> some View {
        let enabled = delta > 0 ? budget < range.upperBound : budget > range.lowerBound
        let isPlus = delta > 0
        return Button { setBudget(budget + delta) } label: {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(isPlus ? Color.white : Theme.aubergine)
                .frame(width: 52, height: 52)
                .background(Circle().fill(isPlus ? Theme.aubergine : Theme.card))
                .overlay(Circle().stroke(isPlus ? Color.clear : Theme.line, lineWidth: 1))
                .opacity(enabled ? 1 : 0.4)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(isPlus ? Text("Increase budget") : Text("Decrease budget"))
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
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
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
        VStack(spacing: Theme.Spacing.xxs) {
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
