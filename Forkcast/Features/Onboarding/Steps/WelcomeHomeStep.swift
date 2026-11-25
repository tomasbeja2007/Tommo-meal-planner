import SwiftUI
import ForkcastCore

struct WelcomeHomeStep: View {
    let onFinish: () -> Void

    @Environment(PlanStore.self) private var planStore
    @Environment(ProfileStore.self) private var profileStore
    @State private var appeared = false

    private var ready: Bool { !planStore.meals.isEmpty }

    /// The first dinner of the week (or the first meal if there's no dinner): the dish this screen leads with.
    private var heroRecipe: (recipe: Recipe, day: Date)? {
        let mains = planStore.meals.filter { !$0.isSide }
        let ordered = mains.filter { $0.mealType == .dinner } + mains.filter { $0.mealType != .dinner }
        for meal in ordered {
            if let recipe = planStore.recipe(for: meal) { return (recipe, meal.date) }
        }
        return nil
    }

    private var budgetStat: (value: String, label: String) {
        guard ready, let estimate = planStore.basketEstimate, let budget = GroceryEstimate(planStore.budget), budget.amount > 0 else {
            return ("—", String(localized: "estimate unavailable"))
        }
        let difference = budget.difference(from: estimate)
        let value = profileStore.formatMoney(abs(difference))
        if difference == 0 { return (value, String(localized: "on budget")) }
        return (value, difference > 0 ? String(localized: "under budget") : String(localized: "over budget"))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.l) {
                if ready, let hero = heroRecipe { HeroDishCelebration(recipe: hero.recipe, day: hero.day) }
                else if ready { MascotView(size: 128, mood: .cheer) }
                else { MascotView(size: 128, mood: .idle) }
                VStack(spacing: Theme.Spacing.s) {
                    Text("Welcome to Tommo")
                        .font(Theme.questionFont)
                        .foregroundStyle(Theme.aubergine)
                        .accessibilityAddTraits(.isHeader)
                    Text(ready ? "Your week of meals is ready. Time to cook something good." : "You're ready to start planning meals.")
                        .foregroundStyle(Theme.aubergineMuted)
                }
                if ready {
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: Theme.Spacing.s) { stats }
                        VStack(spacing: Theme.Spacing.s) { stats }
                    }
                    if planStore.currentPlanIsSaved {
                        Label("Your plan is saved to this device", systemImage: "checkmark.circle")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Theme.herb)
                    }
                }
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(Theme.Spacing.gutter)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(String(localized: "Let's go"), action: onFinish)
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.vertical, Theme.Spacing.s)
                .background(Theme.cream)
        }
        .sensoryFeedback(.success, trigger: appeared)
        .onAppear { appeared = ready }
    }

    @ViewBuilder
    private var stats: some View {
        StatTile(value: planStore.meals.count.formatted(), label: String(localized: "meals planned"))
        StatTile(value: budgetStat.value, label: budgetStat.label)
        StatTile(value: "1", label: String(localized: "shopping list"))
    }
}

/// The week's first dinner as the hero: the dish rises in, its ingredients open out around it,
/// then everything keeps a quiet idle life (breathing dish, ingredients bobbing on seeded phases).
/// Numbers live in `HeroMotion`. Reduce Motion: the entrance shows its final frame, the loop rests on frame 0.
private enum HeroMotion {
    static let entrance: Double = 1_100      // ms, one-shot
    static let period: Double = 9_600        // ms, idle loop
    static let dishSize: CGFloat = 132
    static let dishRise: Double = 18          // pt the dish rises from
    static let dishStartScale: Double = 0.92 // never from 0
    static let breath: Double = 0.012        // dish breathing, ±1.2%
    static let tilt: Double = 1.6            // dish sway, degrees around its base
    static let orbitX: Double = 112
    static let orbitY: Double = 96
    static let stagger: Double = 55          // ms between ingredients opening out
    static let bob: Double = 3.5              // pt
    /// Idle periods that divide `period`, so the loop seam never jumps.
    static let periods: [Double] = [2_400, 3_200, 4_800]
}

private struct HeroDishCelebration: View {
    let recipe: Recipe
    let day: Date
    private let ingredients = ["tomato", "carrot", "avocado", "lemon", "broccoli", "onion", "eggplant", "bell-pepper"]
    @State private var visible = false

    var body: some View {
        VStack(spacing: Theme.Spacing.s) {
            OneShotClock(duration: HeroMotion.entrance, play: visible) { e in
                LoopClock(period: HeroMotion.period, paused: !visible) { t in
                    scene(entrance: e, time: t)
                }
            }
            .frame(width: 280, height: 236)
            .accessibilityHidden(true)
            VStack(spacing: Theme.Spacing.xxs) {
                Text("First up, \(DateText.weekdayName(day))")
                    .font(.caption.weight(.bold))
                    .textCase(.uppercase)
                    .foregroundStyle(Theme.tomatoDeep)
                Text(recipe.title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                    .lineLimit(2)
            }
            .accessibilityElement(children: .combine)
        }
        .onAppear { visible = true }
        .onDisappear { visible = false }
    }

    private func scene(entrance e: Double, time t: Double) -> some View {
        let arrive = seg(e, 0, 620)
        let breathe = wave(t, period: 4_800)
        let sway = wave(t, period: HeroMotion.period, phase: 0.25)
        let dishScale = (HeroMotion.dishStartScale + (1 - HeroMotion.dishStartScale) * arrive) * (1 + HeroMotion.breath * breathe)
        return ZStack {
            // Warm halo behind the dish: grows in with the dish, then glows softly.
            Circle()
                .fill(Theme.tomatoSoft)
                .frame(width: 170, height: 170)
                .scaleEffect(0.9 + 0.1 * arrive + 0.02 * wave(t, period: 3_200, phase: 0.4))
                .opacity(arrive)
            ForEach(Array(ingredients.enumerated()), id: \.offset) { index, id in
                let angle = 2 * Double.pi * Double(index) / Double(ingredients.count) - .pi / 2
                let open = seg(e, 260 + Double(index) * HeroMotion.stagger, 820 + Double(index) * HeroMotion.stagger)
                let radius = 0.55 + 0.45 * open
                let bob = wave(t, period: HeroMotion.periods[Int(seeded(index) * 3)], phase: seeded(index, salt: 1))
                let spin = 6 * wave(t, period: HeroMotion.periods[Int(seeded(index, salt: 2) * 3)] * 2, phase: seeded(index, salt: 3))
                IngredientThumbnail(ingredientID: id, size: 38 + 6 * seeded(index, salt: 4), showsBackground: false)
                    .rotationEffect(.degrees(spin))
                    .scaleEffect(0.8 + 0.2 * open)
                    .opacity(open)
                    .offset(x: cos(angle) * HeroMotion.orbitX * radius,
                            y: sin(angle) * HeroMotion.orbitY * radius + HeroMotion.bob * bob)
            }
            DishTileView(recipe: recipe, size: HeroMotion.dishSize, cornerRadius: Theme.Radius.hero)
                .shadow(color: Theme.tomatoDeep.opacity(0.18), radius: 14, y: 8)
                .overlay(alignment: .bottomTrailing) {
                    let pop = seg(e, 700, 1_000)
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundStyle(Color.white)
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(Theme.herb))
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .scaleEffect(0.7 + 0.3 * pop)
                        .opacity(pop)
                        .offset(x: 8, y: 8)
                }
                .rotationEffect(.degrees(HeroMotion.tilt * sway), anchor: .bottom)
                .scaleEffect(dishScale, anchor: .bottom)
                .offset(y: HeroMotion.dishRise * (1 - arrive))
                .opacity(seg(e, 0, 280))
        }
    }
}

#Preview { WelcomeHomeStep {}.previewEnvironment().creamBackground() }
