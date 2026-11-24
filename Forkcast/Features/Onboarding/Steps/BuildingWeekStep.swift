import SwiftUI
import ForkcastCore

/// Full-screen loader. Runs the real planner while three rows tick on.
struct BuildingWeekStep: View {
    let state: OnboardingState
    let onFinished: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @State private var completedRows: Int = 0
    @State private var started: Bool = false
    @State private var finished: Bool = false

    private var storeName: String {
        FoodCatalog.bundled.store(id: state.storeId)?.name ?? String(localized: "your shop")
    }

    private var rows: [String] {
        [
            String(localized: "pricing ingredients at \(storeName)"),
            String(localized: "matching your tastes and rules"),
            String(localized: "writing your grocery list")
        ]
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.xxl) {
            Spacer()
            MascotView(size: 170, mood: .thinking)
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
            try? await Task.sleep(nanoseconds: 900_000_000)
            withAnimation(Theme.spring) { completedRows = index + 1 }
        }
        _ = await planTask.value
        try? await Task.sleep(nanoseconds: 350_000_000)
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
                        .transition(.scale.combined(with: .opacity))
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
