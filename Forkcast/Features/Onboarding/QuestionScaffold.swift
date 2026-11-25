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
    /// Small Chef Tommo in the top-right corner, reacting to the answers.
    var reaction: MascotView.Mood? = nil
    let onContinue: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                HStack(alignment: .top, spacing: Theme.Spacing.m) {
                    QuestionHeader(title: title, subtitle: subtitle)
                    if let reaction {
                        MascotReaction(mood: reaction)
                    }
                }
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

/// Back chevron + spring progress bar + optional "Skip", above every question.
struct OnboardingTopBar: View {
    let progress: Double
    var stepDescription: String? = nil
    let canGoBack: Bool
    var onSkip: (() -> Void)? = nil
    let onBack: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

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
            ProgressBar(value: progress, tint: Theme.tomato, height: 6)
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.24), value: progress)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(stepDescription ?? String(localized: "Progress")))
            if let onSkip {
                Button(String(localized: "Skip"), action: onSkip)
                    .buttonStyle(QuietButtonStyle())
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.vertical, Theme.Spacing.s)
    }
}

/// 48 pt Chef Tommo in a screen corner. A new mood swaps in with a quick spring.
struct MascotReaction: View {
    let mood: MascotView.Mood
    var size: CGFloat = 48

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    var body: some View {
        ZStack {
            MascotView(size: size, mood: mood)
                .id(mood)
                .transition(reduceMotion ? .opacity : .scale(scale: 0.8).combined(with: .opacity))
        }
        .frame(width: size, height: size)
        .animation(Theme.motion(reduceMotion) ?? .easeInOut(duration: 0.2), value: mood)
        .accessibilityHidden(true)
    }
}

#Preview("Question scaffold") {
    VStack(spacing: 0) {
        OnboardingTopBar(progress: 0.3, canGoBack: true, onSkip: {}) {}
        QuestionScaffold(title: "who's eating?", subtitle: "so every recipe makes the right amount", reaction: .idle, onContinue: {}) {
            Text("Options go here")
        }
    }
    .creamBackground()
}
