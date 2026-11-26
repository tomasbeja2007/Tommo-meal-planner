import SwiftUI
import StoreKit
import AuthenticationServices
import ForkcastCore

/// One long page of cards: who you are, your plan settings (edited right here), then subscription,
/// notifications, account, support and the danger zone. Plan-shaping edits save instantly and
/// offer to update this week's plan.
struct ProfileView: View {
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var showsPantry = false
    @State private var editing: PreferenceKind? = nil
    @State private var isManageShown: Bool = false
    @State private var isDebugShown: Bool = false
    @State private var confirm: DangerAction? = nil
    @State private var isRestoring = false
    @State private var restoreMessage: String?
    @State private var dataDeletionFailed = false
    @State private var isNameEditorShown = false
    @State private var draftName = ""
    /// Set after an inline edit that changes which meals fit; offers to update this week's plan.
    @State private var planIsOutdated = false
    @State private var vibeLimitNudge = 0

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
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                    if let profile = profileStore.profile {
                        ProfileHeaderCard(profile: profile) {
                            draftName = profile.name
                            isNameEditorShown = true
                        }
                        mealPlanGroup(profile)
                        householdGroup(profile)
                        appliancesGroup(profile)
                        eatingStyleGroup(profile)
                        vibesGroup(profile)
                        allergiesGroup(profile)
                        dislikesGroup(profile)
                        pantryCard
                        planActions
                        subscriptionGroup
                        ProfileGroup(title: String(localized: "Notifications")) {
                            NotificationsSection(profile: profile)
                        }
                        ProfileGroup(
                            title: String(localized: "Account"),
                            footer: String(localized: "Sign in with Apple is optional. Your iCloud account controls sync.")
                        ) {
                            AccountSection(profile: profile) { confirm = .deleteAll }
                        }
                    }
                    supportGroup
                    dangerGroup
                    FooterView { isDebugShown = true }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.s)
                .padding(.bottom, Theme.Size.tabBarClearance)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "Profile"))
        }
        .sheet(isPresented: $showsPantry) { PantryEditorSheet(initial: planStore.currentOnHand) }
        .sheet(item: $editing) { kind in
            PreferenceEditorSheet(kind: kind)
        }
        .manageSubscriptionsSheet(isPresented: $isManageShown)
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
        .alert(String(localized: "Your name"), isPresented: $isNameEditorShown) {
            TextField(String(localized: "Your name"), text: $draftName)
                .textInputAutocapitalization(.words)
            Button(String(localized: "Save")) {
                let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty, let profile = profileStore.profile else { return }
                profile.name = trimmed
                profileStore.save()
            }
            Button(String(localized: "Cancel"), role: .cancel) {}
        }
        .sensoryFeedback(.warning, trigger: vibeLimitNudge)
    }

    // MARK: Saving inline edits

    /// Saves an edit made on this page. Plan-shaping edits offer to update this week's plan.
    private func commit(affectsPlan: Bool = true) {
        profileStore.save()
        planStore.recompute()
        if affectsPlan && planStore.hasPlan {
            withAnimation(reduceMotion ? nil : Theme.Motion.update) { planIsOutdated = true }
        }
    }

    // MARK: Meal plan

    private func mealPlanGroup(_ profile: UserProfile) -> some View {
        ProfileGroup(title: String(localized: "Meal plan")) {
            ProfileRow(
                glyph: "glyph-cost",
                title: String(localized: "Weekly budget"),
                subtitle: String(localized: "Your weekly budget at \(profileStore.storeName)"),
                value: profileStore.formatMoney(profile.weeklyBudget),
                emphasisedValue: true
            ) { editing = .budget }
            ProfileDivider()
            ProfileRow(glyph: "glyph-store", title: String(localized: "Shopping at"), value: profileStore.storeName) { editing = .store }
            ProfileDivider()
            ProfileRow(
                glyph: "glyph-calories",
                title: String(localized: "Nutrition goals"),
                subtitle: nutritionSubtitle(profile),
                value: profile.nutritionTarget.map { String(localized: "\($0.calories.formatted()) kcal") } ?? String(localized: "Off")
            ) { editing = .nutrition }
            ProfileDivider()
            ProfileRow(systemImage: "fork.knife", title: String(localized: "Meals"), value: MealType.ordered(profile.mealTypes).map { $0.title }.joined(separator: ", ")) { editing = .meals }
            ProfileDivider()
            ProfileRow(systemImage: "calendar", title: String(localized: "Cooking days"), value: String(localized: "\(profile.cookingDays.count) a week")) { editing = .cookingDays }
            ProfileDivider()
            ProfileRow(glyph: "glyph-time", title: String(localized: "Max cook time"), value: profile.maxCookMinutes == 0 ? String(localized: "Any") : String(localized: "\(profile.maxCookMinutes) min")) { editing = .cookTime }
            ProfileDivider()
            ProfileRow(systemImage: "globe", title: String(localized: "Country"), value: "\(profileStore.country.flagEmoji) \(profileStore.country.name)") { editing = .country }
            ProfileDivider()
            ProfileRow(systemImage: "ruler", title: String(localized: "Units"), value: profileStore.unitSystem == .imperial ? String(localized: "Imperial") : String(localized: "Metric")) { editing = .units }
            ProfileDivider()
            ProfileToggleRow(
                systemImage: "book",
                title: String(localized: "Include my recipes"),
                subtitle: String(localized: "Recipes you created can appear in your plans"),
                isOn: Binding(
                    get: { profile.includeUserRecipesInPlans },
                    set: { profile.includeUserRecipesInPlans = $0; commit() }
                )
            )
        }
    }

    private func nutritionSubtitle(_ profile: UserProfile) -> String? {
        guard let target = profile.nutritionTarget else { return String(localized: "No daily target") }
        let macros = target.grams
        return String(localized: "\(macros.protein) g protein · \(macros.carbs) g carbs · \(macros.fat) g fat")
    }

    // MARK: Household

    private func householdGroup(_ profile: UserProfile) -> some View {
        ProfileGroup(title: String(localized: "Household")) {
            ProfileStepperRow(
                title: String(localized: "Adults"),
                subtitle: String(localized: "full portions"),
                value: Binding(get: { profile.householdAdults }, set: { profile.householdAdults = $0; commit() }),
                range: 1...10
            )
            ProfileDivider()
            ProfileStepperRow(
                title: String(localized: "Kids"),
                subtitle: String(localized: "half portions"),
                value: Binding(get: { profile.householdKids }, set: { profile.householdKids = $0; commit() }),
                range: 0...10
            )
        }
    }

    // MARK: Chip groups

    private func appliancesGroup(_ profile: UserProfile) -> some View {
        ProfileGroup(title: String(localized: "Kitchen appliances")) {
            ChipCard(footnote: String(localized: "Select the appliances you have.")) {
                ForEach(Appliance.allCases, id: \.self) { appliance in
                    SelectChip(title: appliance.displayName, systemImage: appliance.systemImage, isSelected: profile.appliances.contains(appliance)) {
                        var set = profile.appliances
                        if set.contains(appliance) {
                            guard set.count > 1 else { return }  // At least one way to cook.
                            set.remove(appliance)
                        } else {
                            set.insert(appliance)
                        }
                        profile.appliances = set
                        commit()
                    }
                }
            }
        }
    }

    private func eatingStyleGroup(_ profile: UserProfile) -> some View {
        ProfileGroup(title: String(localized: "Eating style")) {
            ChipCard(footnote: String(localized: "Pick one diet, plus any extras.")) {
                ForEach(Diet.allCases, id: \.self) { diet in
                    SelectChip(title: diet == .none ? String(localized: "No restrictions") : diet.displayName, emoji: dietEmoji(diet), isSelected: profile.diet == diet) {
                        profile.diet = diet
                        commit()
                    }
                }
                ForEach(ExtraDiet.allCases) { extra in
                    let picked = profile.onboardingAnswers.extraDiets.contains(extra.rawValue)
                    SelectChip(title: extra.title, emoji: extraEmoji(extra), isSelected: picked) {
                        var answers = profile.onboardingAnswers
                        if picked {
                            answers.extraDiets.removeAll { $0 == extra.rawValue }
                        } else {
                            answers.extraDiets.append(extra.rawValue)
                        }
                        profile.onboardingAnswers = answers
                        commit()
                    }
                }
            }
        }
    }

    private func dietEmoji(_ diet: Diet) -> String {
        switch diet {
        case .none: return "🍽️"
        case .vegetarian: return "🥕"
        case .vegan: return "🌱"
        case .pescatarian: return "🐟"
        }
    }

    private func extraEmoji(_ extra: ExtraDiet) -> String {
        switch extra {
        case .highProtein: return "💪"
        case .lowCalorie: return "🥗"
        case .mediterranean: return "🫒"
        }
    }

    private func vibesGroup(_ profile: UserProfile) -> some View {
        let picked = Set(profile.vibes)
        let options: [Vibe] = VibePicker.featured + [.highProtein, .lowCalorie].filter { picked.contains($0) }
        return ProfileGroup(title: String(localized: "What kind of vibe?")) {
            ChipCard(footnote: String(localized: "\(picked.count) of 3 picked")) {
                ForEach(options, id: \.self) { vibe in
                    let details = VibePicker.details(for: vibe)
                    SelectChip(title: details.0, systemImage: details.2, isSelected: picked.contains(vibe)) {
                        var vibes = profile.vibes
                        if let index = vibes.firstIndex(of: vibe) {
                            vibes.remove(at: index)
                        } else if vibes.count >= 3 {
                            vibeLimitNudge += 1
                            return
                        } else {
                            vibes.append(vibe)
                        }
                        profile.vibes = vibes
                        commit()
                    }
                }
            }
        }
    }

    private func allergiesGroup(_ profile: UserProfile) -> some View {
        ProfileGroup(title: String(localized: "Allergies & intolerances")) {
            ChipCard(footnote: String(localized: "A hard filter: recipes with these are left out of every plan. Always check labels for allergens and cross-contact.")) {
                SelectChip(title: String(localized: "None"), emoji: "👍", isSelected: profile.allergens.isEmpty) {
                    profile.allergens = []
                    commit()
                }
                ForEach(Allergen.allCases, id: \.self) { allergen in
                    SelectChip(title: allergen.displayName, emoji: allergen.emoji, isSelected: profile.allergens.contains(allergen)) {
                        var set = profile.allergens
                        if set.contains(allergen) { set.remove(allergen) } else { set.insert(allergen) }
                        profile.allergens = set
                        commit()
                    }
                }
            }
        }
    }

    private func dislikesGroup(_ profile: UserProfile) -> some View {
        ProfileGroup(title: String(localized: "Foods to skip")) {
            DislikesPicker(
                selection: Binding(get: { profile.dislikedIngredientIds }, set: { profile.dislikedIngredientIds = $0; commit() }),
                unitSystem: profileStore.unitSystem
            )
            .padding(Theme.Spacing.l)
        }
    }

    // MARK: Pantry and plan actions

    private var pantryCard: some View {
        Button { showsPantry = true } label: {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text("What ingredients do you currently have?")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                Text("They're left off this week's grocery list.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                HStack {
                    Glyph(name: "glyph-pantry", size: 16)
                        .foregroundStyle(Theme.tomato)
                    Text(planStore.currentOnHand.isEmpty ? String(localized: "Select ingredients") : String(localized: "\(planStore.currentOnHand.count) selected"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.aubergineMuted)
                }
                .padding(.top, Theme.Spacing.s)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var planActions: some View {
        VStack(spacing: Theme.Spacing.m) {
            if planIsOutdated {
                HStack(spacing: Theme.Spacing.s) {
                    Text("Changes apply to your next plan.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergine)
                    Spacer(minLength: Theme.Spacing.s)
                    Button(String(localized: "Update now")) {
                        router.gate(isPro: subscriptions.hasProAccess) {
                            planIsOutdated = false
                            Task { await planStore.regenerate(keepCookedAndLiked: true) }
                        }
                    }
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.tomatoDeep)
                }
                .padding(Theme.Spacing.m)
                .background(RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous).fill(Theme.saffronSoft))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            PrimaryButton(String(localized: "Plan my week")) {
                router.selectedTab = .plan
                router.planPath = NavigationPath()
                if planStore.hasPlan {
                    router.gate(isPro: subscriptions.hasProAccess) { router.isWeekEditorPresented = true }
                } else {
                    Task { _ = await planStore.generatePlan() }
                }
            }
            Button(String(localized: "Reset my current meal plan")) { confirm = .resetPlan }
                .buttonStyle(SecondaryButtonStyle(outlined: true))
                .disabled(!planStore.hasPlan)
                .opacity(planStore.hasPlan ? 1 : 0.5)
        }
    }

    // MARK: Subscription

    private var subscriptionGroup: some View {
        ProfileGroup(title: String(localized: "Subscription"), footer: restoreMessage) {
            ProfileRow(systemImage: "sparkles", title: String(localized: "Tommo Pro"), value: subscriptions.statusText) {
                if subscriptions.hasProAccess { isManageShown = true } else { router.isPaywallPresented = true }
            }
            ProfileDivider()
            ProfileRow(systemImage: "creditcard", title: String(localized: "Manage subscription")) { isManageShown = true }
            ProfileDivider()
            ProfileRow(systemImage: "arrow.clockwise", title: isRestoring ? String(localized: "Restoring purchases…") : String(localized: "Restore purchases")) {
                guard !isRestoring else { return }
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
        }
    }

    // MARK: Support, legal, danger zone

    private var supportGroup: some View {
        ProfileGroup(title: String(localized: "Support & legal")) {
            // Apple's review prompt may silently not appear when tapped, so this opens the
            // App Store's write-a-review page instead. Hidden until the App Store ID is set.
            if let review = AppLinks.writeReview {
                ProfileLinkRow(systemImage: "star", title: String(localized: "Rate Tommo"), destination: review)
                ProfileDivider()
            }
            if let feature = AppLinks.mail(subject: "Feature request") {
                ProfileLinkRow(systemImage: "lightbulb", title: String(localized: "Request a feature"), destination: feature)
                ProfileDivider()
            }
            if let contact = AppLinks.mail(subject: "Hello from Tommo") {
                ProfileLinkRow(systemImage: "envelope", title: String(localized: "Email support"), subtitle: AppLinks.supportEmail, destination: contact)
                ProfileDivider()
            }
            ProfileLinkRow(systemImage: "doc.text", title: String(localized: "Terms of Use"), destination: AppLinks.terms)
            ProfileDivider()
            ProfileLinkRow(systemImage: "hand.raised", title: String(localized: "Privacy Policy"), destination: AppLinks.privacyPolicy)
        }
    }

    private var dangerGroup: some View {
        ProfileGroup(
            title: String(localized: "Danger zone"),
            footer: String(localized: "Start over re-runs the quiz. Deleting clears this app’s data on this device. If iCloud sync is active, deletions sync to iCloud.")
        ) {
            ProfileRow(systemImage: "arrow.counterclockwise", title: String(localized: "Start over"), showsChevron: false) { confirm = .startOver }
            ProfileDivider()
            ProfileRow(systemImage: "trash", title: String(localized: "Delete account and all data"), tint: Theme.tomatoDeep, showsChevron: false) { confirm = .deleteAll }
        }
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
