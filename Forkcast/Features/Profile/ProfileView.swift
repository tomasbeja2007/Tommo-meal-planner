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

    @State private var showsPantry = false
    @State private var editing: PreferenceKind? = nil
    @State private var isManageShown: Bool = false
    @State private var isRedeemShown: Bool = false
    @State private var isDebugShown: Bool = false
    @State private var confirm: DangerAction? = nil
    @State private var isRestoring = false
    @State private var restoreMessage: String?
    @State private var dataDeletionFailed = false

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
                    AccountSection(profile: profile) { confirm = .deleteAll }
                }
                subscriptionSection
                if let profile = profileStore.profile {
                    PreferencesSection(profile: profile) { editing = $0 }
                    Section {
                        Button { showsPantry = true } label: {
                            Label { Text("Select ingredients") } icon: { Glyph(name: "glyph-pantry", size: 18) }
                        }
                    } header: {
                        Text("Pantry")
                    } footer: {
                        Text("Ingredients you have are excluded from this week's grocery list.")
                    }
                    .listRowBackground(Theme.card)
                    NotificationsSection(profile: profile)
                }
                Section("Meal plan") {
                    Button("Plan my week", systemImage: "calendar") {
                        router.selectedTab = .plan
                        router.planPath = NavigationPath()
                        if planStore.hasPlan {
                            router.gate(isPro: subscriptions.hasProAccess) { router.isWeekEditorPresented = true }
                        } else {
                            Task { await planStore.generatePlan() }
                        }
                    }
                    Button(role: .destructive) { confirm = .resetPlan } label: {
                        Label("Reset my current meal plan", systemImage: "trash")
                    }
                        .disabled(!planStore.hasPlan)
                }
                .listRowBackground(Theme.card)
                supportSection
                legalSection
                dangerSection
                FooterView { isDebugShown = true }
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "Profile"))
        }
        .sheet(isPresented: $showsPantry) { PantryEditorSheet(initial: planStore.currentOnHand) }
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
        .alert("Couldn’t delete your data", isPresented: $dataDeletionFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Try again from Profile.")
        }
    }

    // MARK: Sections

    private var subscriptionSection: some View {
        Section {
            if !subscriptions.hasProAccess {
                Button {
                    router.isPaywallPresented = true
                } label: {
                    Label(String(localized: "View subscription plans"), systemImage: "sparkles")
                        .foregroundStyle(Theme.tomato)
                }
            }
            Button(String(localized: "Manage subscription")) { isManageShown = true }
            Button(String(localized: "Restore purchases")) {
                Task {
                    isRestoring = true
                    restoreMessage = nil
                    defer { isRestoring = false }
                    do {
                        try await subscriptions.restore()
                        restoreMessage = subscriptions.isPro
                            ? String(localized: "Subscription restored.")
                            : String(localized: "No active subscription found for this Apple Account.")
                    } catch {
                        restoreMessage = String(localized: "Couldn’t restore purchases. \(error.localizedDescription)")
                    }
                }
            }
            .disabled(isRestoring)
            if isRestoring {
                ProgressView("Restoring purchases…")
            }
            if let restoreMessage {
                Text(restoreMessage).font(.footnote).foregroundStyle(Theme.aubergineMuted)
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
            // Apple's review prompt may silently not appear when tapped, so the button opens the
            // App Store's write-a-review page instead. Hidden until the App Store ID is set.
            if let review = AppLinks.writeReview {
                Link(destination: review) {
                    Label(String(localized: "Rate Tommo"), systemImage: "star")
                }
            }
            if let contact = AppLinks.mail(subject: "Hello from Tommo") {
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
            Button(String(localized: "Start over")) { confirm = .startOver }
            Button(String(localized: "Delete account and all data"), role: .destructive) { confirm = .deleteAll }
        } header: {
            Text("Danger zone")
        } footer: {
            Text("Start over re-runs the quiz. Deleting clears this app’s data on this device. If iCloud sync is active, deletions sync to iCloud.")
        }
        .foregroundStyle(Theme.tomatoDeep)
        .listRowBackground(Theme.card)
    }

    private func dangerAlert(_ action: DangerAction) -> Alert {
        switch action {
        case .resetPlan:
            return Alert(
                title: Text("Reset this week's plan?"),
                message: Text("Your meals and grocery checks for this week will be cleared."),
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
            let message: Text
            if profileStore.profile?.appleUserId != nil {
                message = Text("This can’t be undone. To revoke Sign in with Apple access, go to your Apple Account settings. Manage your subscription separately in Apple Subscriptions.")
            } else {
                message = Text("This can’t be undone. Manage your subscription separately in Apple Subscriptions.")
            }
            return Alert(
                title: Text("Delete your account and data?"),
                message: message,
                primaryButton: .destructive(Text("Delete everything")) {
                    guard let services = AppServices.current else {
                        dataDeletionFailed = true
                        return
                    }
                    do {
                        try services.deleteAllData()
                    } catch {
                        dataDeletionFailed = true
                    }
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
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                TextField(String(localized: "Your name"), text: $profile.name)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .submitLabel(.done)
                    .onSubmit { profileStore.save() }
                if let email = profile.appleEmail {
                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                        .textSelection(.enabled)
                }
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
            Text("Tommo v\(version) · made for busy weeknights")
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

struct PantryEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @State private var selection: Set<String>

    init(initial: Set<String>) {
        _selection = State(initialValue: initial)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                PantryPicker(selection: $selection, unitSystem: profileStore.unitSystem)
                    .padding(Theme.Spacing.gutter)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Pantry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        planStore.updatePantry(selection)
                        dismiss()
                    }
                }
            }
        }
    }
}
