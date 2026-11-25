import SwiftUI
import StoreKit

/// The first screen. On a cold start it continues straight out of the launch screen:
/// Chef Tomato glides from the launch spot (screen centre, 200 pt) into the hero, the ingredients
/// open out from behind it, then the words and the buttons rise in. One scene, nothing teleports.
/// Numbers live in `WelcomeIntro`.
struct WelcomeStep: View {
    let onStart: () -> Void

    private static var hasPlayedIntro = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var playsIntro = !WelcomeStep.hasPlayedIntro
    @State private var landed = false

    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 44
    @State private var showsRedemption = false

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
            VStack(spacing: Theme.Spacing.xs) {
                PrimaryButton(String(localized: "Get started"), action: onStart)
                Button(String(localized: "I have a code")) { showsRedemption = true }
                    .buttonStyle(QuietButtonStyle())
            }
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
        .offerCodeRedemption(isPresented: $showsRedemption) { _ in
            Task { await subscriptions.refreshEntitlements() }
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
    /// Idle drift of the ingredients: barely there (front layer; the back layer moves 60% of this).
    static let bob: Double = 0.012
    static let rock: Double = 2
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

    private struct Prop: Identifiable {
        let id: String
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let tilt: Double
        let period: Double
        /// When it opens out during the intro (0 first).
        let order: Int
    }

    private static let back: [Prop] = [
        Prop(id: "broccoli", x: 0.25, y: 0.25, size: 0.28, tilt: -14, period: 12_000, order: 1),
        Prop(id: "cherry-tomatoes", x: 0.77, y: 0.24, size: 0.27, tilt: 10, period: 15_000, order: 3),
        Prop(id: "basil", x: 0.86, y: 0.53, size: 0.23, tilt: 14, period: 10_000, order: 5)
    ]
    private static let front: [Prop] = [
        Prop(id: "avocado", x: 0.20, y: 0.75, size: 0.34, tilt: -12, period: 15_000, order: 0),
        Prop(id: "lemon", x: 0.78, y: 0.77, size: 0.32, tilt: 10, period: 12_000, order: 2),
        Prop(id: "garlic", x: 0.35, y: 0.91, size: 0.19, tilt: 8, period: 10_000, order: 4)
    ]

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, height * 1.48)
            let mascotSize = min(height * 0.65, side * 0.55)
            let global = proxy.frame(in: .global)
            // How far the launch mascot sits from the hero's centre (window coordinates).
            let fromLaunch: CGSize = playsIntro
                ? Self.windowCenter.map { CGSize(width: $0.x - global.midX, height: $0.y - (global.minY + height / 2)) } ?? .zero
                : .zero
            OneShotClock(duration: WelcomeIntro.duration, play: isVisible && playsIntro) { e in
                LoopClock(period: Theme.Motion.ambientDuration, paused: !isVisible) { time in
                    let i = playsIntro ? e : WelcomeIntro.duration
                    ZStack {
                        props(Self.back, width: side, at: time, intro: i, depth: 0.6)
                        if showsPlanPreview && AssetImage.exists("WelcomePlanScreenshot") {
                            phonePreview
                        } else {
                            mascot(size: mascotSize, intro: i, from: fromLaunch)
                        }
                        props(Self.front, width: side, at: time, intro: i, depth: 1)
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
        return MascotView(size: WelcomeIntro.launchSize, mood: .idle)
            .scaleEffect(x: 1 / pow(settle, 0.6), y: settle, anchor: .bottom)
            .scaleEffect(scale)
            .frame(width: size, height: size)
            .offset(x: from.width * (1 - move), y: from.height * (1 - move))
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

    /// Ingredients open out from behind the mascot (from 35% of the way, never from scale 0),
    /// staggered, then drift very slowly; the back layer moves less than the front (depth).
    private func props(_ props: [Prop], width: CGFloat, at time: Double, intro i: Double, depth: Double) -> some View {
        ZStack {
            ForEach(props) { prop in
                let start = WelcomeIntro.propsAt + Double(prop.order) * WelcomeIntro.propStagger
                let open = seg(i, start, start + WelcomeIntro.propOpenMs)
                let reach = 0.35 + 0.65 * open
                let phase = Double(prop.x)
                let drift = wave(time, period: prop.period, phase: phase)
                let lag = wave(time, period: prop.period, phase: phase - 0.06)
                let x = 0.5 + (Double(prop.x) - 0.5) * reach
                let y = 0.5 + (Double(prop.y) - 0.5) * reach + drift * WelcomeIntro.bob * depth
                Image("ingredient-\(prop.id)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: height * prop.size, height: height * prop.size)
                    .shadow(color: Theme.aubergine.opacity(0.08 + 0.04 * open), radius: 6, x: 0, y: 5)
                    .rotationEffect(.degrees(prop.tilt * (0.6 + 0.4 * open) + WelcomeIntro.rock * depth * lag))
                    .scaleEffect(0.75 + 0.25 * open)
                    .opacity(open)
                    .position(x: width * x, y: height * y)
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview { WelcomeStep {}.previewEnvironment().creamBackground() }
