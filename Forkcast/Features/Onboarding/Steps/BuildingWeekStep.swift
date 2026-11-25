import SwiftUI
import ForkcastCore

/// "putting your week together": the second half of the story. The recipes page already matched recipes
/// to them ("244 recipes fit you"); this screen puts those recipes into their days. Their week is drawn as
/// a grid (days across, meals down) of empty plates that shimmer while the planner works; once the real
/// plan exists, its dishes deal into the grid column by column, and three lines tick off: choosing,
/// pricing, the grocery list. The reveal then shows the same dishes up close.
struct BuildingWeekStep: View {
    let state: OnboardingState
    let onFinished: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @State private var started: Bool = false
    /// The dishes deal into the grid once the plan exists.
    @State private var filling = false
    /// Checklist lines done (0–3).
    @State private var done = 0
    @State private var finished = false

    private let fitCount: Int
    private let days: [Date]
    private let types: [MealType]

    init(state: OnboardingState, onFinished: @escaping () -> Void) {
        self.state = state
        self.onFinished = onFinished
        fitCount = state.matchingRecipes().fit.count
        let calendar = WeekMath.gregorian
        let slots = WeekMath.slots(from: calendar.startOfDay(for: Date()), cookingDays: state.cookingDays, mealTypes: state.mealTypes)
        days = Array(Set(slots.map { calendar.startOfDay(for: $0.date) })).sorted()
        types = MealType.ordered(state.mealTypes)
    }

    private var cellCount: Int { days.count * types.count }
    /// Dishes deal in at most 70 ms apart, and the whole grid fills in about a second.
    private var stagger: Double { min(70, 1_000 / Double(max(1, cellCount))) }
    private var fillMs: Double { Double(max(0, cellCount - 1)) * stagger + 380 }
    private var cell: CGFloat { days.count <= 5 ? 50 : 40 }

    private var storeName: String {
        FoodCatalog.bundled.store(id: state.mainStoreId)?.name ?? String(localized: "your shop")
    }

    private var title: String {
        let name = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? String(localized: "putting your week together…") : String(localized: "\(name), we're putting your week together…")
    }

    private var checklist: [String] {
        let budget = MoneyFormat.string(state.budget, currencyCode: state.country(in: FoodCatalog.bundled).currencyCode, fractionDigits: 0)
        let meals = state.mealTypes == [.dinner]
            ? (cellCount == 1 ? String(localized: "1 dinner") : String(localized: "\(cellCount) dinners"))
            : String(localized: "\(cellCount) meals")
        return [
            String(localized: "Choosing \(meals) from your \(fitCount) recipes"),
            String(localized: "Pricing it at \(storeName), within your \(budget) budget"),
            String(localized: "Writing your grocery list")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(title)
                    .font(Theme.questionFont)
                    .foregroundStyle(Theme.aubergine)
                    .accessibilityAddTraits(.isHeader)
                Text("from your \(fitCount) recipes, priced at \(storeName)")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
            }
            .padding(.top, Theme.Spacing.l)
            Spacer(minLength: 0)
            VStack(spacing: Theme.Spacing.m) {
                MascotReaction(mood: finished ? .cheer : .thinking, size: 96)
                weekGrid
            }
            .frame(maxWidth: .infinity)
            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                ForEach(Array(checklist.enumerated()), id: \.offset) { index, line in
                    HStack(spacing: Theme.Spacing.s) {
                        CheckCircle(isChecked: index < done)
                            .frame(width: 30, height: 30)
                        Text(line)
                            .font(.subheadline.weight(index == done ? .bold : .semibold))
                            .foregroundStyle(index <= done ? Theme.aubergine : Theme.aubergineFaint)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityValue(index < done ? Text("Done") : Text("In progress"))
                }
            }
            .padding(Theme.Spacing.l)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
            .animation(Theme.Motion.update, value: done)
        }
        .padding(Theme.Spacing.gutter)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .sensoryFeedback(.selection, trigger: done)
        .sensoryFeedback(.success, trigger: finished)
        .task { await run() }
    }

    /// Days across (today in tomato), meals down. Empty plates shimmer in a wave that runs across the
    /// week while the planner works (one loop clock, 1.6 s); then each dish opens in from 80% (never 0)
    /// over its plate, column by column (one one-shot clock).
    private var weekGrid: some View {
        let calendar = Calendar.current
        let recipes = plannedRecipes()
        return OneShotClock(duration: fillMs, play: filling) { t in
            LoopClock(period: 1_600, paused: filling) { l in
                VStack(spacing: Theme.Spacing.inline) {
                    HStack(spacing: Theme.Spacing.inline) {
                        if types.count > 1 { Color.clear.frame(width: 14, height: 1) }
                        ForEach(days.indices, id: \.self) { column in
                            let today = calendar.isDateInToday(days[column])
                            Text(days[column].formatted(.dateTime.weekday(.narrow)))
                                .font(.caption.weight(today ? .heavy : .semibold))
                                .foregroundStyle(today ? Theme.tomatoDeep : Theme.aubergineMuted)
                                .frame(width: cell)
                        }
                    }
                    ForEach(types.indices, id: \.self) { row in
                        HStack(spacing: Theme.Spacing.inline) {
                            if types.count > 1 {
                                Text(types[row].title.prefix(1))
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(Theme.aubergineFaint)
                                    .frame(width: 14)
                            }
                            ForEach(days.indices, id: \.self) { column in
                                let k = Double(column * types.count + row)
                                let p = seg(t, k * stagger, k * stagger + 380)
                                let shimmer = 0.5 + 0.5 * wave(l, period: 1_600, phase: -Double(column) * 0.09 - Double(row) * 0.04)
                                ZStack {
                                    RoundedRectangle(cornerRadius: cell * 0.3, style: .continuous)
                                        .fill(Theme.creamDeep.opacity(0.5 + 0.5 * shimmer))
                                        .overlay(RoundedRectangle(cornerRadius: cell * 0.3, style: .continuous)
                                            .strokeBorder(Theme.line, style: StrokeStyle(lineWidth: 1, dash: [4, 3])))
                                        .opacity(1 - p)
                                    if let recipe = recipes[GridKey(day: column, type: types[row])] {
                                        DishTileView(recipe: recipe, size: cell, cornerRadius: cell * 0.3)
                                            .shadow(color: Theme.aubergine.opacity(0.12 * p), radius: 3, y: 2)
                                            .scaleEffect(0.8 + 0.2 * p)
                                            .opacity(p)
                                    }
                                }
                                .frame(width: cell, height: cell)
                            }
                        }
                    }
                }
            }
        }
        .accessibilityHidden(true)
    }

    private struct GridKey: Hashable {
        let day: Int
        let type: MealType
    }

    /// The planned dish for each (day, meal) once the plan exists.
    private func plannedRecipes() -> [GridKey: Recipe] {
        guard filling else { return [:] }
        let calendar = WeekMath.gregorian
        var out: [GridKey: Recipe] = [:]
        for meal in planStore.meals where !meal.isSide {
            guard let column = days.firstIndex(where: { calendar.isDate($0, inSameDayAs: meal.date) }),
                  let recipe = planStore.recipe(for: meal) else { continue }
            let key = GridKey(day: column, type: meal.mealType)
            if out[key] == nil { out[key] = recipe }
        }
        return out
    }

    /// Plates shimmer for at least 0.6 s, the dishes deal in once the real plan exists, then the three
    /// lines tick 450 ms apart and the reveal follows. Nothing here pretends: the fill waits for the plan.
    private func run() async {
        guard !started else { return }
        started = true
        profileStore.createProfile(from: state, markComplete: false)
        let generation = Task { await planStore.generatePlan() }
        try? await Task.sleep(for: .milliseconds(600))
        _ = await generation.value
        if planStore.currentPlanIsSaved, let plan = planStore.currentPlan {
            profileStore.recordOnboardingPlan(plan)
        }
        guard !Task.isCancelled else { return }
        filling = true
        try? await Task.sleep(for: .milliseconds(Int(fillMs)))
        done = 1
        try? await Task.sleep(for: .milliseconds(450))
        done = 2
        try? await Task.sleep(for: .milliseconds(450))
        done = 3
        finished = true
        try? await Task.sleep(for: .milliseconds(650))
        guard !Task.isCancelled else { return }
        notifications.apply(profile: profileStore.profile)
        onFinished()
    }
}

#Preview { BuildingWeekStep(state: OnboardingState()) {}.previewEnvironment().creamBackground() }
