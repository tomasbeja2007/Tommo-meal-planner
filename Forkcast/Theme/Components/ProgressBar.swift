import SwiftUI

/// Rounded progress bar: tinted fill on a `creamDeep` track.
struct ProgressBar: View {
    /// 0...1 (values above 1 are clamped visually).
    let value: Double
    var tint: Color = Theme.tomato
    var height: CGFloat = 8

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.creamDeep)
                Capsule()
                    .fill(tint)
                    .frame(width: max(height, proxy.size.width * CGFloat(min(max(value, 0), 1))))
                    .opacity(value <= 0 ? 0 : 1)
            }
        }
        .frame(height: height)
        .animation(Theme.motion(reduceMotion), value: value)
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

    var body: some View {
        ZStack {
            Circle().stroke(Theme.creamDeep, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(min(max(value, 0), 1)))
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
