import SwiftUI

/// Full-width 56 pt tomato button. Scales to 0.97 when pressed, with a light haptic.
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded).weight(.bold))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, Theme.Spacing.l)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                    .fill(configuration.isPressed ? Theme.tomatoDeep : Theme.tomato)
            )
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed) { _, newValue in
                newValue
            }
    }
}

/// Secondary button: tomato outline (or quiet cream fill).
struct SecondaryButtonStyle: ButtonStyle {
    var outlined: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded).weight(.semibold))
            .foregroundStyle(outlined ? Theme.tomato : Theme.aubergine)
            .frame(maxWidth: .infinity, minHeight: 50)
            .padding(.horizontal, Theme.Spacing.m)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                    .fill(outlined ? Theme.card : Theme.creamDeep)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                    .stroke(outlined ? Theme.tomato : Color.clear, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

/// Convenience wrapper: `PrimaryButton("Continue") { ... }`.
struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    init(_ title: String, systemImage: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.s) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

/// Small text-only button used for "Not now", "Skip", links.
struct QuietButtonStyle: ButtonStyle {
    var color: Color = Theme.aubergineMuted

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
            .foregroundStyle(color)
            .frame(minHeight: 44)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

#Preview("Buttons") {
    VStack(spacing: 16) {
        PrimaryButton("Build my week") {}
        PrimaryButton("Disabled") {}.disabled(true)
        Button("Edit week") {}.buttonStyle(SecondaryButtonStyle())
        Button("Not now") {}.buttonStyle(QuietButtonStyle())
    }
    .padding()
    .creamBackground()
}
