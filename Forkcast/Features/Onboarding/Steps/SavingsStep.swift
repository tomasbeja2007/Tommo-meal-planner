import SwiftUI
import ForkcastCore

/// Honest savings estimate computed from the user's own answers.
struct SavingsStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    private var country: Country { state.country(in: FoodCatalog.bundled) }

    private var savings: (weekly: Double, yearly: Double) {
        BudgetMath.estimatedSavings(
            budget: state.budget,
            portions: state.portions,
            days: state.cookingDays.count,
            region: country.regionPriceKey,
            multiplier: country.priceMultiplier
        )
    }

    var body: some View {
        let weekly: Double = savings.weekly
        let digits: Int = weekly == weekly.rounded() ? 0 : 2
        VStack(spacing: Theme.Spacing.xl) {
            Spacer(minLength: Theme.Spacing.m)
            MascotView(size: 160, mood: .cheer)
            VStack(spacing: Theme.Spacing.s) {
                Text("planning ahead could save you about")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                MoneyText(amount: weekly, currencyCode: country.currencyCode, font: .system(size: 60, weight: .heavy, design: .rounded), color: Theme.tomato, countUp: true, fractionDigits: digits)
                    .frame(height: 72)
                Text("a week")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.aubergineMuted)
                Text("that's about \(MoneyFormat.string(savings.yearly, currencyCode: country.currencyCode, fractionDigits: 0)) a year")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .padding(.top, Theme.Spacing.s)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            Spacer()
            VStack(spacing: Theme.Spacing.s) {
                Text("estimate based on your answers")
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineFaint)
                PrimaryButton(String(localized: "Continue"), action: onContinue)
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.bottom, Theme.Spacing.m)
        }
    }
}

#Preview { SavingsStep(state: OnboardingState()) {}.creamBackground() }
