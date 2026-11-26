import SwiftUI

/// The first screen. On a cold start it continues straight out of the launch screen:
/// Chef Tommo glides from the launch spot (screen centre, 200 pt) into the hero, the ingredients
/// open out from behind it, then the words and the buttons rise in. One scene, nothing teleports.
/// Numbers live in `WelcomeIntro`.
struct WelcomeStep: View {
    let onStart: () -> Void

    private static var hasPlayedIntro = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var playsIntro = !WelcomeStep.hasPlayedIntro
    @State private var landed = false

    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 44

    private var intro: Bool { playsIntro && !reduceMotion }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    IngredientHero(height: min(320, max(180, geometry.size.height * 0.54)), showsPlanPreview: true, playsIntro: intro)
                    VStack(spacing: Theme.Spacing.s) {
                        Text("Dinner, sorted.\nBudget, kept.")
                            .font(.system(size: titleSize, weight: .heavy, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Theme.aubergine)
                            .accessibilityAddTraits(.isHeader)
                            .rise(intro, delay: WelcomeIntro.titleAt)
                        Text("Your week of meals, planned around your money, kitchen and taste.")
                            .font(.title3)
                            .foregroundStyle(Theme.aubergineMuted)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .rise(intro, delay: WelcomeIntro.subtitleAt)
                    }
                }
                .padding(Theme.Spacing.gutter)
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(String(localized: "Get started"), action: onStart)
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.vertical, Theme.Spacing.s)
            .background(Theme.cream)
            .rise(intro, delay: WelcomeIntro.buttonsAt)
        }
        .sensoryFeedback(.impact(weight: .light), trigger: landed)
        .onAppear { WelcomeStep.hasPlayedIntro = true }
        .task {
            guard intro else { return }
            try? await Task.sleep(for: .milliseconds(Int(WelcomeIntro.landMs)))
            landed = true
        }
    }
}

/// Every number for the welcome intro (ms, fractions of the hero height).
enum WelcomeIntro {
    static let duration: Double = 1_500
    /// The launch mascot rests a beat before it moves, so the hand-off from the launch screen is invisible.
    static let holdMs: Double = 160
    static let landMs: Double = 820
    /// Launch screen mascot size (`LaunchMascot`, 200 pt at screen centre).
    static let launchSize: CGFloat = 200
    static let propsAt: Double = 520
    static let propStagger: Double = 70
    static let propOpenMs: Double = 560
    static let titleAt: Double = 0.62
    static let subtitleAt: Double = 0.72
    static let buttonsAt: Double = 0.86
}

private extension View {
    /// When `animated`, rises 14 pt and fades in once after `delay` seconds (ease-out); otherwise shows at rest.
    func rise(_ animated: Bool, delay: Double) -> some View {
        modifier(RiseIn(animated: animated, delay: delay))
    }
}

private struct RiseIn: ViewModifier {
    let animated: Bool
    let delay: Double
    @State private var on = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        let visible = on || reduceMotion || !animated
        content
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 14)
            .onAppear {
                guard animated, !on else { return }
                withAnimation(Animation.open(0.5).delay(delay)) { on = true }
            }
    }
}

/// A single clock drives the ingredient layers. Text and controls sit outside the scene.
struct IngredientHero: View {
    let height: CGFloat
    var showsPlanPreview = false
    /// Plays the launch-screen hand-off once (mascot glides in, ingredients open out).
    var playsIntro = false

    @State private var isVisible = false

    /// Eight ingredients on the rim of the disc round Chef Tommo, evenly spaced, one size: a deliberate
    /// shape, not a scatter.
    private static let ring = ["avocado", "cherry-tomatoes", "lemon", "broccoli", "bell-pepper", "garlic", "basil", "eggplant"]
    /// One turn every 30 s (divides the 60 s ambient loop, so the seam never jumps).
    private static let orbitPeriod: Double = 30_000

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, height * 1.48)
            let mascotSize = min(height * 0.52, side * 0.46)
            let global = proxy.frame(in: .global)
            // How far the launch mascot sits from the hero's centre (window coordinates).
            let fromLaunch: CGSize = playsIntro
                ? Self.windowCenter.map { CGSize(width: $0.x - global.midX, height: $0.y - (global.minY + height / 2)) } ?? .zero
                : .zero
            OneShotClock(duration: WelcomeIntro.duration, play: isVisible && playsIntro) { e in
                LoopClock(period: Theme.Motion.ambientDuration, paused: !isVisible) { time in
                    let i = playsIntro ? e : WelcomeIntro.duration
                    ZStack {
                        backdrop(width: side, at: time, intro: i)
                        if showsPlanPreview && AssetImage.exists("WelcomePlanScreenshot") {
                            phonePreview
                        } else {
                            mascot(size: mascotSize, intro: i, from: fromLaunch)
                        }
                        orbit(width: side, at: time, intro: i)
                    }
                    .frame(width: side, height: height)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: height)
        .onAppear { isVisible = true }
        .onDisappear { isVisible = false }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    @MainActor private static var windowCenter: CGPoint? {
        let scene = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        guard let bounds = scene?.windows.first?.bounds ?? scene?.screen.bounds else { return nil }
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    /// Drawn at the launch size and scaled down (crisp), travelling on the ease-in-out curve,
    /// with a small volume-keeping settle when it lands.
    private func mascot(size: CGFloat, intro i: Double, from: CGSize) -> some View {
        let move = seg(i, WelcomeIntro.holdMs, WelcomeIntro.landMs, easeOut: false)
        let endScale = Double(size / WelcomeIntro.launchSize)
        let startScale = from == .zero ? endScale : 1
        let scale = startScale + (endScale - startScale) * move
        let land = WelcomeIntro.landMs
        let settle = from == .zero ? 1 : flow(i, [(0, 1), (land - 40, 1), (land + 90, 0.96), (land + 260, 1.01), (land + 420, 1), (WelcomeIntro.duration, 1)])
        // Optical centring: the art's box includes the tall hat and the spoon on the right, so its middle
        // isn't where the eye lands. Nudging him right and up puts his face, not his box, in the centre of
        // the circle. Applied as he travels, so the hand-off from the launch screen stays exact.
        let optical = CGSize(width: size * 0.05, height: -size * 0.08)
        return MascotView(size: WelcomeIntro.launchSize, mood: .idle)
            .scaleEffect(x: 1 / pow(settle, 0.6), y: settle, anchor: .bottom)
            .scaleEffect(scale)
            .frame(width: size, height: size)
            .offset(x: from.width * (1 - move) + optical.width * move,
                    y: from.height * (1 - move) + optical.height * move)
    }

    private var phonePreview: some View {
        let screenHeight = height * 0.82
        let corners = RoundedRectangle(cornerRadius: height * 0.06, style: .continuous)
        return Image("WelcomePlanScreenshot")
            .resizable()
            .scaledToFill()
            .frame(width: screenHeight * 0.48, height: screenHeight)
            .clipShape(corners)
            .padding(Theme.Spacing.xs)
            .background(Theme.Illustration.deviceBezel, in: corners)
            .rotation3DEffect(.degrees(-9), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
            .rotationEffect(.degrees(-10))
            .shadow(color: Theme.aubergine.opacity(0.24), radius: 12, x: 3, y: 8)
    }

    /// One shape for the whole scene: a circle centred on Chef Tommo. The soft tomato disc fills it,
    /// a dotted rim marks its edge, and the ingredients ride exactly on that rim.
    private var ringRadius: CGFloat { height * 0.40 }

    /// The tomato disc behind Chef Tommo and its dotted rim. The disc grows in from 90% as he lands and
    /// glows 1.5% over 6 s; the rim draws on round the circle with the ingredients.
    private func backdrop(width: CGFloat, at time: Double, intro i: Double) -> some View {
        let open = seg(i, WelcomeIntro.landMs - 200, WelcomeIntro.landMs + 300)
        let draw = seg(i, WelcomeIntro.propsAt - 100, WelcomeIntro.propsAt + 600)
        let glow = 1 + 0.015 * wave(time, period: 6_000)
        let diameter = ringRadius * 2
        return ZStack {
            Circle()
                .fill(RadialGradient(colors: [Theme.tomatoSoft, Theme.tomatoSoft.opacity(0.45)],
                                     center: .center, startRadius: 0, endRadius: ringRadius))
                .frame(width: diameter, height: diameter)
                .scaleEffect((0.9 + 0.1 * open) * glow)
                .opacity(open)
            Circle()
                .trim(from: 0, to: draw)
                .stroke(Theme.tomato.opacity(0.28), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [2, 7]))
                .rotationEffect(.degrees(-90))
                .frame(width: diameter, height: diameter)
        }
        .frame(width: width, height: height)
    }

    /// Eight ingredients, one size, evenly spaced on the rim, turning slowly (one turn every 30 s, linear)
    /// and each rocking ±5° on its own seeded period. They sit on the rim, never behind Chef Tommo.
    /// On the intro they open out from 35% of the radius, staggered, from 80% scale (never 0).
    private func orbit(width: CGFloat, at time: Double, intro i: Double) -> some View {
        let pieces = Self.ring
        let centre = CGPoint(x: width / 2, y: height / 2)
        let side = height * 0.15
        return ZStack {
            ForEach(Array(pieces.enumerated()), id: \.offset) { index, id in
                let angle = 2 * Double.pi * (Double(index) / Double(pieces.count) + loop(time, period: Self.orbitPeriod)) - .pi / 2
                let start = WelcomeIntro.propsAt + Double(index) * WelcomeIntro.propStagger
                let open = seg(i, start, start + WelcomeIntro.propOpenMs)
                let reach = ringRadius * CGFloat(0.35 + 0.65 * open)
                let rock = 5 * wave(time, period: [4_000, 5_000, 6_000, 10_000][index % 4], phase: seeded(index))
                Image("ingredient-\(id)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: side, height: side)
                    .rotationEffect(.degrees(rock))
                    .elevation(Theme.Elevation.subtle)
                    .scaleEffect(0.8 + 0.2 * open)
                    .opacity(open)
                    .position(x: centre.x + CGFloat(cos(angle)) * reach, y: centre.y + CGFloat(sin(angle)) * reach)
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview { WelcomeStep {}.previewEnvironment().creamBackground() }
