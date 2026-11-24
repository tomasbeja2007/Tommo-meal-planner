import SwiftUI

struct NameStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void
    @FocusState private var focused: Bool

    private var isValid: Bool {
        !state.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what should we call you?"),
            subtitle: String(localized: "so your week feels like yours"),
            isButtonEnabled: isValid,
            onContinue: onContinue
        ) {
            TextField(String(localized: "Your first name"), text: $state.name)
                .font(.system(.title2, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .submitLabel(.continue)
                .focused($focused)
                .padding(.horizontal, Theme.Spacing.l)
                .frame(minHeight: 60)
                .background(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).fill(Theme.card))
                .overlay(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).stroke(focused ? Theme.tomato : Theme.line, lineWidth: focused ? 2 : 1))
                .onSubmit { if isValid { onContinue() } }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { focused = true }
        }
    }
}

#Preview { NameStep(state: OnboardingState()) {}.creamBackground() }
