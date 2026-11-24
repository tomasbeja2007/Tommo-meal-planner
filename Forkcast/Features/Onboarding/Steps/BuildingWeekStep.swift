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
        FoodCatalog.bundled.store(id: state.storeId)?.name ?? String(localized: "your shop")
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
            Text("Planning dinners for \(storeName)")
                .font(.subheadline)
                .foregroundStyle(Theme.aubergineMuted)
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
