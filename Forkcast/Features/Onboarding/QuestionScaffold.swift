import SwiftUI

/// Standard quiz screen: big left-aligned question, optional "why we ask"
/// subtitle, scrolling options and a pinned primary button.
struct QuestionScaffold<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var buttonTitle: String = String(localized: "Continue")
    var isButtonEnabled: Bool = true
    var showsButton: Bool = true
    var secondaryTitle: String? = nil
    var secondaryAction: (() -> Void)? = nil
    let onContinue: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                QuestionHeader(title: title, subtitle: subtitle)
                content()
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.top, Theme.Spacing.m)
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            if showsButton {
                VStack(spacing: Theme.Spacing.xs) {
                    PrimaryButton(buttonTitle, action: onContinue)
                        .disabled(!isButtonEnabled)
                    if let secondaryTitle, let secondaryAction {
                        Button(secondaryTitle, action: secondaryAction)
                            .buttonStyle(QuietButtonStyle())
                    }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.s)
                .padding(.bottom, Theme.Spacing.s)
                .background(Theme.cream.opacity(0.97).ignoresSafeArea())
            }
        }
    }
}

struct QuestionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text(title)
                .font(Theme.questionFont)
                .foregroundStyle(Theme.aubergine)
                .lineSpacing(-2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            if let subtitle {
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Back chevron + progress bar shown above every question.
struct OnboardingHeader: View {
    let progress: Double
    let canGoBack: Bool
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Theme.aubergine)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Theme.card))
                    .overlay(Circle().stroke(Theme.line, lineWidth: 1))
            }
            .opacity(canGoBack ? 1 : 0)
            .disabled(!canGoBack)
            .accessibilityLabel(Text("Back"))
            ProgressBar(value: progress, tint: Theme.tomato, height: 8)
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.vertical, Theme.Spacing.s)
    }
}

#Preview("Question scaffold") {
    VStack(spacing: 0) {
        OnboardingHeader(progress: 0.3, canGoBack: true) {}
        QuestionScaffold(title: "what should we call you?", subtitle: "so your plan feels like yours", onContinue: {}) {
            Text("Options go here")
        }
    }
    .creamBackground()
}
