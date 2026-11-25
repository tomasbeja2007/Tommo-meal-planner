import SwiftUI
import UserNotifications

struct StayOnTrackStep: View {
    let onContinue: () -> Void

    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @State private var isAsking = false
    @State private var appeared = false

    var body: some View {
        QuestionScaffold(
            title: String(localized: "Stay on track with your meals"),
            buttonTitle: String(localized: "Continue"),
            isButtonEnabled: !isAsking,
            secondaryTitle: isAsking ? nil : String(localized: "Not now"),
            secondaryAction: onContinue,
            onContinue: ask
        ) {
            VStack(spacing: Theme.Spacing.xl) {
                OneShotClock(duration: 920, play: appeared) { time in
                    let progress = max(0, time - 100) / 820
                    let swing = 17 * sin(progress * .pi * 4) * pow(1 - progress, 2)
                    ZStack(alignment: .topTrailing) {
                        Circle().fill(Theme.saffronSoft)
                        Image(systemName: "bell.fill")
                            .font(.system(size: 94, weight: .medium))
                            .foregroundStyle(Theme.tomatoDeep)
                            .rotationEffect(.degrees(swing), anchor: .top)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Text("1")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(Theme.tomatoDeep, in: Circle())
                            .padding(Theme.Spacing.m)
                    }
                    .frame(width: 190, height: 190)
                    .accessibilityHidden(true)
                }
                Text("Get a weekly planning reminder and a heads-up before a trial ends. You can turn notifications off anytime.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.aubergineMuted)
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear { appeared = true }
    }

    private func ask() {
        guard !isAsking else { return }
        isAsking = true
        Task {
            await notifications.refreshStatus()
            if notifications.authorizationStatus == .notDetermined {
                await notifications.requestAuthorization()
            }
            isAsking = false
            onContinue()
        }
    }
}

#Preview { StayOnTrackStep {}.previewEnvironment().creamBackground() }
