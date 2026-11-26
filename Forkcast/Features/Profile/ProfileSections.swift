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

// MARK: - Page building blocks

/// A small uppercase title over one white card, with an optional grey note under it.
struct ProfileGroup<Content: View>: View {
    let title: String
    var footer: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text(title.uppercased())
                .font(Theme.Typography.eyebrow)
                .tracking(1.1)
                .foregroundStyle(Theme.aubergineMuted)
                .padding(.leading, Theme.Spacing.xs)
                .accessibilityAddTraits(.isHeader)
            VStack(alignment: .leading, spacing: 0) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
            .elevation(Theme.Elevation.card)
            if let footer, !footer.isEmpty {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(Theme.aubergineMuted)
                    .padding(.horizontal, Theme.Spacing.xs)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ProfileDivider: View {
    var body: some View {
        Rectangle()
            .fill(Theme.line)
            .frame(height: 1)
            .padding(.leading, Theme.Spacing.l)
    }
}

/// The rounded icon square on the left of every row: a Tommo glyph, or a symbol when there's none.
struct ProfileIconTile: View {
    var glyph: String? = nil
    var systemImage: String? = nil
    var tint: Color = Theme.aubergine

    var body: some View {
        Group {
            if let glyph {
                Glyph(name: glyph, size: 18)
            } else if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 15, weight: .semibold))
            }
        }
        .foregroundStyle(tint)
        .frame(width: 36, height: 36)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.small, style: .continuous).fill(Theme.creamDeep))
        .accessibilityHidden(true)
    }
}

/// Icon tile · title (+ grey subtitle) · value · chevron. The whole row is the button.
struct ProfileRow: View {
    var glyph: String? = nil
    var systemImage: String? = nil
    let title: String
    var subtitle: String? = nil
    var value: String? = nil
    var emphasisedValue: Bool = false
    var tint: Color = Theme.aubergine
    var showsChevron: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ProfileRowLabel(glyph: glyph, systemImage: systemImage, title: title, subtitle: subtitle, value: value, emphasisedValue: emphasisedValue, tint: tint, showsChevron: showsChevron)
        }
        .buttonStyle(.plain)
    }
}

/// A row that opens a web page or an email.
struct ProfileLinkRow: View {
    var systemImage: String
    let title: String
    var subtitle: String? = nil
    let destination: URL

    var body: some View {
        Link(destination: destination) {
            ProfileRowLabel(systemImage: systemImage, title: title, subtitle: subtitle)
        }
        .buttonStyle(.plain)
    }
}

struct ProfileRowLabel: View {
    var glyph: String? = nil
    var systemImage: String? = nil
    let title: String
    var subtitle: String? = nil
    var value: String? = nil
    var emphasisedValue: Bool = false
    var tint: Color = Theme.aubergine
    var showsChevron: Bool = true

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            ProfileIconTile(glyph: glyph, systemImage: systemImage, tint: tint)
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(tint)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let value, !value.isEmpty {
                Text(value)
                    .font(.system(emphasisedValue ? .headline : .subheadline, design: .rounded).weight(emphasisedValue ? .bold : .medium))
                    .foregroundStyle(emphasisedValue ? Theme.tomatoDeep : Theme.aubergineMuted)
                    .monospacedDigit()
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
                    .layoutPriority(-1)
            }
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.aubergineFaint)
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, Theme.Spacing.l)
        .padding(.vertical, Theme.Spacing.m)
        .frame(minHeight: 60)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

struct ProfileToggleRow: View {
    var glyph: String? = nil
    var systemImage: String? = nil
    let title: String
    var subtitle: String? = nil
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: Theme.Spacing.m) {
                ProfileIconTile(glyph: glyph, systemImage: systemImage)
                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text(title)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(Theme.aubergineMuted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .tint(Theme.tomato)
        .padding(.horizontal, Theme.Spacing.l)
        .padding(.vertical, Theme.Spacing.m)
        .frame(minHeight: 60)
    }
}

/// "Adults · full portions      ( − )  2  ( + )"
struct ProfileStepperRow: View {
    let title: String
    var subtitle: String? = nil
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                }
            }
            Spacer(minLength: Theme.Spacing.s)
            RoundStepper(value: $value, range: range)
        }
        .padding(.horizontal, Theme.Spacing.l)
        .padding(.vertical, Theme.Spacing.m)
        .accessibilityElement(children: .contain)
    }
}

/// Wrapping chips inside a card, with a grey note under them.
struct ChipCard<Content: View>: View {
    var footnote: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            FlowLayout(spacing: Theme.Spacing.s) {
                content()
            }
            if let footnote {
                Text(footnote)
                    .font(.footnote)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Theme.Spacing.l)
    }
}

/// A choice chip for the profile. Picked: filled aubergine with a tick. Not picked: white with a hairline.
struct SelectChip: View {
    let title: String
    var systemImage: String? = nil
    var emoji: String? = nil
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.inline) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                        .transition(.scale.combined(with: .opacity))
                } else if let emoji {
                    Text(emoji).font(.subheadline)
                } else if let systemImage {
                    Image(systemName: systemImage)
                        .font(.caption.weight(.semibold))
                }
                Text(title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? Color.white : Theme.aubergine)
            .padding(.horizontal, Theme.Spacing.m)
            .padding(.vertical, Theme.Spacing.s)
            .frame(minHeight: 40)
            .background(Capsule().fill(isSelected ? Theme.aubergine : Theme.card))
            .overlay(Capsule().stroke(isSelected ? Color.clear : Theme.line, lineWidth: 1))
            .contentShape(Capsule())
            .animation(reduceMotion ? nil : Theme.Motion.update, value: isSelected)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

/// Initials, name, email (or shop) and the Pro status, with "Edit ›" for the name.
struct ProfileHeaderCard: View {
    @Bindable var profile: UserProfile
    let onEdit: () -> Void
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager

    private var initials: String {
        let parts = profile.name.split(separator: " ").prefix(2)
        let letters = parts.compactMap { $0.first }.map { String($0) }.joined()
        return letters.isEmpty ? "🙂" : letters.uppercased()
    }

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Text(initials)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(Color.white)
                .frame(width: 64, height: 64)
                .background(Circle().fill(Theme.tomato))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                Text(profile.name.isEmpty ? String(localized: "Your name") : profile.name)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .lineLimit(1)
                Text(profile.appleEmail ?? String(localized: "shopping at \(profileStore.storeName)"))
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                    .lineLimit(1)
                TagLabel(
                    text: subscriptions.statusText,
                    tint: subscriptions.hasProAccess ? Theme.tomatoDeep : Theme.aubergineMuted,
                    fill: subscriptions.hasProAccess ? Theme.tomatoSoft : Theme.creamDeep
                )
                .padding(.top, Theme.Spacing.xxs)
            }
            Spacer(minLength: Theme.Spacing.s)
            Button(action: onEdit) {
                HStack(spacing: Theme.Spacing.xxs) {
                    Text("Edit")
                    Image(systemName: "chevron.right").font(.caption.weight(.bold))
                }
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.tomatoDeep)
                .frame(minHeight: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Edit name"))
        }
        .padding(Theme.Spacing.l)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.large, style: .continuous).fill(Theme.card))
        .elevation(Theme.Elevation.card)
    }
}

// MARK: - Notifications

struct NotificationsSection: View {
    @Bindable var profile: UserProfile
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager

    private let weekdayNames: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        ProfileToggleRow(
            glyph: "glyph-reminder",
            title: String(localized: "Weekly planning reminder"),
            isOn: Binding<Bool>(
                get: { profile.weeklyReminderEnabled },
                set: { newValue in
                    profile.weeklyReminderEnabled = newValue
                    applyChanges(requestPermission: newValue)
                }
            )
        )
        if profile.weeklyReminderEnabled {
            ProfileDivider()
            pickerRow(String(localized: "Day")) {
                Picker(String(localized: "Day"), selection: Binding<Int>(
                    get: { profile.weeklyReminderWeekday },
                    set: { profile.weeklyReminderWeekday = $0; applyChanges(requestPermission: false) }
                )) {
                    ForEach(1...7, id: \.self) { day in
                        Text(weekdayNames[day - 1]).tag(day)
                    }
                }
            }
            ProfileDivider()
            pickerRow(String(localized: "Time")) {
                Picker(String(localized: "Time"), selection: Binding<Int>(
                    get: { profile.weeklyReminderHour },
                    set: { profile.weeklyReminderHour = $0; applyChanges(requestPermission: false) }
                )) {
                    ForEach(6...22, id: \.self) { hour in
                        Text(hourLabel(hour)).tag(hour)
                    }
                }
            }
        }
        ProfileDivider()
        pickerRow(String(localized: "Trial reminder")) {
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
        }
        if notifications.isDenied {
            ProfileDivider()
            ProfileRow(systemImage: "bell.slash", title: String(localized: "Notifications are off"), subtitle: String(localized: "Open Settings to turn them on"), tint: Theme.tomatoDeep) {
                notifications.openSystemSettings()
            }
        }
    }

    private func pickerRow<P: View>(_ title: String, @ViewBuilder picker: () -> P) -> some View {
        HStack(spacing: Theme.Spacing.m) {
            Text(title)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
            Spacer(minLength: Theme.Spacing.s)
            picker()
                .pickerStyle(.menu)
                .labelsHidden()
                .tint(Theme.tomatoDeep)
        }
        .padding(.horizontal, Theme.Spacing.l)
        .padding(.vertical, Theme.Spacing.s)
        .frame(minHeight: 52)
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

// MARK: - Account

struct AccountSection: View {
    @Bindable var profile: UserProfile
    /// Opens the "delete account and data" confirmation (App Review 5.1.1(v)).
    var onDeleteAccount: () -> Void = {}
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppleSignInManager.self) private var appleSignIn: AppleSignInManager

    @State private var agreed = false

    var body: some View {
        if profile.appleUserId == nil {
            VStack(alignment: .leading, spacing: Theme.Spacing.m) {
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
            }
            .padding(Theme.Spacing.l)
        } else {
            ProfileRowLabel(systemImage: "checkmark.seal.fill", title: String(localized: "Signed in with Apple"), subtitle: profile.appleEmail, showsChevron: false)
            ProfileDivider()
            ProfileRow(systemImage: "rectangle.portrait.and.arrow.right", title: String(localized: "Sign out"), showsChevron: false) {
                profile.appleUserId = nil
                profile.appleEmail = nil
                agreed = false
                profileStore.save()
            }
            ProfileDivider()
            ProfileLinkRow(systemImage: "person.crop.circle", title: String(localized: "Manage Sign in with Apple"), destination: AppLinks.appleAccount)
        }
        ProfileDivider()
        ProfileRow(systemImage: "person.crop.circle.badge.xmark", title: String(localized: "Delete account"), subtitle: String(localized: "Erases Tommo’s data on this iPhone, and in iCloud when sync is on"), tint: Theme.tomatoDeep, showsChevron: false, action: onDeleteAccount)
    }
}
