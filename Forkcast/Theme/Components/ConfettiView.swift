import SwiftUI

/// A one-off confetti burst in the Forkcast palette, drawn in ONE Canvas from ONE clock.
/// Pieces have seeded launch angles, speeds, sizes and spins (variety without per-frame randomness),
/// rise with ease-out, fall with gravity, sway, and fade out at the end. Nothing starts at scale 0.
/// With Reduce Motion the clock jumps to its last frame, which is empty: no confetti.
struct ConfettiView: View {
    /// Plays once when this turns true.
    let play: Bool
    var count: Int = 70

    var body: some View {
        OneShotClock(duration: ConfettiMotion.durationMs, play: play) { t in
            Canvas { context, size in
                guard t > 0, t < ConfettiMotion.durationMs else { return }
                let fade: Double = 1 - seg(t, ConfettiMotion.durationMs - 500, ConfettiMotion.durationMs)
                for i in 0..<count {
                    draw(piece: i, t: t, fade: fade, in: &context, size: size)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func draw(piece i: Int, t: Double, fade: Double, in context: inout GraphicsContext, size: CGSize) {
        let delay: Double = seeded(i, salt: 1) * 160
        let local: Double = max(0, t - delay) / 1000
        guard local > 0 else { return }
        // Launch from the upper middle, fanning out.
        let angle: Double = (-90 + (seeded(i, salt: 2) - 0.5) * 150) * .pi / 180
        let speed: Double = Double(size.height) * (0.55 + 0.5 * seeded(i, salt: 3))
        let x0: Double = Double(size.width) * (0.5 + (seeded(i, salt: 4) - 0.5) * 0.3)
        let y0: Double = Double(size.height) * 0.38
        let gravity: Double = Double(size.height) * 1.6
        let sway: Double = 10 * wave(t, period: 700 + 500 * seeded(i, salt: 5), phase: seeded(i, salt: 6))
        let x: Double = x0 + cos(angle) * speed * local * 0.6 + sway
        let y: Double = y0 + sin(angle) * speed * local + 0.5 * gravity * local * local
        let spin: Double = (seeded(i, salt: 7) - 0.5) * 900 * local
        let w: Double = 6 + 5 * seeded(i, salt: 8)
        let h: Double = w * (0.45 + 0.5 * seeded(i, salt: 9))
        let color: Color = ConfettiMotion.colors[i % ConfettiMotion.colors.count]

        var piece = context
        piece.opacity = fade
        piece.translateBy(x: x, y: y)
        piece.rotate(by: .degrees(spin))
        let rect = CGRect(x: -w / 2, y: -h / 2, width: w, height: h)
        piece.fill(Path(roundedRect: rect, cornerRadius: 1.5), with: .color(color))
    }
}

enum ConfettiMotion {
    static let durationMs: Double = 2_200
    /// Palette colours only; herb stays out (it's for ticks and success, never dominant).
    static let colors: [Color] = [Theme.tomato, Theme.saffron, Theme.aubergine, Theme.tomatoSoft, Theme.saffronSoft, Theme.tomatoDeep]
}

#Preview {
    ConfettiView(play: true).creamBackground()
}
