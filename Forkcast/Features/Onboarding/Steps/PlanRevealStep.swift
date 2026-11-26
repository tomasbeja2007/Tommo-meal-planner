import SwiftUI
import StoreKit
import ForkcastCore

/// A first look at the generated week and the estimated grocery basket.
struct PlanRevealStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @State private var appeared: Bool = false
    /// Ask for a rating once, at the happiest moment of onboarding (the week just landed). The system
    /// decides whether the prompt actually shows; we never gate anything on it.

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

    /// One card per day: the day's dinner as the hero (or its first meal), the rest of the day as small
    /// photos underneath, and the day's cost.
    private var dayStrip: some View {
        let meals = planStore.meals
        let calendar = Calendar.current
        var days: [(date: Date, items: [(meal: PlannedMeal, recipe: Recipe, cost: Double)])] = []
        for (index, meal) in meals.enumerated() where !meal.isSide {
            guard let recipe = repository.recipe(id: meal.recipeId) else { continue }
            let cost = index < planStore.mealCosts.count ? planStore.mealCosts[index] : 0
            if let last = days.indices.last, calendar.isDate(days[last].date, inSameDayAs: meal.date) {
                days[last].items.append((meal, recipe, cost))
            } else {
                days.append((meal.date, [(meal, recipe, cost)]))
            }
        }
        let dinnersOnly = state.mealTypes == [.dinner]
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: Theme.Spacing.m) {
                ForEach(Array(days.enumerated()), id: \.offset) { order, day in
                    let hero = day.items.first(where: { $0.meal.mealType == .dinner }) ?? day.items[0]
                    let others = day.items.filter { $0.meal !== hero.meal }
                    RevealDayCard(
                        dayLabel: dayLabel(day.date, dinnersOnly: dinnersOnly),
                        isToday: calendar.isDateInToday(day.date),
                        recipe: hero.recipe,
                        heroMeal: dinnersOnly ? nil : hero.meal.mealType.title,
                        others: others.map(\.recipe),
                        otherMeals: others.map { $0.meal.mealType.noun },
                        costText: MoneyFormat.string(day.items.reduce(0) { $0 + $1.cost }, currencyCode: currency),
                        leftoversFrom: leftoverSource(of: hero.meal, in: meals),
                        order: order,
                        play: appeared
                    )
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.vertical, Theme.Spacing.xs)
        }
    }

    /// "Tonight" (dinners-only plans) or "Today", then "Tomorrow", then "Fri 28".
    private func dayLabel(_ date: Date, dinnersOnly: Bool) -> String {
        if Calendar.current.isDateInToday(date) { return dinnersOnly ? String(localized: "Tonight") : String(localized: "Today") }
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
    /// "Today", "Tomorrow", "Fri 28" ("Tonight" on dinners-only plans).
    let dayLabel: String
    let isToday: Bool
    let recipe: Recipe
    /// "Dinner" when the plan has more than dinners.
    let heroMeal: String?
    /// The rest of the day (breakfast, lunch, snack) as small photos.
    let others: [Recipe]
    let otherMeals: [String]
    /// The whole day's cost.
    let costText: String
    /// Weekday the leftovers come from ("Wed"), if the hero is leftovers.
    let leftoversFrom: String?
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
            Text(dayLabel)
                .font(.system(.caption, design: .rounded).weight(.bold))
                .textCase(.uppercase)
                .lineLimit(1)
                .foregroundStyle(isToday ? Color.white : Theme.tomatoDeep)
                .padding(.horizontal, isToday ? 8 : 0)
                .padding(.vertical, isToday ? 3 : 0)
                .background { if isToday { Capsule().fill(Theme.tomatoDeep) } }
            DishTileView(recipe: recipe, size: 136, height: 112, cornerRadius: Theme.Radius.medium)
                .overlay(alignment: .topLeading) {
                    if let leftoversFrom {
                        Label("Leftovers from \(leftoversFrom)", systemImage: "arrow.uturn.backward")
                            .font(.caption2.weight(.bold))
                            .labelStyle(CompactLabelStyle())
                            .foregroundStyle(Theme.aubergine)
                            .padding(.horizontal, Theme.Spacing.s)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(Capsule().fill(Theme.card.opacity(0.92)))
                            .padding(Theme.Spacing.inline)
                    }
                }
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                if let heroMeal {
                    Text(heroMeal)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.aubergineMuted)
                }
                Text(recipe.title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .lineLimit(2, reservesSpace: true)
            }
            if !others.isEmpty {
                HStack(spacing: Theme.Spacing.inline) {
                    HStack(spacing: -Theme.Spacing.inline) {
                        ForEach(Array(others.prefix(3).enumerated()), id: \.offset) { _, other in
                            DishTileView(recipe: other, size: 24)
                                .clipShape(Circle())
                                .overlay(Circle().strokeBorder(Theme.card, lineWidth: 1.5))
                        }
                    }
                    Text("+ \(otherMeals.formatted(.list(type: .and)))")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Theme.aubergineMuted)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            HStack(spacing: Theme.Spacing.s) {
                Label { Text("\(recipe.totalMinutes) min") } icon: { Glyph(name: "glyph-time", size: 13) }
                Text(leftoversFrom == nil || !others.isEmpty ? costText : String(localized: "cooked already"))
            }
            .font(.caption.weight(.semibold))
            .labelStyle(CompactLabelStyle())
            .monospacedDigit()
            .foregroundStyle(Theme.aubergineMuted)
            .lineLimit(1)
        }
        .frame(width: 136)
        .padding(Theme.Spacing.m)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
        .overlay {
            if isToday {
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

/// The savings moment, in the reference choreography the owner picked, with the yearly total as the
/// "wow": Chef Tommo hops in alone, "you could save around" fades up, the weekly amount rises in, then the
/// yearly figure counts up big (with ticking haptics), lands with a pop, a burst of sparks, a warm glow and
/// confetti. The amount is an example worked out from the user's own weekly budget (`savingsShare` of it,
/// in their currency), and the footnote shows that maths, so it is never a fixed figure or a promise
/// (App Review 2.3.1: no unsubstantiated claims).
/// One timeline (ms): 0 mascot · 300 line · 900 weekly · 1 700–2 900 count-up · 2 900 land · 3 700 end.
struct SavingsStep: View {
    let state: OnboardingState
    let onContinue: () -> Void
    @State private var appeared = false
    @State private var weeklyLanded = false
    @State private var countTicks = 0
    @State private var yearLanded = false

    /// Share of the weekly budget used for the example (planning ahead, one combined list, fewer top-up trips).
    private let savingsShare = 0.15
    private let weeks = 52
    /// The example weekly saving: a share of the budget the user just set, rounded to whole currency units.
    private var weekly: Int { max(1, Int((state.budget * savingsShare).rounded())) }
    private var sharePercent: Int { Int((savingsShare * 100).rounded()) }
    private var currency: String { state.country(in: FoodCatalog.bundled).currencyCode }

    private enum Beat {
        static let line: Double = 300
        static let weekly: Double = 900
        static let that: Double = 1_550
        static let countFrom: Double = 1_700
        static let land: Double = 2_900
        static let end: Double = 3_700
    }

    var body: some View {
        ZStack {
            OneShotClock(duration: Beat.end, play: appeared) { t in
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    VStack(spacing: Theme.Spacing.m) {
                        MascotView(size: 104, mood: .cheer)
                            .scaleEffect(0.88 + 0.12 * seg(t, 0, 380))
                            .opacity(seg(t, 0, 220))
                        Text("you could save around")
                            .font(.system(.title3, design: .rounded).weight(.bold))
                            .foregroundStyle(Theme.aubergine)
                            .opacity(seg(t, Beat.line, Beat.line + 300))
                            .offset(y: 8 * (1 - seg(t, Beat.line, Beat.line + 300)))
                        Text("\(money(weekly)) every week")
                            .font(.system(.title, design: .rounded).weight(.heavy))
                            .foregroundStyle(Theme.tomatoDeep)
                            .scaleEffect(0.92 + 0.08 * seg(t, Beat.weekly, Beat.weekly + 380))
                            .opacity(seg(t, Beat.weekly, Beat.weekly + 260))
                            .offset(y: 12 * (1 - seg(t, Beat.weekly, Beat.weekly + 380)))
                        Text("that's")
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(Theme.aubergineMuted)
                            .opacity(seg(t, Beat.that, Beat.that + 250))
                            .padding(.top, Theme.Spacing.s)
                        yearly(t)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    Spacer(minLength: 0)
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("You could save around \(money(weekly)) every week. That's \(money(weekly * weeks)) a year."))
                .safeAreaInset(edge: .bottom) {
                    VStack(spacing: Theme.Spacing.s) {
                        PrimaryButton(String(localized: "Continue"), action: onContinue)
                            .opacity(0.76 + 0.24 * seg(t, Beat.land, Beat.end))
                        Text("Example: saving \(sharePercent)% of your \(money(Int(state.budget.rounded()))) weekly budget")
                            .font(.footnote)
                            .foregroundStyle(Theme.aubergineMuted)
                    }
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .padding(.vertical, Theme.Spacing.s)
                    .background(Theme.cream)
                }
            }
            ConfettiView(play: yearLanded)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .sensoryFeedback(.impact(weight: .light), trigger: weeklyLanded)
        .sensoryFeedback(.selection, trigger: countTicks)
        .sensoryFeedback(.success, trigger: yearLanded)
        .onAppear { appeared = true }
        .task { await beats() }
    }

    /// The yearly figure: counts up with ease-out (so it races, then slows into the total), grows from
    /// 90% while counting, then lands with a pop (110% → 98% → 100%), a burst of twelve sparks, and a warm
    /// glow that blooms and fades. "a year!" settles under it.
    private func yearly(_ t: Double) -> some View {
        let count = seg(t, Beat.countFrom, Beat.land)
        let value = Int((Double(weekly * weeks) * count).rounded())
        let burst = seg(t, Beat.land, Beat.land + 650)
        let pop = flow(t, [(0, 0.9), (Beat.countFrom, 0.9), (Beat.land, 1), (Beat.land + 130, 1.1), (Beat.land + 300, 0.98),
                           (Beat.land + 440, 1), (Beat.end, 1)])
        return VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Theme.saffronSoft, Theme.saffronSoft.opacity(0)], center: .center,
                                         startRadius: 0, endRadius: 140))
                    .frame(width: 280, height: 280)
                    .scaleEffect(0.6 + 0.6 * burst)
                    .opacity(bell(burst))
                ForEach(0..<12, id: \.self) { i in
                    let angle = Double(i) / 12 * 360 + 12 * (seeded(i) - 0.5)
                    let reach = 64 + 70 * burst + 14 * seeded(i, salt: 2)
                    Capsule()
                        .fill(i.isMultiple(of: 2) ? Theme.tomato : Theme.saffron)
                        .frame(width: 5, height: 6 + 16 * (1 - burst))
                        .offset(y: -reach)
                        .rotationEffect(.degrees(angle))
                        .opacity(burst > 0 ? bell(burst) : 0)
                }
                Text(money(value))
                    .font(Theme.Typography.heroNumber)
                    .monospacedDigit()
                    .foregroundStyle(Theme.tomatoDeep)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .scaleEffect(CGFloat(pop))
                    .opacity(seg(t, Beat.countFrom, Beat.countFrom + 150))
            }
            .frame(height: 96)
            Text("a year!")
                .font(.system(.title2, design: .rounded).weight(.heavy))
                .foregroundStyle(Theme.aubergine)
                .opacity(seg(t, Beat.land + 60, Beat.land + 320))
                .offset(y: 8 * (1 - seg(t, Beat.land + 60, Beat.land + 320)))
        }
    }

    /// Haptics on the beats: a light tap as the weekly amount lands, four ticks while the yearly figure
    /// counts (slowing like the number), and success when it lands.
    private func beats() async {
        try? await Task.sleep(for: .milliseconds(Int(Beat.weekly + 300)))
        weeklyLanded = true
        var elapsed = Beat.weekly + 300
        for tick in [1_850.0, 2_100, 2_400, 2_700] {
            try? await Task.sleep(for: .milliseconds(Int(tick - elapsed)))
            elapsed = tick
            guard !Task.isCancelled else { return }
            countTicks += 1
        }
        try? await Task.sleep(for: .milliseconds(Int(Beat.land - elapsed)))
        guard !Task.isCancelled else { return }
        yearLanded = true
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
        _matched = State(initialValue: state.didMatchCatalog)
        let match = state.matchingRecipes()
        let fit = match.fit
        self.total = match.total
        self.fit = fit
        // Dishes that match their vibes first, then the rest; photos only, so the rivers look real.
        let withPhotos = fit.filter { AssetImage.exists("recipe-\($0.id)") || $0.imageName.map(AssetImage.exists) == true }
        let pool = (withPhotos.count >= 12 ? withPhotos : fit)
            .sorted { Set($0.vibes).intersection(state.vibes).count > Set($1.vibes).intersection(state.vibes).count }
        // Three rivers fill the page down to the stats (two left a gap above the button).
        let picked = Array(pool.prefix(24))
        self.rows = (0..<3).map { row in picked.enumerated().filter { $0.offset % 3 == row }.map(\.element) }
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
        if parts.isEmpty { return String(localized: "Out of \(total.formatted()), every one checked against your answers. Your week is built from these.") }
        return String(localized: "Out of \(total.formatted()), filtered for \(parts.formatted(.list(type: .and))). Your week is built from these.")
    }

    @State private var matched = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The answers the loader ticks off, in their own words ("Avoiding peanuts", "Kitchen · oven + stovetop").
    private var checks: [String] {
        let catalog = FoodCatalog.bundled
        let system = state.units(in: catalog)
        let allergens = Allergen.allCases.filter { state.effectiveAllergens.contains($0) }.prefix(2).map { $0.displayName.lowercased() }
        let dislikes = state.dislikes.sorted().prefix(2).map { DislikeCatalog.label(for: $0, catalog: catalog, system: system).lowercased() }
        let kitchen = Appliance.allCases.filter { state.appliances.contains($0) }.map { $0.displayName.lowercased() }
        var lines: [String] = [
            state.diet == .none ? String(localized: "Diet · anything goes") : String(localized: "Diet · \(state.diet.displayName.lowercased())"),
            allergens.isEmpty ? String(localized: "No allergies to avoid") : String(localized: "Avoiding \(allergens.formatted(.list(type: .and)))"),
            dislikes.isEmpty ? String(localized: "Nothing you won't eat") : String(localized: "Leaving out \(dislikes.formatted(.list(type: .and)))"),
            kitchen.count >= Appliance.allCases.count ? String(localized: "Your whole kitchen") : String(localized: "Kitchen · \(kitchen.joined(separator: " + "))")
        ]
        if !state.vibes.isEmpty {
            let vibes = Vibe.allCases.filter { state.vibes.contains($0) }.prefix(2).map { $0.displayName.lowercased() }
            lines.append(String(localized: "Leaning \(vibes.formatted(.list(type: .and)))"))
        }
        return lines
    }

    var body: some View {
        QuestionScaffold(
            title: matched ? String(localized: "\(fit.count.formatted()) recipes fit you") : String(localized: "matching recipes to you…"),
            subtitle: matched ? subtitle : String(localized: "checking all \(total.formatted()) against your answers"),
            isButtonEnabled: matched,
            onContinue: onContinue
        ) {
            if matched {
                VStack(spacing: Theme.Spacing.l) {
                    DishRivers(rows: rows)
                        .padding(.horizontal, -Theme.Spacing.gutter)
                    CountUpStats(stats: [
                        (quick, String(localized: "ready in 20 min")),
                        state.vibes.isEmpty ? (cuisines, String(localized: "cuisines")) : (vibeMatches, String(localized: "match your vibes")),
                        (leftovers, String(localized: "great as leftovers"))
                    ])
                }
                .transition(.opacity.combined(with: .offset(y: 16)))
            } else {
                MatchingLoader(total: total, fit: fit.count, checks: checks, dishes: Array(rows.joined().prefix(6))) {
                    state.didMatchCatalog = true
                    withAnimation(reduceMotion ? nil : Animation.open(0.5)) { matched = true }
                }
                .transition(.opacity)
            }
        }
    }
}

/// "matching recipes to you": a ring draws round as every recipe is checked (the count inside climbs to
/// the total, then settles on how many fit), six of their dishes circle the ring, and each of their
/// answers ticks off below. The filtering is real (it already happened); this lets them see it happen.
/// Timeline (ms): ring 0–2 300 · ticks every 420 from 400 · result 2 450 · done 2 900.
private struct MatchingLoader: View {
    let total: Int
    let fit: Int
    let checks: [String]
    let dishes: [Recipe]
    let onDone: () -> Void

    @State private var play = false
    @State private var finished = false
    /// One selection tick per answer as it's checked off.
    @State private var ticks = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let ring: CGFloat = 190

    var body: some View {
        OneShotClock(duration: 2_900, play: play) { t in
            VStack(spacing: Theme.Spacing.xl) {
                ZStack {
                    orbit(t)
                    Circle().stroke(Theme.creamDeep, lineWidth: 12)
                        .frame(width: ring, height: ring)
                    Circle()
                        .trim(from: 0, to: seg(t, 0, 2_300, easeOut: false))
                        .stroke(Theme.tomato, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: ring, height: ring)
                    VStack(spacing: Theme.Spacing.xxs) {
                        let checked = Int((Double(total) * seg(t, 0, 2_300, easeOut: false)).rounded())
                        let settle = seg(t, 2_350, 2_700)
                        Text((settle > 0.5 ? fit : checked).formatted())
                            .font(Theme.Typography.bigNumber)
                            .monospacedDigit()
                            .foregroundStyle(settle > 0.5 ? Theme.tomatoDeep : Theme.aubergine)
                            .contentTransition(.numericText())
                        Text(settle > 0.5 ? String(localized: "fit you") : String(localized: "recipes checked"))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.aubergineMuted)
                    }
                    .animation(Theme.spring, value: seg(t, 2_350, 2_700) > 0.5)
                }
                .frame(width: ring + 96, height: ring + 96)
                .frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                    ForEach(Array(checks.enumerated()), id: \.offset) { index, line in
                        let tickAt = 400 + Double(index) * 420
                        HStack(spacing: Theme.Spacing.s) {
                            CheckCircle(isChecked: t >= tickAt)
                                .frame(width: 30, height: 30)
                            Text(line)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(t >= tickAt - 420 ? Theme.aubergine : Theme.aubergineFaint)
                            Spacer(minLength: 0)
                        }
                        .opacity(0.4 + 0.6 * seg(t, tickAt - 500, tickAt - 200))
                    }
                }
                .padding(Theme.Spacing.l)
                .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
            }
        }
        .sensoryFeedback(.success, trigger: finished)
        .sensoryFeedback(.selection, trigger: ticks)
        .onAppear { play = true }
        .task {
            guard !reduceMotion else { return }
            try? await Task.sleep(for: .milliseconds(400))
            for index in checks.indices {
                if index > 0 { try? await Task.sleep(for: .milliseconds(420)) }
                guard !Task.isCancelled else { return }
                ticks = index + 1
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(reduceMotion ? 600 : 2_900))
            guard !Task.isCancelled, !finished else { return }
            finished = true
            onDone()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Matching recipes to your answers"))
    }

    /// Their dishes ride round just outside the ring (one turn every 9 s, linear), each counter-rotated
    /// so the photos stay upright, opening out from the ring as the loader starts.
    private func orbit(_ t: Double) -> some View {
        LoopClock(period: 9_000) { l in
            ZStack {
                ForEach(Array(dishes.enumerated()), id: \.offset) { index, recipe in
                    let angle = 2 * Double.pi * (Double(index) / Double(max(1, dishes.count)) + loop(l, period: 9_000))
                    let open = seg(t, Double(index) * 60, 400 + Double(index) * 60)
                    let radius = Double(ring) / 2 + 30 * open
                    DishTileView(recipe: recipe, size: 40, cornerRadius: 20)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Theme.card, lineWidth: 2))
                        .elevation(Theme.Elevation.subtle)
                        .scaleEffect(0.8 + 0.2 * open)
                        .opacity(open)
                        .offset(x: cos(angle) * radius, y: sin(angle) * radius)
                }
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
                    let leftward = index.isMultiple(of: 2)
                    let p = CGFloat(loop(t, period: period, phase: Double(index) * 0.37))
                    let x = leftward ? -p * width : (p - 1) * width
                    // The strip is far wider than the screen (three copies for a seamless loop). It lives in an
                    // overlay of a screen-wide clear row, so it can never widen the page around it.
                    Color.clear
                        .frame(maxWidth: .infinity)
                        .frame(height: tile)
                        .overlay(alignment: .leading) {
                            HStack(spacing: gap) {
                                ForEach(0..<3, id: \.self) { _ in
                                    ForEach(row) { recipe in
                                        DishTileView(recipe: recipe, size: tile, cornerRadius: Theme.Radius.large)
                                            .elevation(Theme.Elevation.subtle)
                                    }
                                }
                            }
                            .fixedSize()
                            .offset(x: x)
                        }
                }
            }
            .padding(.vertical, Theme.Spacing.s)
        }
        .frame(height: tile * CGFloat(rows.count) + gap * CGFloat(max(0, rows.count - 1)) + 16)
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
