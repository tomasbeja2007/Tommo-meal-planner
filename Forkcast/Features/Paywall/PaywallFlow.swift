import SwiftUI
import StoreKit
import ForkcastCore

/// Two screens: the trial-reminder promise, then the plan selector.
struct PaywallFlow: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @State private var showsPlans: Bool = false

    var body: some View {
        ZStack {
            Theme.cream.ignoresSafeArea()
            if showsPlans || !subscriptions.isEligibleForTrial {
                PaywallView { dismiss() }
                    .transition(reduceMotion ? .identity : .move(edge: .trailing).combined(with: .opacity))
            } else {
                TrialReminderView(
                    onContinue: { withAnimation(reduceMotion ? nil : Theme.Motion.selection) { showsPlans = true } },
                    onClose: { dismiss() }
                )
                .transition(.opacity)
            }
        }
    }
}

/// "we'll remind you before your trial ends"
struct TrialReminderView: View {
    let onContinue: () -> Void
    let onClose: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @State private var daysBefore: Int = 1

    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.aubergineMuted)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel(Text("Close"))
                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.s)
            ScrollView {
                VStack(spacing: Theme.Spacing.l) {
                    Text("Want a trial reminder?")
                        .font(Theme.questionFont)
                        .foregroundStyle(Theme.aubergine)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("If you start a trial and allow notifications, Tommo can remind you before it ends.")
                        .font(.body)
                        .foregroundStyle(Theme.aubergineMuted)
                        .multilineTextAlignment(.center)
                    ReminderMascot()
                        .padding(.vertical, Theme.Spacing.l)
                    VStack(spacing: Theme.Spacing.m) {
                        OptionTile(title: String(localized: "1 day before"), subtitle: String(localized: "recommended"), systemImage: "bell", isSelected: daysBefore == 1) {
                            daysBefore = 1
                        }
                        OptionTile(title: String(localized: "2 days before"), subtitle: String(localized: "extra peace of mind"), systemImage: "bell.badge", isSelected: daysBefore == 2) {
                            daysBefore = 2
                        }
                    }
                    if notifications.isDenied {
                        VStack(spacing: Theme.Spacing.s) {
                            Text("turn on notifications so we can remind you")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Theme.tomatoDeep)
                            Button(String(localized: "Open Settings")) { notifications.openSystemSettings() }
                                .buttonStyle(QuietButtonStyle(color: Theme.tomato))
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
            }
            PrimaryButton(String(localized: "Continue")) {
                Task {
                    profileStore.profile?.trialReminderDaysBefore = daysBefore
                    profileStore.save()
                    if notifications.authorizationStatus == .notDetermined {
                        await notifications.requestAuthorization()
                    }
                    onContinue()
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.bottom, Theme.Spacing.s)
        }
        .onAppear {
            daysBefore = profileStore.profile?.trialReminderDaysBefore ?? 1
        }
        .task { await notifications.refreshStatus() }
    }
}

/// Uses the optional `MascotBell` artwork if present, otherwise the mascot + a saffron bell badge.
private struct ReminderMascot: View {
    var body: some View {
        if AssetImage.exists("MascotBell") {
            Image("MascotBell")
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
                .accessibilityLabel(Text("Chef Tommo holding a bell"))
        } else {
            MascotView(size: 160, mood: .idle)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Color.white)
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(Theme.saffron))
                        .overlay(Circle().stroke(Theme.cream, lineWidth: 4))
                        .offset(x: 10, y: -6)
                        .accessibilityHidden(true)
                }
        }
    }
}

#Preview("Paywall flow") { PaywallFlow().previewEnvironment() }
