import SwiftUI

/// Designed empty state: mascot (or icon), one line, one action.
struct EmptyState: View {
    let title: String
    var message: String? = nil
    var systemImage: String? = nil
    var showsMascot: Bool = true
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            if showsMascot {
                MascotView(size: 110, mood: .idle)
            } else if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(Theme.tomato)
                    .frame(width: 80, height: 80)
                    .background(Circle().fill(Theme.tomatoSoft))
                    .accessibilityHidden(true)
            }
            VStack(spacing: Theme.Spacing.inline) {
                Text(title)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                if let message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                        .multilineTextAlignment(.center)
                }
            }
            if let actionTitle, let action {
                PrimaryButton(actionTitle, action: action)
                    .frame(maxWidth: 280)
            }
        }
        .padding(Theme.Spacing.xl)
        .frame(maxWidth: .infinity)
    }
}

#Preview("Empty state") {
    EmptyState(title: "no saved recipes yet", message: "tap ♡ on any recipe to keep it here.", actionTitle: "Browse recipes") {}
        .creamBackground()
}
