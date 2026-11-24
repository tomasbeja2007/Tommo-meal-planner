import SwiftUI
import ForkcastCore

/// 13. Full-screen loader (~3 s). Runs the real planner while a checklist built from the
/// user's own answers ticks off, with a progress ring around Chef Tomato.
struct BuildingWeekStep: View {
    let state: OnboardingState
    let onFinished: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @State private var completedRows: Int = 0
    @State private var started: Bool = false
    @State private var finished: Bool = false

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
        String(localized: "Keeping it under \(MoneyFormat.string(state.budget, currencyCode: country.currencyCode, fractionDigits: 0))")
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.xxl) {
            Spacer()
            ZStack {
                ProgressRing(value: Double(completedRows) / Double(rows.count), lineWidth: 8, tint: Theme.tomato)
                    .frame(width: 210, height: 210)
                MascotView(size: 160, mood: .thinking)
            }
            Text("building your week…")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                ForEach(Array(rows.enumerated()), id: \.offset) { index, title in
                    ChecklistRow(title: title, isDone: completedRows > index, isActive: completedRows == index)
                }
            }
            .padding(.horizontal, Theme.Spacing.xxl)
            Spacer()
            Spacer()
        }
        .sensoryFeedback(.success, trigger: finished)
        .task { await run() }
    }

    private func run() async {
        guard !started else { return }
        started = true
        // Save the answers (without finishing onboarding yet) and plan in parallel with the animation.
        profileStore.createProfile(from: state, markComplete: false)
        let planTask: Task<PlanResult, Never> = Task { @MainActor in
            await planStore.generatePlan()
        }
        for index in 0..<rows.count {
            try? await Task.sleep(nanoseconds: 700_000_000)
            withAnimation(Theme.spring) { completedRows = index + 1 }
        }
        _ = await planTask.value
        try? await Task.sleep(nanoseconds: 250_000_000)
        notifications.apply(profile: profileStore.profile)
        finished = true
        onFinished()
    }
}

private struct ChecklistRow: View {
    let title: String
    let isDone: Bool
    let isActive: Bool

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            ZStack {
                Circle().fill(isDone ? Theme.herb : Theme.creamDeep)
                if isDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(Color.white)
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                } else if isActive {
                    ProgressView().controlSize(.small).tint(Theme.tomato)
                }
            }
            .frame(width: 28, height: 28)
            Text(title)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundStyle(isDone || isActive ? Theme.aubergine : Theme.aubergineFaint)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text(isDone ? "done" : "in progress"))
    }
}

#Preview { BuildingWeekStep(state: OnboardingState()) {}.previewEnvironment().creamBackground() }
