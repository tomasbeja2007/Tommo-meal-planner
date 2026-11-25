import SwiftUI
import ForkcastCore

/// 3. Chef Tomato echoes the goals and obstacles back, typed into a speech bubble.
/// No input; the button is never held back by the typing.
struct MirrorStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    /// Milliseconds per character while typing: quick, and the whole sentence never takes longer than 1.6 s.
    private var msPerCharacter: Double { min(14, 1_600 / Double(max(1, characterCount))) }

    private var pieces: [MirrorPiece] { MirrorPiece.build(goals: state.goals, obstacles: state.obstacles) }
    private var characterCount: Int { pieces.reduce(0) { $0 + $1.text.count } }

    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            Spacer(minLength: Theme.Spacing.m)
            SpeechBubble {
                ZStack(alignment: .topLeading) {
                    // The full text, invisible, reserves the bubble's final size so nothing jumps.
                    MirrorPiece.text(pieces, upTo: characterCount).hidden()
                    OneShotClock(duration: Double(characterCount) * msPerCharacter, play: true) { t in
                        MirrorPiece.text(pieces, upTo: Int(t / msPerCharacter))
                    }
                }
                .font(.system(.title3, design: .rounded))
                .foregroundStyle(Theme.aubergine)
                .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement()
            .accessibilityLabel(Text(pieces.map { $0.text }.joined()))
            .padding(.horizontal, Theme.Spacing.gutter)
            MascotView(size: 170, mood: .idle)
            Spacer()
            PrimaryButton(String(localized: "Let's fix it"), action: onContinue)
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.bottom, Theme.Spacing.m)
        }
    }
}

/// One run of the mirror sentence, bold or regular.
struct MirrorPiece: Hashable {
    let text: String
    let isBold: Bool

    /// "So you want to **spend less** and **save time**, but **food goes off** and
    /// **planning takes forever**. That's exactly what I fix."
    static func build(goals: Set<String>, obstacles: Set<OnboardingObstacle>) -> [MirrorPiece] {
        let goalPhrases: [String] = OnboardingGoal.allCases.filter { goals.contains($0.rawValue) }.prefix(2).map { $0.mirrorPhrase }
        let obstaclePhrases: [String] = OnboardingObstacle.allCases.filter { obstacles.contains($0) }.prefix(2).map { $0.mirrorPhrase }
        var pieces: [MirrorPiece] = []
        if goalPhrases.isEmpty {
            pieces.append(MirrorPiece(text: String(localized: "So you want dinner sorted"), isBold: false))
        } else {
            pieces.append(MirrorPiece(text: String(localized: "So you want to "), isBold: false))
            pieces += joined(goalPhrases)
        }
        if !obstaclePhrases.isEmpty {
            pieces.append(MirrorPiece(text: String(localized: ", but "), isBold: false))
            pieces += joined(obstaclePhrases)
        }
        pieces.append(MirrorPiece(text: String(localized: ". That's exactly what I fix."), isBold: false))
        return pieces
    }

    private static func joined(_ phrases: [String]) -> [MirrorPiece] {
        var out: [MirrorPiece] = []
        for (index, phrase) in phrases.enumerated() {
            if index > 0 { out.append(MirrorPiece(text: String(localized: " and "), isBold: false)) }
            out.append(MirrorPiece(text: phrase, isBold: true))
        }
        return out
    }

    /// The first `count` characters of the sentence, keeping bold runs bold.
    static func text(_ pieces: [MirrorPiece], upTo count: Int) -> Text {
        var remaining: Int = max(0, count)
        var result: Text = Text(verbatim: "")
        for piece in pieces where remaining > 0 {
            let shown: String = String(piece.text.prefix(remaining))
            remaining -= shown.count
            let run: Text = Text(verbatim: shown)
            result = result + (piece.isBold ? run.bold().foregroundStyle(Theme.tomatoDeep) : run)
        }
        return result
    }
}

/// White card with a small tail pointing down at Chef Tomato.
struct SpeechBubble<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(Theme.Spacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                    .fill(Theme.card)
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            )
            .overlay(alignment: .bottom) {
                BubbleTail()
                    .fill(Theme.card)
                    .frame(width: 28, height: 14)
                    .offset(y: 13)
            }
    }
}

private struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.midX - 2, y: rect.minY + 4))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control: CGPoint(x: rect.midX + 2, y: rect.minY + 4))
        path.closeSubpath()
        return path
    }
}

#Preview {
    let state = OnboardingState()
    state.goals = ["spendLess", "saveTime"]
    state.obstacles = [.foodGoesOff, .planningTakesLong]
    return MirrorStep(state: state) {}.creamBackground()
}
