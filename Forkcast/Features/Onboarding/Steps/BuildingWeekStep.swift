import SwiftUI
import ForkcastCore

/// Shows an indeterminate state for the real planning operation.
struct BuildingWeekStep: View {
    let state: OnboardingState
    let onFinished: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @State private var started: Bool = false

    private var storeName: String {
        FoodCatalog.bundled.store(id: state.mainStoreId)?.name ?? String(localized: "your shop")
    }

    private var catalog: FoodCatalog { .bundled }
    private var country: Country { state.country(in: catalog) }

    private var rows: [String] {
        [householdRow, avoidingRow, kitchenRow, budgetRow]
    }

    /// "Matching 2 adults + 1 kid"
    private var householdRow: String {
        let adults: String = state.adults == 1 ? String(localized: "1 adult") : String(localized: "\(state.adults) adults")
        guard state.kids > 0 else { return String(localized: "Matching \(adults)") }
        let kids: String = state.kids == 1 ? String(localized: "1 kid") : String(localized: "\(state.kids) kids")
        return String(localized: "Matching \(adults) + \(kids)")
    }

    /// "Avoiding mushrooms and peanuts", or the diet when there's nothing to avoid.
    private var avoidingRow: String {
        let system: UnitSystem = country.unitSystem
        let dislikes: [String] = state.dislikes.sorted().map { DislikeCatalog.label(for: $0, catalog: catalog, system: system).lowercased() }
        let allergens: [String] = Allergen.allCases.filter { state.effectiveAllergens.contains($0) }.map { $0.displayName.lowercased() }
        let avoided: [String] = Array((allergens + dislikes).prefix(3))
        if !avoided.isEmpty {
            return String(localized: "Avoiding \(avoided.formatted(.list(type: .and)))")
        }
        switch state.diet {
        case .none: return String(localized: "Picking from every recipe you'll love")
        default: return String(localized: "Keeping it \(state.diet.displayName.lowercased())")
        }
    }

    /// "Only air fryer + oven recipes"
    private var kitchenRow: String {
        if state.appliances.count >= Appliance.allCases.count { return String(localized: "Using your whole kitchen") }
        let names: String = Appliance.allCases.filter { state.appliances.contains($0) }.map { $0.displayName.lowercased() }.joined(separator: " + ")
        return String(localized: "Only \(names) recipes")
    }

    /// "Keeping it under £85"
    private var budgetRow: String {
        String(localized: "Budget: \(MoneyFormat.string(state.budget, currencyCode: country.currencyCode, fractionDigits: 0))")
    }

    /// How many checklist steps are done (0–3). The last one only ticks when the plan really exists.
    @State private var done: Int = 0
    @State private var finished = false

    private var title: String {
        let name = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? String(localized: "building your week…") : String(localized: "\(name), we're building your week…")
    }

    private var checklist: [String] {
        let budget = MoneyFormat.string(state.budget, currencyCode: country.currencyCode, fractionDigits: 0)
        let days = max(1, state.cookingDays.count)
        let meals: String
        if state.mealTypes == [.dinner] {
            meals = days == 1 ? String(localized: "1 dinner") : String(localized: "\(days) dinners")
        } else {
            meals = String(localized: "\(days) days of meals")
        }
        return [
            String(localized: "Matching meals to \(storeName) + your \(budget) budget"),
            String(localized: "Lining up \(meals) for the week"),
            String(localized: "Putting together your grocery list")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            Text(title)
                .font(Theme.questionFont)
                .foregroundStyle(Theme.aubergine)
                .accessibilityAddTraits(.isHeader)
                .padding(.top, Theme.Spacing.l)
            Spacer(minLength: 0)
            IngredientOrbit()
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
            Text(rows.joined(separator: " · "))
                .font(.caption)
                .foregroundStyle(Theme.aubergineMuted)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.Spacing.gutter)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .sensoryFeedback(.selection, trigger: done)
        .sensoryFeedback(.success, trigger: finished)
        .task { await run() }
    }

    /// The first two ticks are paced so each line reads; the third waits for the real plan,
    /// and the screen always stays at least ~2.4 s so the checklist never flashes past.
    private func run() async {
        guard !started else { return }
        started = true
        let began = Date()
        profileStore.createProfile(from: state, markComplete: false)
        let generation = Task { await planStore.generatePlan() }
        try? await Task.sleep(for: .milliseconds(850))
        done = 1
        try? await Task.sleep(for: .milliseconds(850))
        done = 2
        await generation.value
        if planStore.currentPlanIsSaved, let plan = planStore.currentPlan {
            profileStore.recordOnboardingPlan(plan)
        }
        let remaining = 2.4 - Date().timeIntervalSince(began)
        if remaining > 0 { try? await Task.sleep(for: .seconds(remaining)) }
        done = 3
        finished = true
        try? await Task.sleep(for: .milliseconds(600))
        guard !Task.isCancelled else { return }
        notifications.apply(profile: profileStore.profile)
        onFinished()
    }
}

/// Eight ingredients circle Chef Tomato on a slow orbit (linear, 40 s a turn), each rocking on its own
/// seeded phase and dipping slightly as it passes behind him (depth). They open out from 60% of the
/// radius once on appear. Reduce Motion: they rest on frame 0.
private struct IngredientOrbit: View {
    private let pieces = ["avocado", "cherry-tomatoes", "bell-pepper", "basil", "eggplant", "garlic", "lemon", "broccoli"]
    private let size: CGFloat = 250
    @State private var visible = false

    var body: some View {
        OneShotClock(duration: 900, play: visible) { e in
            LoopClock(period: 40_000, paused: !visible) { t in
                ZStack {
                    Circle()
                        .fill(Theme.tomatoSoft)
                        .frame(width: size * 0.56, height: size * 0.56)
                        .scaleEffect(0.9 + 0.1 * seg(e, 0, 500) + 0.015 * wave(t, period: 5_000))
                    ForEach(Array(pieces.enumerated()), id: \.offset) { index, id in
                        piece(id, index: index, t: t, e: e, behind: true)
                    }
                    MascotView(size: size * 0.42, mood: .thinking)
                    ForEach(Array(pieces.enumerated()), id: \.offset) { index, id in
                        piece(id, index: index, t: t, e: e, behind: false)
                    }
                }
                .frame(width: size, height: size)
            }
        }
        .onAppear { visible = true }
        .onDisappear { visible = false }
        .accessibilityHidden(true)
    }

    /// Each piece is drawn in the back layer while it's in the top half of the orbit and in the front
    /// layer in the bottom half, so it really passes behind and in front of Chef Tomato.
    @ViewBuilder
    private func piece(_ id: String, index: Int, t: Double, e: Double, behind: Bool) -> some View {
        let angle = 2 * Double.pi * (Double(index) / Double(pieces.count) + loop(t, period: 40_000))
        let depth = sin(angle)                  // -1 at the back (top), 1 at the front (bottom)
        if (depth < 0) == behind {
            let open = seg(e, Double(index) * 50, 450 + Double(index) * 50)
            let radius = (0.6 + 0.4 * open)
            let rock = 8 * wave(t, period: [4_000, 5_000, 8_000][index % 3], phase: seeded(index))
            let side = size * 0.17 * CGFloat(0.85 + 0.15 * depth)
            Image("ingredient-\(id)")
                .resizable()
                .scaledToFit()
                .frame(width: side, height: side)
                .rotationEffect(.degrees(rock))
                .shadow(color: Theme.aubergine.opacity(0.1), radius: 3, y: 2)
                .opacity(open * (0.75 + 0.25 * (depth + 1) / 2))
                .offset(x: cos(angle) * Double(size) * 0.42 * radius,
                        y: depth * Double(size) * 0.34 * radius)
        }
    }
}

#Preview { BuildingWeekStep(state: OnboardingState()) {}.previewEnvironment().creamBackground() }
