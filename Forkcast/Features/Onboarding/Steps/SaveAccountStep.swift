import SwiftUI
import AuthenticationServices
import ForkcastCore

/// 17. Save your week: Sign in with Apple (the only account type until there's a backend).
/// Leads with their own week (three of their dishes fanned out), says plainly what signing in gives,
/// and keeps the Apple button live: agreeing to the Terms is the small print under it, not a checkbox
/// that greys the button out. "Maybe later" is always there (no account wall); the plan stays on this
/// device and in their iCloud either way.
struct SaveAccountStep: View {
    let onContinue: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(AppleSignInManager.self) private var appleSignIn: AppleSignInManager

    private var isSignedIn: Bool { profileStore.profile?.appleUserId != nil }

    private var title: String {
        let name = profileStore.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? String(localized: "save your week") : String(localized: "\(name), save your week")
    }

    /// "28 meals · ~82 € at Continente"
    private var summary: String {
        let count = planStore.meals.count
        let meals = count == 1 ? String(localized: "1 meal") : String(localized: "\(count) meals")
        let total = profileStore.formatMoney(planStore.total, fractionDigits: 0)
        return String(localized: "\(meals) · ~\(total) at \(profileStore.storeName)")
    }

    private var heroRecipes: [Recipe] {
        var seen: Set<String> = []
        let ordered = planStore.meals.filter { !$0.isSide && $0.mealType == .dinner } + planStore.meals.filter { !$0.isSide && $0.mealType != .dinner }
        return ordered.compactMap { planStore.recipe(for: $0) }.filter { seen.insert($0.id).inserted }.prefix(3).map { $0 }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.xl) {
                SavedWeekArt(recipes: heroRecipes)
                    .padding(.top, Theme.Spacing.l)
                VStack(spacing: Theme.Spacing.xs) {
                    Text(title)
                        .font(Theme.questionFont)
                        .foregroundStyle(Theme.aubergine)
                        .accessibilityAddTraits(.isHeader)
                    Text(summary)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.tomatoDeep)
                        .monospacedDigit()
                }
                .multilineTextAlignment(.center)
                VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                    benefit("person.crop.circle", String(localized: "Sign in with your Apple Account"))
                    benefit("envelope.badge.shield.half.filled", String(localized: "Keep your email private if you like"))
                    benefit("iphone", String(localized: "Your week stays on this phone either way"))
                }
                .padding(Theme.Spacing.l)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.bottom, Theme.Spacing.l)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) { actions }
    }

    @ViewBuilder
    private var actions: some View {
        VStack(spacing: Theme.Spacing.s) {
            if isSignedIn {
                Label(String(localized: "Signed in with Apple"), systemImage: "checkmark.seal.fill")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.herb)
                PrimaryButton(String(localized: "Continue"), action: onContinue)
            } else {
                SignInWithAppleButton(.continue) { request in
                    appleSignIn.configure(request)
                } onCompletion: { result in
                    guard let signedIn = appleSignIn.handle(result), profileStore.profile != nil else { return }
                    profileStore.attachAppleAccount(userId: signedIn.userId, givenName: signedIn.givenName, email: signedIn.email)
                    onContinue()
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 56)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous))
                .disabled(appleSignIn.isSigningIn)
                if appleSignIn.isSigningIn { ProgressView("Signing in with Apple…") }
                if let error = appleSignIn.lastError {
                    Text(error).font(.caption).foregroundStyle(Theme.tomatoDeep)
                }
                Text(termsText)
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineMuted)
                    .tint(Theme.aubergine)
                    .multilineTextAlignment(.center)
                Button(String(localized: "Maybe later"), action: onContinue)
                    .buttonStyle(QuietButtonStyle())
                    .disabled(appleSignIn.isSigningIn)
            }
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.vertical, Theme.Spacing.s)
        .background(Theme.cream.opacity(0.97).ignoresSafeArea())
    }

    private func benefit(_ symbol: String, _ text: String) -> some View {
        HStack(spacing: Theme.Spacing.m) {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.tomatoDeep)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Theme.tomatoSoft))
                .accessibilityHidden(true)
            Text(text)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
        }
    }

    /// Markdown is parsed after the URLs are filled in, so both links are tappable.
    private var termsText: AttributedString {
        let markdown: String = String(localized: "By continuing you agree to the [Terms](\(AppLinks.terms.absoluteString)) and [Privacy Policy](\(AppLinks.privacyPolicy.absoluteString)).")
        return (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
    }
}

struct TermsCheckbox: View {
    @Binding var isOn: Bool

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            Button {
                isOn.toggle()
            } label: {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isOn ? Theme.tomato : Theme.aubergineFaint)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isOn)
            .accessibilityLabel(Text("I agree to the Terms and Privacy Policy"))
            .accessibilityAddTraits(isOn ? [.isSelected] : [])
            Text(termsText)
                .font(.subheadline)
                .foregroundStyle(Theme.aubergineMuted)
                .tint(Theme.tomato)
                .padding(.top, Theme.Spacing.m)
            Spacer(minLength: 0)
        }
    }

    /// Markdown is parsed after the URLs are filled in, so both links are tappable.
    private var termsText: AttributedString {
        let markdown: String = String(localized: "I agree to the [Terms of Service](\(AppLinks.terms.absoluteString)) and [Privacy Policy](\(AppLinks.privacyPolicy.absoluteString)).")
        return (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
    }
}

/// Three of their dishes, stacked, fan out like cards being dealt (ease-out, staggered), settle on a soft
/// tomato disc, and then sway very slightly around their bottom edge on seeded phases. A small lock badge
/// lands last. One one-shot clock for the deal, one loop clock (8 s) for the idle sway.
private struct SavedWeekArt: View {
    let recipes: [Recipe]
    @State private var play = false

    private let fan: [Double] = [-11, 0, 11]
    private let shift: [CGFloat] = [-62, 0, 62]

    var body: some View {
        OneShotClock(duration: 900, play: play) { t in
            LoopClock(period: 8_000) { l in
                ZStack {
                    Circle()
                        .fill(Theme.tomatoSoft)
                        .frame(width: 210, height: 210)
                        .scaleEffect(0.92 + 0.08 * seg(t, 0, 420))
                    ForEach(Array(recipes.enumerated()), id: \.offset) { index, recipe in
                        let slot = recipes.count == 1 ? 1 : (recipes.count == 2 ? [0, 2][index] : index)
                        let deal = seg(t, 120 + Double(index) * 90, 620 + Double(index) * 90)
                        let sway = 1.2 * wave(l, period: [4_000, 8_000, 2_000][slot], phase: seeded(index))
                        DishTileView(recipe: recipe, size: 112, cornerRadius: Theme.Radius.large)
                            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.large, style: .continuous).strokeBorder(Theme.card, lineWidth: 4))
                            .elevation(Theme.Elevation.lifted)
                            .rotationEffect(.degrees(fan[slot] * deal + sway), anchor: .bottom)
                            .offset(x: shift[slot] * deal, y: slot == 1 ? -10 * deal : 0)
                            .zIndex(slot == 1 ? 2 : 1)
                    }
                    Image(systemName: "lock.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.white)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.tomatoDeep))
                        .overlay(Circle().stroke(Theme.card, lineWidth: 3))
                        .scaleEffect(0.7 + 0.3 * seg(t, 650, 900))
                        .opacity(seg(t, 650, 800))
                        .offset(x: 70, y: 62)
                }
                .frame(height: 230)
            }
        }
        .onAppear { play = true }
        .accessibilityHidden(true)
    }
}

#Preview { SaveAccountStep {}.previewEnvironment().creamBackground() }
