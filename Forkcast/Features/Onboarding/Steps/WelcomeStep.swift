import SwiftUI

/// Splash (≤ 1.2 s) handing off to the Welcome screen.
///
/// The launch screen shows a still Chef Tomato, centred, on cream (`LaunchMascot`). This view
/// starts from the same spot: the mascot pops (0.85 → 1, a little overshoot, light haptic),
/// ingredient pieces burst out from behind with a 40 ms stagger and settle into a loose ring,
/// then mascot and ring move up and shrink into place while the copy fades up (80 ms stagger).
/// Tap anywhere to skip. With Reduce Motion it cross-fades straight to Welcome.
/// Motion: one clock per scene (see Theme/Motion/MOTION.md); the pop is the only spring with
/// overshoot, as the onboarding brief asks.
struct WelcomeStep: View {
    let onStart: () -> Void

    /// The splash plays once per app launch.
    private static var hasPlayedSplash: Bool = false

    private enum Phase { case splash, welcome }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @State private var phase: Phase = WelcomeStep.hasPlayedSplash ? .welcome : .splash
    @State private var popped: Bool = WelcomeStep.hasPlayedSplash
    @State private var burst: Bool = WelcomeStep.hasPlayedSplash
    @State private var textShown: Bool = WelcomeStep.hasPlayedSplash

    /// Same size as the launch image, so the hand-off from the launch screen is seamless.
    private let mascotSize: CGFloat = 200

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                MascotRing(size: mascotSize, burst: burst, popped: popped)
                    .scaleEffect(phase == .splash ? 1 : 0.8)
                    .position(x: proxy.size.width / 2, y: phase == .splash ? proxy.size.height / 2 : proxy.size.height * 0.32)
            }
            .ignoresSafeArea()

            VStack(spacing: Theme.Spacing.xl) {
                Spacer()
                VStack(spacing: Theme.Spacing.s) {
                    Text("Dinner, sorted.\nBudget, kept.")
                        .font(.system(size: 38, weight: .heavy, design: .rounded))
                        .foregroundStyle(Theme.aubergine)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                        .fadeUp(textShown, index: 0, reduceMotion: reduceMotion)
                    Text("Your week of meals, planned around your money, kitchen and taste.")
                        .font(.body)
                        .foregroundStyle(Theme.aubergineMuted)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .fadeUp(textShown, index: 1, reduceMotion: reduceMotion)
                }
                .padding(.horizontal, Theme.Spacing.xl)
                PrimaryButton(String(localized: "Get started"), action: onStart)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .fadeUp(textShown, index: 2, reduceMotion: reduceMotion)
                    .allowsHitTesting(textShown)
            }
            .padding(.bottom, Theme.Spacing.l)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if phase == .splash { handOff() }
        }
        .task { await runSplash() }
    }

    private func runSplash() async {
        guard phase == .splash else { return }
        if reduceMotion {
            WelcomeStep.hasPlayedSplash = true
            withAnimation(.easeInOut(duration: 0.3)) {
                popped = true
                burst = true
                phase = .welcome
                textShown = true
            }
            return
        }
        popped = true
        burst = true
        try? await Task.sleep(nanoseconds: 760_000_000)
        handOff()
    }

    private func handOff() {
        guard phase == .splash else { return }
        WelcomeStep.hasPlayedSplash = true
        popped = true
        burst = true
        withAnimation(reduceMotion ? .easeInOut(duration: 0.3) : Theme.spring) { phase = .welcome }
        textShown = true
    }
}

private extension View {
    /// Fades up from 12 pt below, staggered 80 ms per index, after the mascot starts moving.
    func fadeUp(_ shown: Bool, index: Int, reduceMotion: Bool) -> some View {
        self
            .opacity(shown ? 1 : 0)
            .offset(y: shown || reduceMotion ? 0 : 12)
            .animation(reduceMotion ? .easeInOut(duration: 0.3) : Animation.open(0.3).delay(0.12 + 0.08 * Double(index)), value: shown)
    }
}

/// Chef Tomato in a loose ring of ingredient pieces that drift very slowly.
/// Pieces come from optional assets (`splash-*`, see Design/IMAGE_REQUESTS.md); missing ones are skipped.
struct MascotRing: View {
    var size: CGFloat = 200
    /// Plays the burst once when it turns true.
    let burst: Bool
    /// Pops the mascot from 0.85 to 1 when it turns true.
    let popped: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    static let pieceNames: [String] = ["splash-tomato", "splash-basil", "splash-garlic", "splash-chilli", "splash-lemon", "splash-pepper"]

    private var pieces: [String] { MascotRing.pieceNames.filter { AssetImage.exists($0) } }

    var body: some View {
        ZStack {
            if !pieces.isEmpty {
                // One idle clock for the ring; the burst is a one-shot on top of it.
                LoopClock(period: RingMotion.loopMs) { t in
                    OneShotClock(duration: RingMotion.burstMs, play: burst) { b in
                        ZStack {
                            ForEach(Array(pieces.enumerated()), id: \.offset) { index, name in
                                RingPiece(name: name, index: index, count: pieces.count, t: t, b: b, size: size)
                            }
                        }
                    }
                }
            }
            MascotView(size: size, mood: .idle)
                .scaleEffect(popped || reduceMotion ? 1 : 0.85)
                .animation(reduceMotion ? nil : .spring(response: 0.32, dampingFraction: 0.55), value: popped)
        }
        .frame(width: size * 2, height: size * 1.8)
        .sensoryFeedback(.impact(weight: .light), trigger: popped)
    }
}

/// Every number for the ring, in one place (ms and fractions of the mascot size).
enum RingMotion {
    static let loopMs: Double = 36_000
    static let burstMs: Double = 700
    static let stagger: Double = 40
    static let travelMs: Double = 460
    static let radius: Double = 0.68
    static let pieceSize: Double = 0.3
    /// Idle drift: a few points of bob and a few degrees of rock, on periods that divide the loop.
    static let bob: Double = 0.02
    static let rock: Double = 5
    static let periods: [Double] = [6_000, 9_000, 12_000]
}

private struct RingPiece: View {
    let name: String
    let index: Int
    let count: Int
    /// Idle clock (ms).
    let t: Double
    /// Burst clock (ms).
    let b: Double
    let size: CGFloat

    var body: some View {
        let start: Double = Double(index) * RingMotion.stagger
        let p: Double = seg(b, start, start + RingMotion.travelMs)
        let angle: Double = (Double(index) / Double(max(1, count)) + 0.08 * seeded(index, salt: 1)) * .pi * 2 - .pi / 2
        let radius: Double = Double(size) * RingMotion.radius * (0.9 + 0.2 * seeded(index, salt: 2)) * p
        let period: Double = RingMotion.periods[index % RingMotion.periods.count]
        let bob: Double = Double(size) * RingMotion.bob * wave(t, period: period, phase: seeded(index, salt: 3))
        let rock: Double = RingMotion.rock * wave(t, period: period, phase: seeded(index, salt: 4) + 0.25)
        let pieceSide: CGFloat = size * CGFloat(RingMotion.pieceSize * (0.8 + 0.4 * seeded(index, salt: 5)))
        Image(name)
            .resizable()
            .interpolation(.high)
            .scaledToFit()
            .frame(width: pieceSide, height: pieceSide)
            .rotationEffect(.degrees(rock + 20 * (seeded(index, salt: 6) - 0.5)))
            .scaleEffect(0.6 + 0.4 * p)
            .opacity(p)
            .offset(x: CGFloat(cos(angle) * radius), y: CGFloat(sin(angle) * radius + bob))
            .accessibilityHidden(true)
    }
}

#Preview { WelcomeStep {}.creamBackground() }
