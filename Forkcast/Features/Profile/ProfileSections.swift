import SwiftUI
import AuthenticationServices
import ForkcastCore

/// Every preference opens the same editor component used in onboarding.
enum PreferenceKind: String, Identifiable, CaseIterable {
    case country
    case store
    case household
    case meals
    case cookingDays
    case budget
    case vibes
    case diet
    case nutrition
    case allergies
    case dislikes
    case appliances
    case cookTime
    case units

    var id: String { rawValue }

    var title: String {
        switch self {
        case .country: return String(localized: "Country")
        case .store: return String(localized: "Shopping at")
        case .household: return String(localized: "Household")
        case .meals: return String(localized: "Meals")
        case .cookingDays: return String(localized: "Cooking days")
        case .budget: return String(localized: "Weekly budget")
        case .vibes: return String(localized: "What kind of vibe?")
        case .diet: return String(localized: "Diet")
        case .nutrition: return String(localized: "Nutrition goals")
        case .allergies: return String(localized: "Allergies")
        case .dislikes: return String(localized: "Foods to skip")
        case .appliances: return String(localized: "Appliances")
        case .cookTime: return String(localized: "Max cook time")
        case .units: return String(localized: "Units")
        }
    }

    var systemImage: String {
        switch self {
        case .country: return "globe"
        case .store: return "basket"
        case .household: return "person.2"
        case .meals: return "fork.knife"
        case .cookingDays: return "calendar"
        case .budget: return "banknote"
        case .vibes: return "sparkles"
        case .diet: return "leaf"
        case .nutrition: return "target"
        case .allergies: return "exclamationmark.shield"
        case .dislikes: return "hand.thumbsdown"
        case .appliances: return "oven"
        case .cookTime: return "timer"
        case .units: return "ruler"
        }
    }

    /// Whether changing it should offer to update this week's plan.
    var affectsPlan: Bool { self != .units && self != .nutrition }
}

struct PreferencesSection: View {
    @Bindable var profile: UserProfile
    let onEdit: (PreferenceKind) -> Void
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        Section {
            ForEach(PreferenceKind.allCases) { kind in
                Button {
                    onEdit(kind)
                } label: {
                    HStack(spacing: Theme.Spacing.s) {
                        ViewThatFits(in: .horizontal) {
                            HStack {
                                preferenceTitle(kind)
                                Spacer(minLength: Theme.Spacing.s)
                                preferenceSummary(kind)
                            }
                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                preferenceTitle(kind)
                                preferenceSummary(kind)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Theme.aubergineFaint)
                            .accessibilityHidden(true)
                    }
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
            }
            Toggle(isOn: Binding<Bool>(
                get: { profile.includeUserRecipesInPlans },
                set: { newValue in
                    profile.includeUserRecipesInPlans = newValue
                    profileStore.save()
                }
            )) {
                Label(String(localized: "Include my recipes in auto-plans"), systemImage: "book")
                    .foregroundStyle(Theme.aubergine)
            }
            .tint(Theme.tomato)
        } header: {
            Text("Preferences")
        }
        .listRowBackground(Theme.card)
    }

    private func preferenceTitle(_ kind: PreferenceKind) -> some View {
        Label(kind.title, systemImage: kind.systemImage)
            .foregroundStyle(Theme.aubergine)
    }

    private func preferenceSummary(_ kind: PreferenceKind) -> some View {
        Text(summary(kind))
            .font(.subheadline)
            .foregroundStyle(Theme.aubergineMuted)
    }

    private func summary(_ kind: PreferenceKind) -> String {
        switch kind {
        case .country: return "\(profileStore.country.flagEmoji) \(profileStore.country.name)"
        case .store: return profileStore.storeName
        case .household:
            return String(localized: "\(profile.householdAdults) adults · \(profile.householdKids) kids")
        case .meals: return MealType.ordered(profile.mealTypes).map { $0.title }.joined(separator: ", ")
        case .cookingDays: return String(localized: "\(profile.cookingDays.count) a week")
        case .budget: return profileStore.formatMoney(profile.weeklyBudget, fractionDigits: 0)
        case .vibes: return profile.vibes.map { $0.displayName }.joined(separator: ", ")
        case .diet: return profile.diet.displayName
        case .nutrition:
            guard let target = profile.nutritionTarget else { return String(localized: "No target") }
            let macros = target.grams
            return String(localized: "\(target.calories.formatted()) kcal · \(macros.protein) g protein · \(macros.carbs) g carbs · \(macros.fat) g fat")
        case .allergies: return profile.allergens.isEmpty ? String(localized: "None") : profile.allergens.map { $0.displayName }.sorted().joined(separator: ", ")
        case .dislikes: return profile.dislikedIngredientIds.isEmpty ? String(localized: "None") : "\(profile.dislikedIngredientIds.count)"
        case .appliances: return "\(profile.appliances.count)"
        case .cookTime: return profile.maxCookMinutes == 0 ? String(localized: "Any") : String(localized: "\(profile.maxCookMinutes) min")
        case .units: return profileStore.unitSystem == .imperial ? String(localized: "Imperial") : String(localized: "Metric")
        }
    }
}

struct NotificationsSection: View {
    @Bindable var profile: UserProfile
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager

    private let weekdayNames: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        Section {
            Toggle(isOn: Binding<Bool>(
                get: { profile.weeklyReminderEnabled },
                set: { newValue in
                    profile.weeklyReminderEnabled = newValue
                    applyChanges(requestPermission: newValue)
                }
            )) {
                Label(String(localized: "Weekly planning reminder"), systemImage: "calendar.badge.clock")
                    .foregroundStyle(Theme.aubergine)
            }
            .tint(Theme.tomato)
            if profile.weeklyReminderEnabled {
                Picker(String(localized: "Day"), selection: Binding<Int>(
                    get: { profile.weeklyReminderWeekday },
                    set: { profile.weeklyReminderWeekday = $0; applyChanges(requestPermission: false) }
                )) {
                    ForEach(1...7, id: \.self) { day in
                        Text(weekdayNames[day - 1]).tag(day)
                    }
                }
                Picker(String(localized: "Time"), selection: Binding<Int>(
                    get: { profile.weeklyReminderHour },
                    set: { profile.weeklyReminderHour = $0; applyChanges(requestPermission: false) }
                )) {
                    ForEach(6...22, id: \.self) { hour in
                        Text(hourLabel(hour)).tag(hour)
                    }
                }
            }
            Picker(String(localized: "Trial reminder"), selection: Binding<Int>(
                get: { profile.trialReminderDaysBefore },
                set: { newValue in
                    profile.trialReminderDaysBefore = newValue
                    profileStore.save()
                    if subscriptions.isInTrial, let end = subscriptions.trialEndDate {
                        notifications.scheduleTrialReminder(trialEnd: end, daysBefore: newValue)
                    }
                }
            )) {
                Text("1 day before").tag(1)
                Text("2 days before").tag(2)
            }
            if notifications.isDenied {
                Button(String(localized: "Notifications are off. Open Settings")) { notifications.openSystemSettings() }
                    .foregroundStyle(Theme.tomato)
            }
        } header: {
            Text("Notifications")
        }
        .foregroundStyle(Theme.aubergine)
        .listRowBackground(Theme.card)
    }

    private func applyChanges(requestPermission: Bool) {
        profileStore.save()
        Task {
            if requestPermission && notifications.authorizationStatus == .notDetermined {
                await notifications.requestAuthorization()
            }
            notifications.apply(profile: profile)
        }
    }

    private func hourLabel(_ hour: Int) -> String {
        var components = DateComponents()
        components.hour = hour
        let date: Date = Calendar.current.date(from: components) ?? Date()
        return date.formatted(date: .omitted, time: .shortened)
    }
}

struct AccountSection: View {
    @Bindable var profile: UserProfile
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppleSignInManager.self) private var appleSignIn: AppleSignInManager

    @State private var agreed = false

    var body: some View {
        Section {
            if profile.appleUserId == nil {
                TermsCheckbox(isOn: $agreed)
                SignInWithAppleButton(.signIn) { request in
                    appleSignIn.configure(request)
                } onCompletion: { result in
                    if let signedIn = appleSignIn.handle(result) {
                        profileStore.attachAppleAccount(userId: signedIn.userId, givenName: signedIn.givenName, email: signedIn.email)
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 48)
                .disabled(!agreed || appleSignIn.isSigningIn)
                .opacity(agreed ? 1 : 0.4)
                if appleSignIn.isSigningIn { ProgressView("Signing in with Apple…") }
                if let error = appleSignIn.lastError {
                    Text(error).font(.caption).foregroundStyle(Theme.tomatoDeep)
                }
            } else {
                Label(String(localized: "Signed in with Apple"), systemImage: "checkmark.seal.fill")
                    .foregroundStyle(Theme.herb)
                Button(String(localized: "Sign out")) {
                    profile.appleUserId = nil
                    profile.appleEmail = nil
                    agreed = false
                    profileStore.save()
                }
                .foregroundStyle(Theme.tomatoDeep)
            }
        } header: {
            Text("Account")
        } footer: {
            Text("You can keep using Tommo without signing in.")
        }
        .listRowBackground(Theme.card)
    }
}
