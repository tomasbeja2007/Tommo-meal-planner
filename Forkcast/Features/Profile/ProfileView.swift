import SwiftUI
import StoreKit
import AuthenticationServices
import ForkcastCore

struct ProfileView: View {
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(\.requestReview) private var requestReview: RequestReviewAction

    @State private var editing: PreferenceKind? = nil
    @State private var isManageShown: Bool = false
    @State private var isRedeemShown: Bool = false
    @State private var isDebugShown: Bool = false
    @State private var confirm: DangerAction? = nil

    enum DangerAction: Identifiable {
        case resetPlan
        case startOver
        case deleteAll

        var id: Int {
            switch self {
            case .resetPlan: return 0
            case .startOver: return 1
            case .deleteAll: return 2
            }
        }
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.youPath) {
            List {
                if let profile = profileStore.profile {
                    ProfileCard(profile: profile)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    PreferencesSection(profile: profile) { editing = $0 }
                    NotificationsSection(profile: profile)
                    AccountSection(profile: profile)
                }
                subscriptionSection
                supportSection
                legalSection
                dangerSection
                FooterView { isDebugShown = true }
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "You"))
        }
        .sheet(item: $editing) { kind in
            PreferenceEditorSheet(kind: kind)
        }
        .manageSubscriptionsSheet(isPresented: $isManageShown)
        .offerCodeRedemption(isPresented: $isRedeemShown) { _ in
            Task { await subscriptions.refreshEntitlements() }
        }
        .sheet(isPresented: $isDebugShown) {
            DebugMenuView()
        }
        .alert(item: $confirm) { action in
            dangerAlert(action)
        }
    }

    // MARK: Sections

    private var subscriptionSection: some View {
        Section {
            if !subscriptions.hasProAccess {
                Button {
                    router.isPaywallPresented = true
                } label: {
                    Label(String(localized: "Start free trial"), systemImage: "sparkles")
                        .foregroundStyle(Theme.tomato)
                }
            }
            Button(String(localized: "Manage subscription")) { isManageShown = true }
            Button(String(localized: "Restore purchases")) {
                Task { await subscriptions.restore() }
            }
            Button(String(localized: "Redeem code")) { isRedeemShown = true }
        } header: {
            Text("Subscription")
        }
        .foregroundStyle(Theme.aubergine)
        .listRowBackground(Theme.card)
    }

    private var supportSection: some View {
        Section {
            Button {
                requestReview()
            } label: {
                Label(String(localized: "Rate Forkcast"), systemImage: "star")
            }
            if let contact = AppLinks.mail(subject: "Hello from Forkcast") {
                Link(destination: contact) {
                    Label(String(localized: "Contact us"), systemImage: "envelope")
                }
            }
            if let feature = AppLinks.mail(subject: "Feature request") {
                Link(destination: feature) {
                    Label(String(localized: "Request a feature"), systemImage: "lightbulb")
                }
            }
        } header: {
            Text("Support")
        }
        .foregroundStyle(Theme.aubergine)
        .listRowBackground(Theme.card)
    }

    private var legalSection: some View {
        Section {
            Link(String(localized: "Privacy Policy"), destination: AppLinks.privacyPolicy)
            Link(String(localized: "Terms"), destination: AppLinks.terms)
        } header: {
            Text("Legal")
        }
        .foregroundStyle(Theme.aubergine)
        .listRowBackground(Theme.card)
    }

    private var dangerSection: some View {
        Section {
            Button(String(localized: "Reset this week's plan")) { confirm = .resetPlan }
            Button(String(localized: "Start over")) { confirm = .startOver }
            Button(String(localized: "Delete all my data"), role: .destructive) { confirm = .deleteAll }
        } header: {
            Text("Danger zone")
        } footer: {
            Text("Start over re-runs the quiz and keeps your subscription. Deleting removes your plans, recipes and preferences from this device and iCloud.")
        }
        .foregroundStyle(Theme.tomatoDeep)
        .listRowBackground(Theme.card)
    }

    private func dangerAlert(_ action: DangerAction) -> Alert {
        switch action {
        case .resetPlan:
            return Alert(
                title: Text("Reset this week's plan?"),
                message: Text("Your dinners and grocery checks for this week will be cleared."),
                primaryButton: .destructive(Text("Reset")) { planStore.resetCurrentPlan() },
                secondaryButton: .cancel()
            )
        case .startOver:
            return Alert(
                title: Text("Start over?"),
                message: Text("You'll go through the quiz again. Your subscription and recipes stay."),
                primaryButton: .default(Text("Start over")) {
                    router.popToRoot()
                    profileStore.resetOnboarding()
                },
                secondaryButton: .cancel()
            )
        case .deleteAll:
            return Alert(
                title: Text("Delete all your data?"),
                message: Text("This can't be undone. Your subscription is managed by Apple and isn't affected."),
                primaryButton: .destructive(Text("Delete everything")) {
                    AppServices.current?.deleteAllData()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

/// Name (editable), store and subscription status.
private struct ProfileCard: View {
    @Bindable var profile: UserProfile
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Text(String(profile.name.first.map { String($0) } ?? "🙂").uppercased())
                .font(.system(.title, design: .rounded).weight(.bold))
                .foregroundStyle(Color.white)
                .frame(width: 60, height: 60)
                .background(Circle().fill(Theme.tomato))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                TextField(String(localized: "Your name"), text: $profile.name)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .submitLabel(.done)
                    .onSubmit { profileStore.save() }
                Text("shopping at \(profileStore.storeName)")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                TagLabel(
                    text: subscriptions.statusText,
                    tint: subscriptions.hasProAccess ? Theme.tomatoDeep : Theme.aubergineMuted,
                    fill: subscriptions.hasProAccess ? Theme.tomatoSoft : Theme.creamDeep
                )
            }
            Spacer(minLength: 0)
        }
        .cardStyle()
        .padding(.vertical, Theme.Spacing.s)
    }
}

/// Footer with the hidden debug menu (long-press the version).
private struct FooterView: View {
    let onDebug: () -> Void

    private var version: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0"
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.s) {
            MascotView(size: 56, mood: .idle)
            Text("Forkcast v\(version) · made for busy weeknights")
                .font(.caption)
                .foregroundStyle(Theme.aubergineFaint)
                .onLongPressGesture(minimumDuration: 1.0) {
                    #if DEBUG
                    onDebug()
                    #endif
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.l)
    }
}

#Preview { ProfileView().previewEnvironment() }
