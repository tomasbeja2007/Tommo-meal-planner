import SwiftUI

/// The ONLY place the mascot artwork is referenced. Every screen goes through
/// `MascotView`, so the character can be swapped later in one place.
struct MascotView: View {
    enum Mood {
        /// Gentle breathing scale.
        case idle
        /// Small bounce plus a saffron sparkle burst.
        case cheer
        /// Slow wobble.
        case thinking
    }

    var size: CGFloat = 160
    var mood: Mood = .idle

    /// Asset catalog name of the current mascot artwork.
    static let assetName: String = "Mascot"

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @State private var animating: Bool = false

    var body: some View {
        ZStack {
            if mood == .cheer {
                SparkleBurst(size: size, active: animating && !reduceMotion)
            }
            Image(MascotView.assetName)
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .offset(y: offsetY)
        }
        .frame(width: size, height: size)
        .accessibilityElement()
        .accessibilityLabel(Text("Chef Tomato, the Forkcast mascot"))
        .accessibilityAddTraits(.isImage)
        .onAppear { start() }
        .onChange(of: mood) { _, _ in
            animating = false
            start()
        }
    }

    private var scale: CGFloat {
        guard !reduceMotion else { return 1 }
        switch mood {
        case .idle: return animating ? 1.035 : 1.0
        case .cheer: return animating ? 1.06 : 0.96
        case .thinking: return 1.0
        }
    }

    private var rotation: Double {
        guard !reduceMotion, mood == .thinking else { return 0 }
        return animating ? 4 : -4
    }

    private var offsetY: CGFloat {
        guard !reduceMotion, mood == .cheer else { return 0 }
        return animating ? -size * 0.04 : 0
    }

    private func start() {
        guard !reduceMotion else { return }
        let animation: Animation
        switch mood {
        case .idle:
            animation = .easeInOut(duration: 1.8).repeatForever(autoreverses: true)
        case .cheer:
            animation = .spring(response: 0.4, dampingFraction: 0.45).repeatCount(3, autoreverses: true)
        case .thinking:
            animation = .easeInOut(duration: 1.2).repeatForever(autoreverses: true)
        }
        withAnimation(animation) {
            animating = true
        }
    }
}

/// A ring of saffron SF Symbol sparkles that pop outwards.
struct SparkleBurst: View {
    let size: CGFloat
    let active: Bool

    private let angles: [Double] = [-80, -35, 10, 55, 125, 170, 215]

    var body: some View {
        ZStack {
            ForEach(Array(angles.enumerated()), id: \.offset) { index, angle in
                Image(systemName: index % 2 == 0 ? "sparkle" : "star.fill")
                    .font(.system(size: size * (index % 2 == 0 ? 0.14 : 0.08), weight: .bold))
                    .foregroundStyle(Theme.saffron)
                    .offset(x: cos(angle * .pi / 180) * radius, y: sin(angle * .pi / 180) * radius)
                    .scaleEffect(active ? 1 : 0.2)
                    .opacity(active ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.55).delay(Double(index) * 0.04), value: active)
            }
        }
        .accessibilityHidden(true)
    }

    private var radius: CGFloat { active ? size * 0.62 : size * 0.3 }
}

#Preview("Mascot moods") {
    HStack(spacing: 24) {
        MascotView(size: 90, mood: .idle)
        MascotView(size: 90, mood: .cheer)
        MascotView(size: 90, mood: .thinking)
    }
    .padding(40)
    .creamBackground()
}
