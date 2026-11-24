import SwiftUI
import ForkcastCore

/// One card per day of the plan: a meal card, or a slim "add one" row.
struct DayList: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    let onOpen: (PlannedMeal) -> Void
    let onSwap: (PlannedMeal) -> Void
    let onAdd: (Date) -> Void

    var body: some View {
        LazyVStack(spacing: Theme.Spacing.m) {
            ForEach(planStore.weekDays, id: \.self) { day in
                if let meal = planStore.meal(on: day), let recipe = planStore.recipe(for: meal) {
                    MealCard(
                        day: day,
                        meal: meal,
                        recipe: recipe,
                        cost: planStore.cost(for: meal),
                        onOpen: { onOpen(meal) },
                        onSwap: { onSwap(meal) }
                    )
                    .id("\(meal.recipeId)-\(day.timeIntervalSince1970)")
                    .transition(.asymmetric(insertion: .scale(scale: 0.96).combined(with: .opacity), removal: .opacity))
                } else {
                    EmptyDayRow(day: day) { onAdd(day) }
                }
            }
        }
        .animation(Theme.motion(reduceMotion), value: planStore.revision)
    }
}

struct MealCard: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    let day: Date
    let meal: PlannedMeal
    let recipe: Recipe
    let cost: Double
    let onOpen: () -> Void
    let onSwap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text(DateText.dayLabel(day))
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
                .accessibilityLabel(Text("Swap \(DateText.weekdayName(day))'s dinner"))
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

/// "no dinner planned · add one"
struct EmptyDayRow: View {
    let day: Date
    let onAdd: () -> Void

    var body: some View {
        Button(action: onAdd) {
            HStack {
                Text(DateText.dayLabel(day))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.aubergineFaint)
                Text("no dinner planned")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineFaint)
                Spacer()
                Label(String(localized: "add one"), systemImage: "plus")
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

#Preview { ScrollView { DayList(onOpen: { _ in }, onSwap: { _ in }, onAdd: { _ in }).padding() }.previewEnvironment().creamBackground() }
