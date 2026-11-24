import SwiftUI
import ForkcastCore

/// 14. The hero moment: Chef Tomato cheers, confetti, a success haptic, and THEIR week as a strip
/// of day cards (real picks from the planner, with photos and each meal's share of the basket).
/// Then the honest yearly savings estimate counts up.
struct PlanRevealStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @State private var appeared: Bool = false

    private var country: Country { state.country(in: .bundled) }
    private var currency: String { profileStore.currencyCode }

    private var yearlySavings: Double {
        BudgetMath.estimatedSavings(
            budget: state.budget,
            portions: state.portions,
            days: state.dinnersPerWeek,
            region: country.regionPriceKey,
            multiplier: country.priceMultiplier
        ).yearly
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    MascotView(size: 130, mood: .cheer)
                        .padding(.top, Theme.Spacing.l)
                    Text(headline)
                        .font(Theme.questionFont)
                        .foregroundStyle(Theme.aubergine)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                        .padding(.horizontal, Theme.Spacing.gutter)
                    dayStrip
                    summaryRow
                        .padding(.horizontal, Theme.Spacing.gutter)
                    savings
                        .padding(.horizontal, Theme.Spacing.gutter)
                }
                .padding(.bottom, Theme.Spacing.xxl)
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(String(localized: "Keep my plan"), action: onContinue)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .padding(.vertical, Theme.Spacing.s)
                    .background(Theme.cream.opacity(0.97).ignoresSafeArea())
            }
            ConfettiView(play: appeared)
                .ignoresSafeArea()
        }
        .sensoryFeedback(.success, trigger: appeared)
        .onAppear { appeared = true }
    }

    private var headline: String {
        let name: String = profileStore.name
        return name.isEmpty ? String(localized: "here's your week") : String(localized: "\(name), here's your week")
    }

    // MARK: Day cards

    private var dayStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.m) {
                ForEach(Array(planStore.meals.enumerated()), id: \.offset) { index, meal in
                    if let recipe = repository.recipe(id: meal.recipeId) {
                        RevealDayCard(
                            date: meal.date,
                            recipe: recipe,
                            costText: index < planStore.mealCosts.count ? MoneyFormat.string(planStore.mealCosts[index], currencyCode: currency) : nil
                        )
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.vertical, Theme.Spacing.xs)
        }
    }

    // MARK: Summary

    /// "5 dinners · £78.40 · £6.60 under budget"
    private var summaryRow: some View {
        let difference: Double = planStore.budget - planStore.total
        let budgetText: String = difference >= 0
            ? String(localized: "\(MoneyFormat.string(difference, currencyCode: currency)) under budget")
            : String(localized: "\(MoneyFormat.string(-difference, currencyCode: currency)) over budget")
        return HStack(spacing: Theme.Spacing.s) {
            Text(planStore.meals.count == 1 ? String(localized: "1 dinner") : String(localized: "\(planStore.meals.count) dinners"))
            Text(verbatim: "·").foregroundStyle(Theme.aubergineFaint)
            Text(MoneyFormat.string(planStore.total, currencyCode: currency))
            Text(verbatim: "·").foregroundStyle(Theme.aubergineFaint)
            Text(budgetText)
                .foregroundStyle(difference >= 0 ? Theme.herb : Theme.tomatoDeep)
        }
        .font(.system(.subheadline, design: .rounded).weight(.bold))
        .foregroundStyle(Theme.aubergine)
        .monospacedDigit()
        .lineLimit(1)
        .minimumScaleFactor(0.75)
        .padding(.horizontal, Theme.Spacing.l)
        .padding(.vertical, Theme.Spacing.m)
        .background(Capsule().fill(Theme.card))
        .accessibilityElement(children: .combine)
    }

    // MARK: Savings

    private var savings: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text("That's about")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
            MoneyText(amount: yearlySavings, currencyCode: currency, font: .system(size: 44, weight: .heavy, design: .rounded), color: Theme.tomato, countUp: true, fractionDigits: 0)
                .frame(height: 54)
            Text("a year back in your pocket.")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
            Text("Estimate based on your budget and household.")
                .font(.caption)
                .foregroundStyle(Theme.aubergineFaint)
                .padding(.top, Theme.Spacing.xs)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.l)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.saffronSoft))
    }
}

private struct RevealDayCard: View {
    let date: Date
    let recipe: Recipe
    let costText: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.system(.caption, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.tomatoDeep)
                .textCase(.uppercase)
            DishTileView(recipe: recipe, size: 128, height: 112, cornerRadius: 14)
            Text(recipe.title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(2, reservesSpace: true)
            if let costText {
                Text(costText)
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergineMuted)
            }
        }
        .frame(width: 128)
        .padding(Theme.Spacing.m)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PlanRevealStep(state: OnboardingState()) {}.previewEnvironment().creamBackground()
}
