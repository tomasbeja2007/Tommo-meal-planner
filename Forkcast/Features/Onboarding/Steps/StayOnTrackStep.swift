import SwiftUI

/// Explains reminders before the system prompt.
struct NotificationsPrimerStep: View {
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    let onContinue: () -> Void
    @State private var isAsking: Bool = false

    var body: some View {
        QuestionScaffold(
            title: String(localized: "can we give you a nudge?"),
            subtitle: String(localized: "we only send two kinds of reminder, and you can turn them off anytime"),
            buttonTitle: String(localized: "Continue"),
            isButtonEnabled: !isAsking,
            secondaryTitle: String(localized: "Not now"),
            secondaryAction: onContinue,
            onContinue: ask
        ) {
            VStack(spacing: Theme.Spacing.m) {
                ReminderPreviewCard(systemImage: "calendar", title: String(localized: "Sunday nudge"), message: String(localized: "your week's dinners are waiting. 2 minutes to plan, one list to shop."))
                ReminderPreviewCard(systemImage: "bell.fill", title: String(localized: "Trial heads-up"), message: String(localized: "a reminder before your free trial ends, so there are no surprises."))
            }
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

private struct ReminderPreviewCard: View {
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(width: 36, height: 36)
                .background(RoundedRectangle(cornerRadius: 9, style: .continuous).fill(Theme.tomato))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Forkcast").font(.caption.weight(.semibold)).foregroundStyle(Theme.aubergineMuted)
                    Spacer()
                    Text(title).font(.caption).foregroundStyle(Theme.aubergineFaint)
                }
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergine)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .cardStyle(padding: Theme.Spacing.m)
        .accessibilityElement(children: .combine)
    }
}

#Preview { NotificationsPrimerStep {}.previewEnvironment().creamBackground() }
