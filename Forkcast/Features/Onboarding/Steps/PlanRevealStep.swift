import SwiftUI
import ForkcastCore

/// A first look at the generated week and the estimated grocery basket.
struct PlanRevealStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @State private var appeared: Bool = false

    private var currency: String { profileStore.currencyCode }

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
                            mealLabel: state.mealTypes == [.dinner] ? nil : meal.mealType.title,
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

    /// "5 dinners · £78.40 · £6.60 under budget" ("15 meals · …" when more than dinners are planned)
    private var summaryRow: some View {
        let difference: Double = planStore.budget - planStore.total
        let budgetText: String = difference >= 0
            ? String(localized: "\(MoneyFormat.string(difference, currencyCode: currency)) under budget")
            : String(localized: "\(MoneyFormat.string(-difference, currencyCode: currency)) over budget")
        return HStack(spacing: Theme.Spacing.s) {
            Text(mealCountText)
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

    private var mealCountText: String {
        let count: Int = planStore.meals.count
        if state.mealTypes == [.dinner] {
            return count == 1 ? String(localized: "1 dinner") : String(localized: "\(count) dinners")
        }
        return count == 1 ? String(localized: "1 meal") : String(localized: "\(count) meals")
    }


}

private struct RevealDayCard: View {
    let date: Date
    /// "Lunch" etc. when the plan has more than dinners.
    let mealLabel: String?
    let recipe: Recipe
    let costText: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text(mealLabel.map { "\(date.formatted(.dateTime.weekday(.abbreviated))) · \($0)" } ?? date.formatted(.dateTime.weekday(.abbreviated)))
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

/// An illustrative savings example. The artwork is animated as a single timeline.
struct SavingsStep: View {
    let onContinue: () -> Void
    @State private var appeared = false

    private let weekly = 20
    private let weeks = 52

    var body: some View {
        OneShotClock(duration: 6_300, play: appeared) { time in
            ScrollView {
                VStack(spacing: Theme.Spacing.m) {
                    MascotReaction(mood: .cheer, size: 112)
                        .opacity(phase(time, from: 3_950, to: 4_400))
                        .scaleEffect(0.8 + 0.2 * phase(time, from: 3_950, to: 4_400))
                    Text("If you save \(money(weekly)) on groceries each week,")
                        .font(.title2.weight(.semibold))
                        .opacity(phase(time, from: 80, to: 490))
                    Text("that's")
                        .font(.title3)
                        .opacity(phase(time, from: 4_000, to: 4_350))
                    annualFigure(at: time)
                    Text("a year")
                        .font(.title2.weight(.semibold))
                        .opacity(phase(time, from: 5_350, to: 5_700))
                }
                .foregroundStyle(Theme.aubergine)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(Theme.Spacing.gutter)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("If you save \(money(weekly)) on groceries each week, that's \(money(weekly * weeks)) a year."))
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: Theme.Spacing.s) {
                    PrimaryButton(String(localized: "Continue"), action: onContinue)
                        .opacity(0.76 + 0.24 * phase(time, from: 5_700, to: 6_300))
                    Text("Example based on saving \(money(weekly)) a week")
                        .font(.footnote)
                        .foregroundStyle(Theme.aubergineMuted)
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.vertical, Theme.Spacing.s)
                .background(Theme.cream)
            }
        }
        .onAppear { appeared = true }
    }

    private func annualFigure(at time: Double) -> some View {
        let reveal = phase(time, from: 4_000, to: 5_000)
        let ring = phase(time, from: 4_200, to: 5_050)
        let value = Int((Double(weekly * weeks) * (1 - pow(1 - reveal, 3))).rounded(.down))
        return Text(money(value))
            .font(.system(.largeTitle, design: .rounded, weight: .black))
            .monospacedDigit()
            .foregroundStyle(Theme.tomatoDeep)
            .padding(.vertical, Theme.Spacing.s)
            .background {
                Circle()
                    .strokeBorder(Theme.tomato.opacity(0.25 * sin(ring * .pi)), lineWidth: 2)
                    .frame(width: 92, height: 92)
                    .scaleEffect(0.55 + ring * 0.8)
                    .accessibilityHidden(true)
            }
            .scaleEffect(1.24 - 0.24 * reveal)
            .opacity(min(1, reveal * 5))
    }

    private func phase(_ time: Double, from start: Double, to end: Double) -> Double {
        min(max((time - start) / (end - start), 0), 1)
    }

    private func money(_ value: Int) -> String {
        value.formatted(.currency(code: "EUR").precision(.fractionLength(0)))
    }
}

struct CatalogPreviewStep: View {
    let onContinue: () -> Void

    private let catalog = FoodCatalog.bundled

    private var recipes: [Recipe] {
        let featuredIDs = ["smash-burger-tacos", "crispy-salmon-rice-bowl", "baked-feta-penne"]
        let featured = featuredIDs.compactMap { catalog.recipe(id: $0) }
        return featured.isEmpty ? Array(catalog.recipes.prefix(3)) : featured
    }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "\(catalog.recipes.count.formatted()) recipes for your week"),
            subtitle: String(localized: "Find meals for your taste, diet and budget."),
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                Capsule().fill(Theme.aubergine)
                    .frame(width: 50, height: 8)
                    .frame(maxWidth: .infinity)
                    .accessibilityHidden(true)
                Text("Meal Plan")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.aubergine)
                HStack {
                    ForEach(Array(DateText.isoShortWeekdays.enumerated()), id: \.offset) { index, day in
                        Text(day.prefix(1))
                            .font(.caption.weight(.bold))
                            .frame(maxWidth: .infinity, minHeight: 28)
                            .foregroundStyle(index == 0 ? Color.white : Theme.aubergineMuted)
                            .background(index == 0 ? Theme.tomatoDeep : Theme.creamDeep, in: Capsule())
                    }
                }
                .accessibilityHidden(true)
                ForEach(recipes) { recipe in
                    RecipeRow(recipe: recipe)
                }
                Divider()
                HStack {
                    Spacer()
                    Image(systemName: "calendar").foregroundStyle(Theme.tomatoDeep)
                    Spacer()
                    Image(systemName: "cart")
                    Spacer()
                    Image(systemName: "book")
                    Spacer()
                    Image(systemName: "person.crop.circle")
                    Spacer()
                }
                .foregroundStyle(Theme.aubergineMuted)
                .accessibilityHidden(true)
            }
            .padding(Theme.Spacing.l)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 32))
            .overlay(RoundedRectangle(cornerRadius: 32).strokeBorder(Theme.aubergine, lineWidth: 3))
            .frame(maxWidth: 350)
            .frame(maxWidth: .infinity)
        }
    }
}
