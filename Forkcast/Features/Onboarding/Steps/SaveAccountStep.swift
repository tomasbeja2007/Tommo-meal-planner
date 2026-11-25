import SwiftUI
import AuthenticationServices

/// 17. Save your plan: Sign in with Apple (the only account type until there's a backend),
/// behind a Terms checkbox. Your data syncs through your own iCloud either way, so
/// "Maybe later" is always available (no account wall).
struct SaveAccountStep: View {
    let onContinue: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppleSignInManager.self) private var appleSignIn: AppleSignInManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var agreed: Bool = false

    private var isSignedIn: Bool { profileStore.profile?.appleUserId != nil }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "Save your planned meals"),
            subtitle: String(localized: "Use your Apple Account with Tommo. Your plan is available on this device either way."),
            buttonTitle: String(localized: "Continue"),
            showsButton: isSignedIn,
            onContinue: onContinue
        ) {
            VStack(spacing: Theme.Spacing.xl) {
                CloudSyncArt()
                if isSignedIn {
                    Label(String(localized: "Signed in with Apple"), systemImage: "checkmark.seal.fill")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Theme.herb)
                } else {
                    VStack(spacing: Theme.Spacing.m) {
                        TermsCheckbox(isOn: $agreed)
                        SignInWithAppleButton(.signIn) { request in
                            appleSignIn.configure(request)
                        } onCompletion: { result in
                            guard let signedIn = appleSignIn.handle(result), profileStore.profile != nil else { return }
                            profileStore.attachAppleAccount(userId: signedIn.userId, givenName: signedIn.givenName, email: signedIn.email)
                            onContinue()
                        }
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous))
                        .disabled(!agreed || appleSignIn.isSigningIn)
                        .opacity(agreed ? 1 : 0.4)
                        .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: agreed)
                        if appleSignIn.isSigningIn { ProgressView("Signing in with Apple…") }
                        if let error = appleSignIn.lastError {
                            Text(error).font(.caption).foregroundStyle(Theme.tomatoDeep)
                        }
                        Button(String(localized: "Maybe later"), action: onContinue)
                            .buttonStyle(QuietButtonStyle())
                            .disabled(appleSignIn.isSigningIn)
                    }
                }
            }
        }
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
                .padding(.top, 11)
            Spacer(minLength: 0)
        }
    }

    /// Markdown is parsed after the URLs are filled in, so both links are tappable.
    private var termsText: AttributedString {
        let markdown: String = String(localized: "I agree to the [Terms of Service](\(AppLinks.terms.absoluteString)) and [Privacy Policy](\(AppLinks.privacyPolicy.absoluteString)).")
        return (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
    }
}

/// The plan, connecting path and cloud appear in sequence.
private struct CloudSyncArt: View {
    @State private var appeared = false

    var body: some View {
        OneShotClock(duration: 560, play: appeared) { time in
            HStack(spacing: Theme.Spacing.s) {
                ZStack {
                    Image(systemName: "iphone").font(.system(size: 79, weight: .medium))
                        .foregroundStyle(Theme.aubergine)
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 27, weight: .semibold))
                        .foregroundStyle(Theme.herb)
                        .opacity(min(1, time / 180))
                }
                Capsule()
                    .strokeBorder(Theme.tomato.opacity(0.44), style: StrokeStyle(lineWidth: 2, dash: [4, 5]))
                    .frame(width: 44, height: 5)
                    .opacity(min(1, max(0, time - 130) / 160))
                Image(systemName: "checkmark.icloud.fill")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundStyle(Theme.tomatoDeep)
                    .opacity(min(1, max(0, time - 285) / 275))
            }
            .padding(Theme.Spacing.xl)
            .frame(maxWidth: .infinity)
            .background(Theme.tomatoSoft, in: RoundedRectangle(cornerRadius: Theme.Radius.card))
            .accessibilityHidden(true)
        }
        .onAppear { appeared = true }
    }
}

#Preview { SaveAccountStep {}.previewEnvironment().creamBackground() }
