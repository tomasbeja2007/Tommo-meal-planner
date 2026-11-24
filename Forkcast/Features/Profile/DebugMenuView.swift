import SwiftUI
import ForkcastCore

/// Hidden test menu (DEBUG builds): long-press the version number in the You tab.
struct DebugMenuView: View {
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State private var status: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Subscription") {
                    Toggle("Pro override", isOn: Binding<Bool>(
                        get: { subscriptions.debugProOverride },
                        set: { subscriptions.setDebugProOverride($0) }
                    ))
                    LabeledContent("StoreKit isPro", value: subscriptions.isPro ? "yes" : "no")
                    LabeledContent("In trial", value: subscriptions.isInTrial ? "yes" : "no")
                    LabeledContent("bypassPaywall flag", value: FeatureFlags.bypassPaywall ? "on" : "off")
                    Button("Show paywall") {
                        dismiss()
                        router.isPaywallPresented = true
                    }
                }
                Section("Plan") {
                    Button("Generate next week") {
                        Task {
                            await planStore.generateNextWeek()
                            status = "Next week generated"
                        }
                    }
                    Button("Show plan reveal toast") {
                        dismiss()
                        router.selectedTab = .plan
                        router.showPlanReveal = true
                    }
                    Button("Ask for weekly feedback again") {
                        planStore.currentPlan?.feedbackGiven = false
                        planStore.saveAndRefresh()
                        status = "Feedback card re-enabled (shows on/after the last dinner)"
                    }
                }
                Section("Onboarding") {
                    Button("Reset onboarding") {
                        dismiss()
                        router.popToRoot()
                        profileStore.resetOnboarding()
                    }
                }
                Section("Notifications") {
                    Button("Trial reminder in ~1 minute") {
                        notifications.scheduleTrialReminder(trialEnd: Date().addingTimeInterval(24 * 3600 + 60), daysBefore: 1)
                        status = "Scheduled"
                    }
                    LabeledContent("Status", value: "\(notifications.authorizationStatus.rawValue)")
                }
                Section("Storage") {
                    LabeledContent("Local fallback store", value: PersistenceController.isUsingLocalFallback ? "yes" : "no (CloudKit)")
                }
                if !status.isEmpty {
                    Section { Text(status).foregroundStyle(Theme.herb) }
                }
            }
            .navigationTitle("Debug")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
    }
}
