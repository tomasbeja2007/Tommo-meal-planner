import SwiftUI
import ForkcastCore

/// 15. Our own pre-permission card first; the system prompt only appears if they tap
/// "Turn on reminders". "Not now" is fine. The sample notification uses their real first dinner.
struct StayOnTrackStep: View {
    let onContinue: () -> Void

    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @State private var isAsking: Bool = false

    /// "Tonight: Garlic prawn spaghetti, 20 min"
    private var sampleMessage: String {
        guard let first = planStore.meals.first, let recipe = repository.recipe(id: first.recipeId) else {
            return String(localized: "Tonight: your first dinner is ready to cook.")
        }
        let minutes: Int = recipe.prepMinutes + recipe.cookMinutes
        return String(localized: "Tonight: \(recipe.title), \(minutes) min")
    }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "stay on track"),
            subtitle: String(localized: "a nudge on the night, and one before your trial ends. That's it."),
            buttonTitle: String(localized: "Turn on reminders"),
            isButtonEnabled: !isAsking,
            secondaryTitle: String(localized: "Not now"),
            secondaryAction: onContinue,
            onContinue: ask
        ) {
            HStack(alignment: .bottom, spacing: -Theme.Spacing.l) {
                MascotView(size: 120, mood: .idle)
                    .zIndex(1)
                PhoneCard(message: sampleMessage)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, Theme.Spacing.l)
        }
    }

    private func ask() {
        isAsking = true
        Task {
            _ = await notifications.requestAuthorization()
            isAsking = false
            onContinue()
        }
    }
}

/// A phone-shaped card with one lock-screen notification on it.
private struct PhoneCard: View {
    let message: String

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            Capsule().fill(Theme.aubergine.opacity(0.85)).frame(width: 54, height: 14).padding(.top, Theme.Spacing.s)
            Text(Date().formatted(.dateTime.hour().minute()))
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(Theme.aubergine.opacity(0.8))
            HStack(alignment: .top, spacing: Theme.Spacing.s) {
                Image(systemName: "fork.knife")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(width: 26, height: 26)
                    .background(RoundedRectangle(cornerRadius: 7, style: .continuous).fill(Theme.tomato))
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Forkcast").font(.caption2.weight(.bold)).foregroundStyle(Theme.aubergineMuted)
                        Spacer()
                        Text("now").font(.caption2).foregroundStyle(Theme.aubergineFaint)
                    }
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(Theme.aubergine)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(Theme.Spacing.s)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Theme.card.opacity(0.95)))
            .padding(.horizontal, Theme.Spacing.s)
            Spacer(minLength: 0)
        }
        .frame(width: 190, height: 250)
        .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Theme.saffronSoft))
        .overlay(RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(Theme.aubergine, lineWidth: 5))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Example notification: \(message)"))
    }
}

#Preview { StayOnTrackStep {}.previewEnvironment().creamBackground() }
