import SwiftUI
import ForkcastCore

/// 3. Chef Tomato echoes the goals and obstacles back, typed into a speech bubble.
/// No input; the button is never held back by the typing.
struct MirrorStep: View {
    let state: OnboardingState
    let onContinue: () -> Void

    /// Milliseconds per character while typing: quick, and the whole sentence never takes longer than 1.6 s.
    private var msPerCharacter: Double { min(14, 1_600 / Double(max(1, characterCount))) }
    /// How many characters the soft "ink" edge spans: each letter fades in over this many steps.
    private let fadeCharacters: Double = 6

    private var pieces: [MirrorPiece] { MirrorPiece.build(name: state.name, goals: state.goals, obstacles: state.obstacles) }
    private var characterCount: Int { pieces.reduce(0) { $0 + $1.text.count } }

    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            Spacer(minLength: Theme.Spacing.m)
            SpeechBubble {
                // Every letter is always laid out (unwritten ones are transparent), so a word never
                // starts on one line and jumps to the next: the writing flows line to line.
                OneShotClock(duration: (Double(characterCount) + fadeCharacters) * msPerCharacter, play: true) { t in
                    MirrorPiece.text(pieces, reveal: t / msPerCharacter, fade: fadeCharacters)
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
    static func build(name: String = "", goals: Set<String>, obstacles: Set<OnboardingObstacle>) -> [MirrorPiece] {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let goalPhrases: [String] = OnboardingGoal.allCases.filter { goals.contains($0.rawValue) }.prefix(2).map { $0.mirrorPhrase }
        let obstaclePhrases: [String] = OnboardingObstacle.allCases.filter { obstacles.contains($0) }.prefix(2).map { $0.mirrorPhrase }
        var pieces: [MirrorPiece] = []
        if goalPhrases.isEmpty {
            pieces.append(MirrorPiece(text: name.isEmpty ? String(localized: "So you want dinner sorted") : String(localized: "\(name), so you want dinner sorted"), isBold: false))
        } else {
            pieces.append(MirrorPiece(text: name.isEmpty ? String(localized: "So you want to ") : String(localized: "\(name), so you want to "), isBold: false))
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

    /// The whole sentence with letters up to `reveal` written in. Letters just behind the cursor fade
    /// in over `fade` characters (a soft ink edge instead of a hard tick). Runs that are fully shown or
    /// fully hidden stay as one `Text`, so only the few letters at the edge are split out.
    static func text(_ pieces: [MirrorPiece], reveal: Double, fade: Double) -> Text {
        var result = Text(verbatim: "")
        var index = 0
        for piece in pieces {
            let color: Color = piece.isBold ? Theme.tomatoDeep : Theme.aubergine
            var run = ""
            var runOpacity = -1.0
            func flush() {
                guard !run.isEmpty else { return }
                let t = Text(verbatim: run).foregroundStyle(color.opacity(runOpacity))
                result = result + (piece.isBold ? t.bold() : t)
                run = ""
            }
            for character in piece.text {
                let o = min(1, max(0, (reveal - Double(index)) / fade))
                let bucket = o >= 1 ? 1 : (o <= 0 ? 0 : (o * 8).rounded() / 8)
                if bucket != runOpacity { flush(); runOpacity = bucket }
                run.append(character)
                index += 1
            }
            flush()
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
