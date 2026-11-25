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
                    VStack(spacing: Theme.Spacing.xs) {
                        Text(headline)
                            .font(Theme.questionFont)
                            .foregroundStyle(Theme.aubergine)
                            .accessibilityAddTraits(.isHeader)
                        Text(planLine)
                            .font(.subheadline)
                            .foregroundStyle(Theme.aubergineMuted)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    dayStrip
                    budgetCard
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
        let meals = planStore.meals
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: Theme.Spacing.m) {
                ForEach(Array(meals.enumerated()), id: \.offset) { index, meal in
                    if let recipe = repository.recipe(id: meal.recipeId) {
                        RevealDayCard(
                            dayLabel: dayLabel(meal.date),
                            mealLabel: state.mealTypes == [.dinner] ? nil : meal.mealType.title,
                            recipe: recipe,
                            costText: index < planStore.mealCosts.count ? MoneyFormat.string(planStore.mealCosts[index], currencyCode: currency) : nil,
                            leftoversFrom: leftoverSource(of: meal, in: meals),
                            isTonight: Calendar.current.isDateInToday(meal.date),
                            order: index,
                            play: appeared
                        )
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.vertical, Theme.Spacing.xs)
        }
    }

    /// "Tonight", "Tomorrow", then "Fri 28".
    private func dayLabel(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) { return String(localized: "Tonight") }
        if Calendar.current.isDateInTomorrow(date) { return String(localized: "Tomorrow") }
        return date.formatted(.dateTime.weekday(.abbreviated).day())
    }

    /// The weekday a leftovers meal was cooked on ("Wed"), so a repeat reads as a plan, not a glitch.
    private func leftoverSource(of meal: PlannedMeal, in meals: [PlannedMeal]) -> String? {
        guard let id = meal.leftoversFromMealID,
              let source = meals.first(where: { $0.plannerMealID == id }) else { return nil }
        return source.date.formatted(.dateTime.weekday(.abbreviated))
    }

    /// "5 dinners for 2 adults + 1 kid, priced at Lidl"
    private var planLine: String {
        let store = FoodCatalog.bundled.store(id: state.mainStoreId)?.name ?? profileStore.storeName
        let people = state.kids > 0
            ? String(localized: "\(state.adults) adults + \(state.kids) kids")
            : (state.adults == 1 ? String(localized: "1 adult") : String(localized: "\(state.adults) adults"))
        return String(localized: "\(mealCountText) for \(people), priced at \(store)")
    }

    // MARK: Summary

    /// The basket against their budget: a bar that draws on, and what's left over.
    private var budgetCard: some View {
        let budget = planStore.budget
        let total = planStore.total
        let difference = budget - total
        return VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            HStack(alignment: .firstTextBaseline) {
                Text("Your basket")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.aubergineMuted)
                Spacer()
                MoneyText(amount: total, currencyCode: currency,
                          font: .system(.title2, design: .rounded).weight(.bold), prefix: "~", countUp: true)
            }
            ProgressBar(value: budget > 0 ? total / budget : 0, tint: difference >= 0 ? Theme.tomato : Theme.tomatoDeep, height: 10, drawOnDelay: 0.25)
            Text(difference >= 0
                 ? String(localized: "\(MoneyFormat.string(difference, currencyCode: currency)) to spare of your \(MoneyFormat.string(budget, currencyCode: currency, fractionDigits: 0)) budget")
                 : String(localized: "\(MoneyFormat.string(-difference, currencyCode: currency)) over your \(MoneyFormat.string(budget, currencyCode: currency, fractionDigits: 0)) budget"))
                .font(.footnote.weight(.semibold))
                .foregroundStyle(difference >= 0 ? Theme.herb : Theme.tomatoDeep)
        }
        .padding(Theme.Spacing.l)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
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
    /// "Tonight", "Tomorrow", "Fri 28".
    let dayLabel: String
    /// "Lunch" etc. when the plan has more than dinners.
    let mealLabel: String?
    let recipe: Recipe
    let costText: String?
    /// Weekday the leftovers come from ("Wed"), if this meal is leftovers.
    let leftoversFrom: String?
    let isTonight: Bool
    /// Position in the strip: cards deal in one after another, 70 ms apart.
    let order: Int
    let play: Bool

    var body: some View {
        OneShotClock(duration: 520 + Double(min(order, 6)) * 70, play: play) { t in
            let start = 120 + Double(min(order, 6)) * 70
            let p = seg(t, start, start + 400)
            card
                .opacity(p)
                .offset(y: 18 * (1 - p))
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            HStack(spacing: 4) {
                Text(mealLabel.map { "\(dayLabel) · \($0)" } ?? dayLabel)
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .textCase(.uppercase)
                    .foregroundStyle(isTonight ? Color.white : Theme.tomatoDeep)
                    .padding(.horizontal, isTonight ? 8 : 0)
                    .padding(.vertical, isTonight ? 3 : 0)
                    .background { if isTonight { Capsule().fill(Theme.tomatoDeep) } }
            }
            DishTileView(recipe: recipe, size: 128, height: 112, cornerRadius: 14)
                .overlay(alignment: .topLeading) {
                    if let leftoversFrom {
                        Label("Leftovers from \(leftoversFrom)", systemImage: "arrow.uturn.backward")
                            .font(.caption2.weight(.bold))
                            .labelStyle(CompactLabelStyle())
                            .foregroundStyle(Theme.aubergine)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Theme.card.opacity(0.92)))
                            .padding(6)
                    }
                }
            Text(recipe.title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(2, reservesSpace: true)
            HStack(spacing: Theme.Spacing.s) {
                Label("\(recipe.totalMinutes) min", systemImage: "clock")
                if let costText {
                    Text(leftoversFrom == nil ? costText : String(localized: "cooked already"))
                }
            }
            .font(.caption.weight(.semibold))
            .labelStyle(CompactLabelStyle())
            .monospacedDigit()
            .foregroundStyle(Theme.aubergineMuted)
            .lineLimit(1)
        }
        .frame(width: 128)
        .padding(Theme.Spacing.m)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
        .overlay {
            if isTonight {
                RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                    .strokeBorder(Theme.tomato.opacity(0.35), lineWidth: 1.5)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PlanRevealStep(state: OnboardingState()) {}.previewEnvironment().creamBackground()
}

/// An illustrative savings example in the user's own currency, drawn as their next year:
/// 52 squares, one per week, filling in while the yearly figure counts up. One timeline (1.9 s).
struct SavingsStep: View {
    let state: OnboardingState
    let onContinue: () -> Void
    @State private var appeared = false

    private let weekly = 20
    private let weeks = 52
    private var currency: String { state.country(in: FoodCatalog.bundled).currencyCode }

    /// Grid timing (ms): the squares fill alongside the count-up.
    private let fillStart: Double = 560
    private let fillStagger: Double = 14
    private let fillMs: Double = 240

    var body: some View {
        OneShotClock(duration: 1_900, play: appeared) { time in
            ScrollView {
                VStack(spacing: Theme.Spacing.m) {
                    MascotReaction(mood: .cheer, size: 104)
                        .opacity(phase(time, from: 0, to: 260))
                        .scaleEffect(0.9 + 0.1 * seg(phase(time, from: 0, to: 420), 0, 1))
                    VStack(spacing: Theme.Spacing.xs) {
                        Text("If you save \(money(weekly)) on groceries each week,")
                            .font(.title2.weight(.semibold))
                            .opacity(phase(time, from: 80, to: 380))
                            .offset(y: 10 * (1 - phase(time, from: 80, to: 380)))
                        Text("that's")
                            .font(.title3)
                            .foregroundStyle(Theme.aubergineMuted)
                            .opacity(phase(time, from: 420, to: 640))
                        annualFigure(at: time)
                        Text("a year")
                            .font(.title2.weight(.semibold))
                            .opacity(phase(time, from: 1_300, to: 1_560))
                    }
                    yearGrid(at: time)
                        .padding(.top, Theme.Spacing.s)
                }
                .foregroundStyle(Theme.aubergine)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(Theme.Spacing.gutter)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("If you save \(money(weekly)) on groceries each week, that's \(money(weekly * weeks)) a year."))
            }
            .scrollBounceBehavior(.basedOnSize)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: Theme.Spacing.s) {
                    PrimaryButton(String(localized: "Continue"), action: onContinue)
                        .opacity(0.76 + 0.24 * phase(time, from: 1_400, to: 1_900))
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

    /// The next 52 weeks from today, 13 across: each square opens from 60% (never 0) and turns tomato.
    private func yearGrid(at time: Double) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 13)
        let today = Date()
        let end = Calendar.current.date(byAdding: .weekOfYear, value: weeks - 1, to: today) ?? today
        return VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(0..<weeks, id: \.self) { week in
                    let start = fillStart + Double(week) * fillStagger
                    let fill = seg(time, start, start + fillMs)
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Theme.creamDeep)
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(week == 0 ? Theme.tomatoDeep : Theme.tomato)
                            .scaleEffect(0.6 + 0.4 * fill)
                            .opacity(fill)
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            HStack {
                Text("This week")
                Spacer()
                Text(end.formatted(.dateTime.month(.abbreviated).year()))
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(Theme.aubergineMuted)
        }
        .padding(Theme.Spacing.l)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
        .opacity(phase(time, from: 380, to: 620))
        .offset(y: 12 * (1 - seg(phase(time, from: 380, to: 760), 0, 1)))
    }

    private func annualFigure(at time: Double) -> some View {
        let reveal = phase(time, from: 560, to: 1_400)
        let ring = phase(time, from: 700, to: 1_500)
        let value = Int((Double(weekly * weeks) * (1 - pow(1 - reveal, 3))).rounded(.down))
        return Text(money(value))
            .font(.system(size: 52, weight: .black, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(Theme.tomatoDeep)
            .padding(.vertical, Theme.Spacing.xs)
            .background {
                Circle()
                    .strokeBorder(Theme.tomato.opacity(0.25 * sin(ring * .pi)), lineWidth: 2)
                    .frame(width: 92, height: 92)
                    .scaleEffect(0.55 + ring * 0.8)
                    .accessibilityHidden(true)
            }
            .scaleEffect(1.12 - 0.12 * seg(reveal, 0, 1))
            .opacity(min(1, reveal * 5))
    }

    private func phase(_ time: Double, from start: Double, to end: Double) -> Double {
        min(max((time - start) / (end - start), 0), 1)
    }

    private func money(_ value: Int) -> String {
        value.formatted(.currency(code: currency).precision(.fractionLength(0)))
    }
}

/// "312 recipes fit you": the real catalog run through the user's own rules (allergens, diet,
/// dislikes, kitchen, meal types), shown as two slow rivers of their dishes and three honest counts.
struct CatalogPreviewStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    private let total: Int
    private let fit: [Recipe]
    private let rows: [[Recipe]]

    init(state: OnboardingState, onContinue: @escaping () -> Void) {
        self.state = state
        self.onContinue = onContinue
        let catalog = FoodCatalog.bundled
        let profile = PlannerProfile(allergens: state.effectiveAllergens, diet: state.diet, dislikes: state.dislikes,
                                     appliances: state.appliances, vibes: state.vibes)
        let meals = catalog.recipes.filter { state.mealTypes.contains($0.mealType) }
        let fit = MealPlanner(catalog: catalog).safeRecipes(from: meals, profile: profile)
        self.total = meals.count
        self.fit = fit
        // Dishes that match their vibes first, then the rest; photos only, so the rivers look real.
        let withPhotos = fit.filter { AssetImage.exists("recipe-\($0.id)") || $0.imageName.map(AssetImage.exists) == true }
        let pool = (withPhotos.count >= 12 ? withPhotos : fit)
            .sorted { Set($0.vibes).intersection(state.vibes).count > Set($1.vibes).intersection(state.vibes).count }
        let picked = Array(pool.prefix(16))
        self.rows = [picked.enumerated().filter { $0.offset % 2 == 0 }.map(\.element),
                     picked.enumerated().filter { $0.offset % 2 == 1 }.map(\.element)]
    }

    private var quick: Int { fit.filter { $0.totalMinutes <= 20 }.count }
    private var leftovers: Int { fit.filter(\.isLeftoverFriendly).count }
    private var vibeMatches: Int { fit.filter { !Set($0.vibes).isDisjoint(with: state.vibes) }.count }
    private var cuisines: Int { Set(fit.map(\.cuisine)).count }

    /// "Filtered for vegetarian, no peanuts, oven + stovetop"
    private var subtitle: String {
        var parts: [String] = []
        if state.diet != .none { parts.append(state.diet.displayName.lowercased()) }
        let allergens = Allergen.allCases.filter { state.effectiveAllergens.contains($0) }.prefix(2).map { $0.displayName.lowercased() }
        parts += allergens.map { String(localized: "no \($0)") }
        if state.appliances.count < Appliance.allCases.count {
            parts.append(Appliance.allCases.filter { state.appliances.contains($0) }.map { $0.displayName.lowercased() }.joined(separator: " + "))
        }
        if parts.isEmpty { return String(localized: "Out of \(total.formatted()), every one checked against your answers.") }
        return String(localized: "Out of \(total.formatted()), filtered for \(parts.formatted(.list(type: .and))).")
    }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "\(fit.count.formatted()) recipes fit you"),
            subtitle: subtitle,
            onContinue: onContinue
        ) {
            VStack(spacing: Theme.Spacing.l) {
                DishRivers(rows: rows)
                    .padding(.horizontal, -Theme.Spacing.gutter)
                CountUpStats(stats: [
                    (quick, String(localized: "ready in 20 min")),
                    state.vibes.isEmpty ? (cuisines, String(localized: "cuisines")) : (vibeMatches, String(localized: "match your vibes")),
                    (leftovers, String(localized: "great as leftovers"))
                ])
            }
        }
    }
}

/// Two rows of dish photos drifting slowly in opposite directions (linear, endless, seamless),
/// faded at the edges. Reduce Motion: they rest.
private struct DishRivers: View {
    let rows: [[Recipe]]
    private let tile: CGFloat = 104
    private let gap: CGFloat = 10
    private let period: Double = 60_000
    @State private var visible = false

    var body: some View {
        LoopClock(period: period, paused: !visible) { t in
            VStack(spacing: gap) {
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    let width = CGFloat(row.count) * (tile + gap)
                    let p = CGFloat(loop(t, period: period, phase: index == 0 ? 0 : 0.5))
                    let x = index == 0 ? -p * width : (p - 1) * width
                    HStack(spacing: gap) {
                        ForEach(0..<3, id: \.self) { _ in
                            ForEach(row) { recipe in
                                DishTileView(recipe: recipe, size: tile, cornerRadius: 22)
                                    .shadow(color: Theme.aubergine.opacity(0.08), radius: 6, y: 4)
                            }
                        }
                    }
                    .offset(x: x)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical, 8)
        }
        .frame(height: tile * 2 + gap + 16)
        .clipped()
        .mask(LinearGradient(stops: [.init(color: .clear, location: 0), .init(color: .black, location: 0.1),
                                     .init(color: .black, location: 0.9), .init(color: .clear, location: 1)],
                             startPoint: .leading, endPoint: .trailing))
        .onAppear { visible = true }
        .onDisappear { visible = false }
        .accessibilityHidden(true)
    }
}

/// Three stat tiles whose numbers count up once with ease-out, staggered 80 ms.
private struct CountUpStats: View {
    let stats: [(Int, String)]
    @State private var play = false

    var body: some View {
        OneShotClock(duration: 1_100, play: play) { t in
            HStack(spacing: Theme.Spacing.s) {
                ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                    let p = seg(t, 150 + Double(index) * 80, 900 + Double(index) * 80)
                    StatTile(value: Int((Double(stat.0) * p).rounded()).formatted(), label: stat.1)
                        .opacity(seg(t, Double(index) * 80, 300 + Double(index) * 80))
                }
            }
        }
        .onAppear { play = true }
    }
}
