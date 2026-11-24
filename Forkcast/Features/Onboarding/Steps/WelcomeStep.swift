import SwiftUI
import StoreKit

struct WelcomeStep: View {
    let onStart: () -> Void

    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 44
    @State private var showsRedemption = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: Theme.Spacing.xl) {
                    IngredientHero(height: 236)
                    VStack(spacing: Theme.Spacing.s) {
                        Text("Forkcast")
                            .font(.system(size: titleSize, weight: .heavy, design: .rounded))
                            .foregroundStyle(Theme.aubergine)
                            .accessibilityAddTraits(.isHeader)
                        Text("Dinners for the week, planned around your shop and your budget.")
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
                    MascotView(size: min(height * 0.65, side * 0.55), mood: .idle)
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
