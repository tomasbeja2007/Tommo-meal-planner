import SwiftUI
import AuthenticationServices

/// 17. Save your plan: Sign in with Apple (the only account type until there's a backend),
/// behind a Terms checkbox. Your data syncs through your own iCloud either way, so
/// "Maybe later" is always available (no account wall).
struct SaveAccountStep: View {
    let onContinue: () -> Void

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppleSignInManager.self) private var appleSignIn: AppleSignInManager
    @State private var agreed: Bool = false

    private var isSignedIn: Bool { profileStore.profile?.appleUserId != nil }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "save your plan"),
            subtitle: String(localized: "keep your week, likes and lists safe, and on all your devices"),
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
                        SignInWithAppleButton(.continue) { request in
                            appleSignIn.configure(request)
                        } onCompletion: { result in
                            guard let signedIn = appleSignIn.handle(result), let profile = profileStore.profile else { return }
                            profile.appleUserId = signedIn.userId
                            if profile.name.isEmpty, let given = signedIn.givenName { profile.name = given }
                            profileStore.save()
                            onContinue()
                        }
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous))
                        .disabled(!agreed)
                        .opacity(agreed ? 1 : 0.4)
                        if let error = appleSignIn.lastError {
                            Text(error).font(.caption).foregroundStyle(Theme.tomatoDeep)
                        }
                        Button(String(localized: "Maybe later"), action: onContinue)
                            .buttonStyle(QuietButtonStyle())
                    }
                }
            }
        }
    }
}

private struct TermsCheckbox: View {
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
        let markdown: String = String(localized: "I agree to the [Terms](\(AppLinks.terms.absoluteString)) and [Privacy Policy](\(AppLinks.privacyPolicy.absoluteString)).")
        return (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
    }
}

/// `illustration-cloudSync` if it exists (see Design/IMAGE_REQUESTS.md), otherwise Chef Tomato.
private struct CloudSyncArt: View {
    var body: some View {
        if AssetImage.exists("illustration-cloudSync") {
            Image("illustration-cloudSync")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .accessibilityHidden(true)
        } else {
            MascotView(size: 140, mood: .idle)
        }
    }
}

#Preview { SaveAccountStep {}.previewEnvironment().creamBackground() }
