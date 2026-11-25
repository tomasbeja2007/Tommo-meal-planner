import SwiftUI
import StoreKit

struct WelcomeStep: View {
    let onStart: () -> Void

    private static var hasPlayedSplash = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showingWelcome = WelcomeStep.hasPlayedSplash

    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 44
    @State private var showsRedemption = false

    var body: some View {
        Group {
            if showingWelcome || reduceMotion {
                welcomeContent
            } else {
                Button(action: showWelcome) {
                    MascotRing(size: 200, burst: true, popped: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Skip intro"))
                .transition(.opacity)
                .task {
                    try? await Task.sleep(for: .milliseconds(760))
                    guard !Task.isCancelled else { return }
                    showWelcome()
                }
            }
        }
    }

    private func showWelcome() {
        Self.hasPlayedSplash = true
        withAnimation(Theme.motion(reduceMotion)) { showingWelcome = true }
    }

    private var welcomeContent: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    IngredientHero(height: min(320, max(180, geometry.size.height * 0.54)), showsPlanPreview: true)
                    VStack(spacing: Theme.Spacing.s) {
                        Text("Dinner, sorted.\nBudget, kept.")
                            .font(.system(size: titleSize, weight: .heavy, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Theme.aubergine)
                            .accessibilityAddTraits(.isHeader)
                        Text("Your week of meals, planned around your money, kitchen and taste.")
                            .font(.title3)
                            .foregroundStyle(Theme.aubergineMuted)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(Theme.Spacing.gutter)
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: Theme.Spacing.xs) {
                PrimaryButton(String(localized: "Get started"), action: onStart)
                Button(String(localized: "I have a code")) { showsRedemption = true }
                    .buttonStyle(QuietButtonStyle())
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.vertical, Theme.Spacing.s)
            .background(Theme.cream)
        }
        .offerCodeRedemption(isPresented: $showsRedemption) { _ in
            Task { await subscriptions.refreshEntitlements() }
        }
    }
}

/// A single clock drives the ingredient layers. Text and controls sit outside the scene.
struct IngredientHero: View {
    let height: CGFloat
    var showsPlanPreview = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false
    @State private var hasAppeared = false

    private struct Prop: Identifiable {
        let id: String
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let tilt: Double
        let period: Double
    }

    private static let back: [Prop] = [
        Prop(id: "broccoli", x: 0.25, y: 0.25, size: 0.28, tilt: -17, period: 6_000),
        Prop(id: "cherry-tomatoes", x: 0.77, y: 0.24, size: 0.27, tilt: 12, period: 7_500),
        Prop(id: "basil", x: 0.86, y: 0.53, size: 0.23, tilt: 19, period: 5_000)
    ]
    private static let front: [Prop] = [
        Prop(id: "avocado", x: 0.20, y: 0.75, size: 0.34, tilt: -14, period: 7_500),
        Prop(id: "lemon", x: 0.78, y: 0.77, size: 0.32, tilt: 12, period: 6_000),
        Prop(id: "garlic", x: 0.35, y: 0.91, size: 0.19, tilt: 8, period: 5_000)
    ]

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, height * 1.48)
            LoopClock(period: Theme.Motion.ambientDuration, paused: !isVisible) { time in
                ZStack {
                    props(Self.back, width: side, at: time)
                    if showsPlanPreview && AssetImage.exists("WelcomePlanScreenshot") {
                        phonePreview
                    } else {
                        MascotView(size: min(height * 0.65, side * 0.55), mood: .idle)
                    }
                    props(Self.front, width: side, at: time)
                }
                .frame(width: side, height: height)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: height)
        .opacity(hasAppeared || reduceMotion ? 1 : 0)
        .onAppear {
            isVisible = true
            withAnimation(reduceMotion ? nil : Theme.Motion.reveal) { hasAppeared = true }
        }
        .onDisappear { isVisible = false }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    private var phonePreview: some View {
        let screenHeight = height * 0.82
        let corners = RoundedRectangle(cornerRadius: height * 0.06, style: .continuous)
        return Image("WelcomePlanScreenshot")
            .resizable()
            .scaledToFill()
            .frame(width: screenHeight * 0.48, height: screenHeight)
            .clipShape(corners)
            .padding(5)
            .background(Color(white: 0.14), in: corners)
            .rotation3DEffect(.degrees(-9), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
            .rotationEffect(.degrees(-10))
            .shadow(color: Theme.aubergine.opacity(0.24), radius: 12, x: 3, y: 8)
    }

    private func props(_ props: [Prop], width: CGFloat, at time: Double) -> some View {
        ZStack {
            ForEach(props) { prop in
                let phase = Double(prop.x)
                let drift = reduceMotion ? 0 : wave(time, period: prop.period, phase: phase)
                Image("ingredient-\(prop.id)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: height * prop.size, height: height * prop.size)
                    .shadow(color: Theme.aubergine.opacity(0.12), radius: 5, x: 0, y: 4)
                    .rotationEffect(.degrees(prop.tilt + 3 * drift))
                    .position(x: width * prop.x, y: height * prop.y + CGFloat(drift) * height * 0.025)
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview { WelcomeStep {}.previewEnvironment().creamBackground() }

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
