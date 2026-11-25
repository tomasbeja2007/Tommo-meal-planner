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

    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            MascotView(size: 150, mood: .thinking)
                .accessibilityHidden(true)
            ProgressView {
                Text("Building your week")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
            }
            .tint(Theme.tomato)
            Text("Planning meals for \(storeName)")
                .font(.subheadline)
                .foregroundStyle(Theme.aubergineMuted)
            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    Text(row)
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                }
            }
        }
        .multilineTextAlignment(.center)
        .padding(Theme.Spacing.gutter)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task { await run() }
    }

    private func run() async {
        guard !started else { return }
        started = true
        profileStore.createProfile(from: state, markComplete: false)
        await planStore.generatePlan()
        guard !Task.isCancelled else { return }
        notifications.apply(profile: profileStore.profile)
        onFinished()
    }
}

#Preview { BuildingWeekStep(state: OnboardingState()) {}.previewEnvironment().creamBackground() }
