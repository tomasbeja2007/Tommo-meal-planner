import SwiftUI
import ForkcastCore

/// The week on the Plan tab.
/// Dinners only: one card per day (a meal card, or a slim "add one" row), as it always was.
/// More meals: each day gets a heading, then one card or "add" row per planned meal type.
struct DayList: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    var day: Date? = nil
    let onOpen: (PlannedMeal) -> Void
    let onSwap: (PlannedMeal) -> Void
    let onAdd: (Date, MealType) -> Void

    var body: some View {
        LazyVStack(spacing: Theme.Spacing.m) {
            if let day {
                // Planned meals lead in the order of the day (breakfast → lunch → dinner → snack),
                // then sides, then the empty slots as quiet "add" rows at the end.
                let order = MealType.ordered(Set(MealType.allCases))
                let filled = order.filter { !planStore.meals(on: day, type: $0).isEmpty }
                let empty = order.filter { planStore.meals(on: day, type: $0).isEmpty }
                ForEach(filled) { type in
                    slot(day: day, type: type, header: "\(DateText.shortWeekday(day).uppercased()) · \(type.title)")
                }
                mealCards(planStore.meals(on: day).filter(\.isSide), day: day, header: String(localized: "Side or extra"))
                ForEach(empty) { type in
                    slot(day: day, type: type, header: "\(DateText.shortWeekday(day).uppercased()) · \(type.title)")
                        .transition(.opacity)
                }
            } else {
                allDays
            }
        }
        .animation(Theme.motion(reduceMotion), value: planStore.revision)
    }

    private var allDays: some View {
        ForEach(planStore.weekDays, id: \.self) { day in
            if planStore.isDinnersOnly {
                slot(day: day, type: .dinner, header: DateText.dayLabel(day))
            } else {
                VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                    Text(DateText.dayLabel(day))
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.aubergine)
                        .padding(.top, Theme.Spacing.s)
                        .accessibilityAddTraits(.isHeader)
                    ForEach(planStore.plannedMealTypes) { type in
                        slot(day: day, type: type, header: type.title)
                    }
                }
            }
            mealCards(planStore.meals(on: day).filter(\.isSide), day: day, header: String(localized: "Side or extra"))
        }
    }

    @ViewBuilder
    private func slot(day: Date, type: MealType, header: String) -> some View {
        let meals: [PlannedMeal] = planStore.meals(on: day, type: type)
        if meals.isEmpty {
            EmptyDayRow(day: day, label: header, mealType: type) { onAdd(day, type) }
        } else {
            mealCards(meals, day: day, header: header)
        }
    }

    private func mealCards(_ meals: [PlannedMeal], day: Date, header: String) -> some View {
        ForEach(meals, id: \.persistentModelID) { meal in
            if let recipe = planStore.recipe(for: meal) {
                MealCard(
                    day: day, header: header, meal: meal, recipe: recipe, cost: planStore.cost(for: meal),
                    onOpen: { onOpen(meal) }, onSwap: { onSwap(meal) }
                )
                .transition(.asymmetric(insertion: reduceMotion ? .opacity : .scale(scale: 0.96).combined(with: .opacity), removal: .opacity))
            }
        }
    }
}

struct MealCard: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    let day: Date
    /// "Mon 24 Nov" for dinners-only plans, or the meal ("Lunch") under a day heading.
    var header: String? = nil
    let meal: PlannedMeal
    let recipe: Recipe
    let cost: Double
    let onOpen: () -> Void
    let onSwap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text(header ?? DateText.dayLabel(day))
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.aubergineMuted)
            HStack(alignment: .top, spacing: Theme.Spacing.m) {
                Button(action: onOpen) {
                    HStack(alignment: .top, spacing: Theme.Spacing.m) {
                        DishTileView(recipe: recipe, size: 76)
                            .overlay(alignment: .bottomTrailing) {
                                if meal.isCooked {
                                    CookedBadge().offset(x: 4, y: 4)
                                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                                }
                            }
                        MealCardText(recipe: recipe, meal: meal, cost: cost, currencyCode: profileStore.currencyCode, macros: repository.nutrition(for: recipe).macros)
                        Spacer(minLength: 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityHint(Text("Opens the recipe"))
                Button(action: onSwap) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.tomato)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.tomatoSoft))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Swap \(DateText.weekdayName(day))'s \(meal.mealType.noun)"))
            }
        }
        .cardStyle(padding: Theme.Spacing.m)
        .opacity(meal.isCooked ? 0.75 : 1)
        .animation(reduceMotion ? nil : Theme.Motion.update, value: meal.isCooked)
    }
}

private struct MealCardText: View {
    let recipe: Recipe
    let meal: PlannedMeal
    let cost: Double
    let currencyCode: String
    let macros: Macros

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(recipe.title)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            ViewThatFits(in: .horizontal) {
                MealMetaRow(minutes: recipe.totalMinutes, servings: meal.servings, cost: cost, currencyCode: currencyCode)
                MealMetaRow(minutes: recipe.totalMinutes, servings: nil, cost: cost, currencyCode: currencyCode)
            }
            if !recipe.vibes.isEmpty {
                HStack(spacing: 4) {
                    ForEach(recipe.vibes.prefix(2), id: \.self) { vibe in
                        TagLabel(text: vibe.displayName)
                    }
                }
            }
            MacrosLine(macros: macros)
        }
    }
}

struct MealMetaRow: View {
    let minutes: Int
    let servings: Double?
    let cost: Double
    let currencyCode: String

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            Label("\(minutes) min", systemImage: "clock")
            if let servings {
                Label(FractionFormatter.string(servings), systemImage: "person.2")
            }
            Text("~" + MoneyFormat.string(cost, currencyCode: currencyCode))
        }
        .font(.caption.weight(.medium))
        .monospacedDigit()
        .labelStyle(CompactLabelStyle())
        .foregroundStyle(Theme.aubergineMuted)
        .lineLimit(1)
    }
}

/// Icon + text with a tight gap.
struct CompactLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 3) {
            configuration.icon
            configuration.title
        }
    }
}

struct CookedBadge: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 12, weight: .heavy))
            .foregroundStyle(Color.white)
            .frame(width: 26, height: 26)
            .background(Circle().fill(Theme.herb))
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .accessibilityLabel(Text("Cooked"))
    }
}

/// "no dinner planned · add one" (or "no lunch planned"…)
struct EmptyDayRow: View {
    let day: Date
    var label: String? = nil
    var mealType: MealType = .dinner
    let onAdd: () -> Void

    var body: some View {
        Button(action: onAdd) {
            HStack {
                Text(label ?? DateText.dayLabel(day))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.aubergineFaint)
                Text("Add \(mealType.noun)")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineFaint)
                Spacer()
                Image(systemName: "plus").accessibilityHidden(true)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.tomato)
            }
            .padding(.horizontal, Theme.Spacing.l)
            .frame(minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                    .strokeBorder(Theme.line, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview { ScrollView { DayList(onOpen: { _ in }, onSwap: { _ in }, onAdd: { _, _ in }).padding() }.previewEnvironment().creamBackground() }
