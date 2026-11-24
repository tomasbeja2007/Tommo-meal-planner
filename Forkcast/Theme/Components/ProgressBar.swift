import SwiftUI

/// Rounded progress bar: tinted fill on a `creamDeep` track.
/// Draws on once when it appears (ease-out, like a chart), then follows value changes.
struct ProgressBar: View {
    /// 0...1 (values above 1 are clamped visually).
    let value: Double
    var tint: Color = Theme.tomato
    var height: CGFloat = 8
    /// Stagger for bars that appear together (40–80 ms apart).
    var drawOnDelay: Double = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @State private var isDrawn: Bool = false

    private var shown: Double { isDrawn ? min(max(value, 0), 1) : 0 }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.creamDeep)
                Capsule()
                    .fill(tint)
                    .frame(width: max(height, proxy.size.width * CGFloat(shown)))
                    .opacity(shown <= 0 ? 0 : 1)
            }
        }
        .frame(height: height)
        .animation(Theme.motion(reduceMotion), value: value)
        .onAppear {
            // One-shot draw-on with ease-out (charts draw on, then rest); instant with Reduce Motion.
            guard !isDrawn else { return }
            if reduceMotion {
                isDrawn = true
            } else {
                withAnimation(Animation.open(0.6).delay(drawOnDelay)) { isDrawn = true }
            }
        }
        .accessibilityElement()
        .accessibilityValue(Text("\(Int((min(max(value, 0), 1) * 100).rounded())) percent"))
    }
}

/// Circular progress ring with a centred label, e.g. "12 / 31".
struct ProgressRing: View {
    let value: Double
    var lineWidth: CGFloat = 6
    var tint: Color = Theme.tomato
    var label: String? = nil

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @State private var isDrawn: Bool = false

    var body: some View {
        ZStack {
            Circle().stroke(Theme.creamDeep, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: isDrawn ? CGFloat(min(max(value, 0), 1)) : 0)
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            if let label {
                Text(label)
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergine)
                    .minimumScaleFactor(0.6)
                    .padding(lineWidth)
            }
        }
        .animation(Theme.motion(reduceMotion), value: value)
        .onAppear {
            // One-shot draw-on with ease-out (charts draw on, then rest); instant with Reduce Motion.
            guard !isDrawn else { return }
            if reduceMotion {
                isDrawn = true
            } else {
                withAnimation(Animation.open(0.6).delay(0)) { isDrawn = true }
            }
        }
    }
}

#Preview("Progress") {
    VStack(spacing: 24) {
        ProgressBar(value: 0.4)
        ProgressBar(value: 0.95, tint: Theme.saffron)
        ProgressRing(value: 12.0 / 31.0, label: "12 / 31").frame(width: 64, height: 64)
    }
    .padding()
    .creamBackground()
}
