import SwiftUI

struct WelcomeStep: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer(minLength: Theme.Spacing.xl)
            MascotView(size: 220, mood: .idle)
            VStack(spacing: Theme.Spacing.s) {
                Text("Forkcast")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                    .accessibilityAddTraits(.isHeader)
                Text("dinners for the week, planned around your shop and your budget")
                    .font(.title3)
                    .foregroundStyle(Theme.aubergineMuted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Theme.Spacing.xl)
            Spacer()
            VStack(spacing: Theme.Spacing.xs) {
                PrimaryButton(String(localized: "Get started"), action: onStart)
                Button(String(localized: "I have a code")) {
                    // TODO: offer / referral code entry.
                }
                .buttonStyle(QuietButtonStyle())
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.bottom, Theme.Spacing.m)
        }
    }
}

#Preview { WelcomeStep {}.creamBackground() }
