import SwiftUI
import ForkcastCore

// MARK: Name

/// "what should Chef Tommo call you?" The name personalises the mirror, the building screen and the reveal.
/// Optional: "Skip" in the top bar, and Continue works with an empty field.
struct NameStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void
    @FocusState private var focused: Bool

    private var trimmed: String { state.name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "first, what should Chef Tommo call you?"),
            subtitle: String(localized: "just your first name is perfect"),
            buttonTitle: trimmed.isEmpty ? String(localized: "Continue") : String(localized: "Nice to meet you, \(trimmed)"),
            reaction: trimmed.isEmpty ? .idle : .cheer,
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                TextField(String(localized: "Your name"), text: $state.name)
                    .font(Theme.Typography.title)
                    .foregroundStyle(Theme.aubergine)
                    .textContentType(.givenName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .submitLabel(.continue)
                    .focused($focused)
                    .onSubmit(onContinue)
                    .padding(.vertical, Theme.Spacing.s)
                // The underline fills in tomato as soon as there's a name (ease-out, from the left).
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.line)
                    Capsule().fill(Theme.tomato)
                        .scaleEffect(x: trimmed.isEmpty ? 0.001 : 1, anchor: .leading)
                        .animation(Animation.open(0.35), value: trimmed.isEmpty)
                }
                .frame(height: 3)
            }
        }
        .onAppear { focused = true }
    }
}

// MARK: Time saved

/// "plan your week in minutes": the user's own planning time, without and with Tommo, as two bars that
/// draw on. Personal (their cooking days) and honest (an example, said so in the footnote).
struct TimeSavedStep: View {
    let state: OnboardingState
    let onContinue: () -> Void
    @State private var appeared = false
    /// Haptic beats: the short bar lands, then the saving line.
    @State private var barLanded = false
    @State private var savedShown = false

    /// Example inputs, stated in the footnote.
    private let decidingPerDay = 10
    private let listWriting = 20
    private let withTommo = 5

    private var days: Int { max(1, state.cookingDays.count) }
    private var without: Int { decidingPerDay * days + listWriting }
    private var saved: Int { max(0, without - withTommo) }

    var body: some View {
        OneShotClock(duration: 1_900, play: appeared) { t in
            ScrollView {
                VStack(spacing: Theme.Spacing.l) {
                    MascotReaction(mood: .thinking, size: 96)
                        .opacity(seg(t, 0, 260))
                    VStack(spacing: Theme.Spacing.xs) {
                        Text("plan your week in minutes")
                            .font(Theme.questionFont)
                            .foregroundStyle(Theme.aubergine)
                            .accessibilityAddTraits(.isHeader)
                        Text("less time choosing recipes, checking cupboards and writing lists")
                            .font(.subheadline)
                            .foregroundStyle(Theme.aubergineMuted)
                    }
                    .opacity(seg(t, 60, 360))
                    .offset(y: 10 * (1 - seg(t, 60, 360)))
                    chart(at: t)
                    Text(savedLine)
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.tomatoDeep)
                        .opacity(seg(t, 1_350, 1_650))
                        .offset(y: 8 * (1 - seg(t, 1_350, 1_650)))
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(Theme.Spacing.gutter)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("About \(without) minutes a week without a plan, about \(withTommo) with Tommo. \(savedLine)"))
            }
            .scrollBounceBehavior(.basedOnSize)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: Theme.Spacing.s) {
                    PrimaryButton(String(localized: "Continue"), action: onContinue)
                    Text("Example: \(decidingPerDay) min a day deciding what to cook, \(listWriting) min writing the list")
                        .font(.footnote)
                        .foregroundStyle(Theme.aubergineMuted)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.vertical, Theme.Spacing.s)
                .background(Theme.cream)
            }
        }
        .onAppear { appeared = true }
        .sensoryFeedback(.impact(weight: .light), trigger: barLanded)
        .sensoryFeedback(.impact(weight: .medium), trigger: savedShown)
        .task {
            try? await Task.sleep(for: .milliseconds(760))
            barLanded = true
            try? await Task.sleep(for: .milliseconds(1_350 - 760))
            savedShown = true
        }
    }

    private var savedLine: String {
        saved >= 50 ? String(localized: "save about an hour every week") : String(localized: "save about \(saved) minutes every week")
    }

    /// Two bars on one baseline. The short "with Tommo" bar lands first and stays tomato;
    /// the tall "without" bar keeps growing after it, in a muted tone, and its minutes count up.
    private func chart(at t: Double) -> some View {
        let height: CGFloat = 180
        let withGrow = seg(t, 420, 760)
        let withoutGrow = seg(t, 560, 1_400)
        let withHeight = max(10, height * CGFloat(withTommo) / CGFloat(without))
        return HStack(alignment: .bottom, spacing: Theme.Spacing.xl) {
            bar(minutes: Int((Double(withTommo) * withGrow).rounded()), label: String(localized: "with Tommo"),
                height: withHeight * CGFloat(withGrow), fill: Theme.tomato, emphasised: true)
            bar(minutes: Int((Double(without) * withoutGrow).rounded()), label: String(localized: "without a plan"),
                height: height * CGFloat(withoutGrow), fill: Theme.creamDeep, emphasised: false)
        }
        .frame(height: height + 64, alignment: .bottom)
        .padding(.horizontal, Theme.Spacing.xl)
        .padding(.vertical, Theme.Spacing.l)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
        .opacity(seg(t, 300, 520))
    }

    private func bar(minutes: Int, label: String, height: CGFloat, fill: Color, emphasised: Bool) -> some View {
        VStack(spacing: Theme.Spacing.xs) {
            UnevenRoundedRectangle(topLeadingRadius: 14, bottomLeadingRadius: 4, bottomTrailingRadius: 4, topTrailingRadius: 14, style: .continuous)
                .fill(fill)
                .frame(width: 76, height: max(4, height))
            Text("\(minutes) min")
                .font(.system(.title3, design: .rounded).weight(.heavy))
                .monospacedDigit()
                .foregroundStyle(emphasised ? Theme.tomatoDeep : Theme.aubergine)
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.aubergineMuted)
        }
    }
}

// MARK: Where did you hear about us?

/// Attribution, stored as `UserProfile.referralSource`. One choice; the other options step back once
/// one is picked. Skippable.
struct HeardAboutStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    enum Source: String, CaseIterable, Identifiable {
        case instagram, tiktok, youtube, facebook, friend, appStore, search, other
        var id: String { rawValue }

        var title: String {
            switch self {
            case .instagram: return String(localized: "Instagram")
            case .tiktok: return String(localized: "TikTok")
            case .youtube: return String(localized: "YouTube")
            case .facebook: return String(localized: "Facebook")
            case .friend: return String(localized: "A friend or family")
            case .appStore: return String(localized: "App Store")
            case .search: return String(localized: "Google or another search")
            case .other: return String(localized: "Somewhere else")
            }
        }

        var emoji: String {
            switch self {
            case .instagram: return "📸"
            case .tiktok: return "🎵"
            case .youtube: return "▶️"
            case .facebook: return "👥"
            case .friend: return "💬"
            case .appStore: return "📱"
            case .search: return "🔎"
            case .other: return "✨"
            }
        }
    }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "where did you hear about us?"),
            subtitle: String(localized: "it helps a small team know what's working"),
            isButtonEnabled: state.referralSource != nil,
            onContinue: onContinue
        ) {
            VStack(spacing: Theme.Spacing.m) {
                ForEach(Source.allCases) { source in
                    OptionTile(title: source.title, emoji: source.emoji, isSelected: state.referralSource == source.rawValue) {
                        state.referralSource = source.rawValue
                    }
                    // Once one is picked, the others step back (like a single-choice question should read).
                    .opacity(state.referralSource == nil || state.referralSource == source.rawValue ? 1 : 0.45)
                    .animation(Theme.Motion.fadeIn, value: state.referralSource)
                }
            }
        }
    }
}
