import SwiftUI
import UIKit

// MascotView: the ONLY place the mascot artwork is referenced. Every screen goes through it,
// so the character can be swapped later in one place.
//
// Motion follows rossark-motion-skill (see Forkcast/Theme/Motion/MOTION.md):
// - one LoopClock per mascot; every channel is a function of its time `t` (ms);
// - pivot at the feet: breathing and tilts scale/rotate around the bottom centre;
// - volume is kept (width = 1 / height^0.6), so squashes don't read as stretching;
// - idle life never stops (breath, sway, weight drift on periods that divide the loop);
// - cheer = ONE main action per loop (crouch, stretch, gravity fall, squash, settle) plus sparkles
//   that only fade in and out with `bell`; the floor shadow shrinks with the height;
// - Reduce Motion freezes on frame 0, which is the neutral standing pose.
//
// Rig limits: the art is one flat image (eyes baked in, no head layer), so there are no blinks
// or gaze. Mood-specific art (MascotIdle / MascotCheer / MascotThinking) is used when present.

struct MascotView: View {
    enum Mood: Equatable {
        /// Breathing, a slow sway and a little weight drift.
        case idle
        /// A hop with squash-and-stretch and a saffron sparkle burst, once per loop.
        case cheer
        /// A slow, held head tilt to one side and then the other.
        case thinking
        /// Holding the reminder bell (`MascotBell` art); moves like idle.
        case bell
    }

    var size: CGFloat = 160
    var mood: Mood = .idle

    /// Asset catalog name of the base mascot artwork.
    static let assetName: String = "Mascot"

    /// Optional per-mood artwork. If an asset with this name exists it is used,
    /// otherwise the base "Mascot" image is animated. See Design/IMAGE_REQUESTS.md.
    static func assetName(for mood: Mood) -> String {
        let specific: String
        switch mood {
        case .idle: specific = "MascotIdle"
        case .cheer: specific = "MascotCheer"
        case .thinking: specific = "MascotThinking"
        case .bell: specific = "MascotBell"
        }
        return AssetImage.exists(specific) ? specific : assetName
    }

    /// Clocks pause while the mascot is off screen (rule: nothing runs unseen).
    @State private var isVisible: Bool = false

    var body: some View {
        LoopClock(period: MascotMotion.loopMs, paused: !isVisible) { t in
            MascotFrame(t: t, mood: mood, size: size, imageName: MascotView.assetName(for: mood))
        }
        .frame(width: size, height: size)
        .onAppear { isVisible = true }
        .onDisappear { isVisible = false }
        .accessibilityElement()
        .accessibilityLabel(Text("Chef Tomato, the Forkcast mascot"))
        .accessibilityAddTraits(.isImage)
    }
}

/// Every tunable number, in one place. Lengths are fractions of the mascot's size; times in ms.
/// All idle periods divide `loopMs`, so the loop closes without a jump.
enum MascotMotion {
    static let loopMs: Double = 12_000

    // Idle life
    static let breathAmount: Double = 0.012      // ±1.2% height
    static let breathPeriod: Double = 3_000
    static let swayDegrees: Double = 1.5
    static let swayPeriod: Double = 4_000
    static let driftAmount: Double = 0.006       // sideways weight drift
    static let driftPeriod: Double = 6_000

    // Cheer: the hop (one main action at the start of each loop)
    static let crouchEnd: Double = 180
    static let apexAt: Double = 520
    static let landAt: Double = 820
    static let hopHeight: Double = 0.12
    /// Height scale through the hop: crouch, stretch on the way up, stretch falling, squash, settle.
    static let hopSquash: FlowKeys = [
        (0, 1), (180, 0.93), (320, 1.07), (560, 1.02), (790, 1.06),
        (850, 0.85), (980, 1.03), (1_120, 0.99), (1_260, 1), (12_000, 1)
    ]
    /// Tilt through the hop (asymmetric so it doesn't read as a mannequin).
    static let cheerTilt: FlowKeys = [(0, 0), (300, -3), (700, 4), (1_100, 0), (12_000, 0)]

    // Cheer: sparkles
    static let sparkleCount: Int = 7
    static let sparkleStart: Double = 420
    static let sparkleLife: Double = 1_000

    // Thinking: hold a tilt one way, then the other (held values are repeated keys; idle keeps moving)
    static let thinkTilt: FlowKeys = [
        (0, 0), (1_200, -4), (3_600, -4), (4_800, 3), (7_200, 3), (8_400, 0), (12_000, 0)
    ]
    static let thinkBob: Double = 0.01
}

/// One frame of the mascot at time `t`.
private struct MascotPose {
    var scaleX: Double = 1
    var scaleY: Double = 1
    var tilt: Double = 0
    var shiftX: Double = 0
    /// Negative is up (fraction of size).
    var lift: Double = 0

    static func at(_ t: Double, mood: MascotView.Mood) -> MascotPose {
        var pose = MascotPose()
        var height: Double = 1 + MascotMotion.breathAmount * wave(t, period: MascotMotion.breathPeriod)
        var tilt: Double = MascotMotion.swayDegrees * wave(t, period: MascotMotion.swayPeriod)
        let drift: Double = MascotMotion.driftAmount * wave(t, period: MascotMotion.driftPeriod)

        switch mood {
        case .idle, .bell:
            break
        case .thinking:
            tilt = flow(t, MascotMotion.thinkTilt) + 0.8 * wave(t, period: MascotMotion.swayPeriod)
            pose.lift = -MascotMotion.thinkBob * (wave(t, period: MascotMotion.breathPeriod, phase: 0.75) + 1) / 2
        case .cheer:
            height *= flow(t, MascotMotion.hopSquash)
            tilt += flow(t, MascotMotion.cheerTilt)
            pose.lift = hopLift(t)
        }

        pose.scaleY = height
        pose.scaleX = 1 / pow(height, 0.6)   // keep the volume
        pose.tilt = tilt
        pose.shiftX = drift
        return pose
    }

    /// Rise with ease-out to the apex, then fall with gravity: lift = top × (1 − k²).
    private static func hopLift(_ t: Double) -> Double {
        let top: Double = MascotMotion.hopHeight
        if t <= MascotMotion.crouchEnd || t >= MascotMotion.landAt { return 0 }
        if t <= MascotMotion.apexAt {
            return -top * seg(t, MascotMotion.crouchEnd, MascotMotion.apexAt)
        }
        let k: Double = (t - MascotMotion.apexAt) / (MascotMotion.landAt - MascotMotion.apexAt)
        return -top * (1 - k * k)
    }
}

private struct MascotFrame: View {
    let t: Double
    let mood: MascotView.Mood
    let size: CGFloat
    let imageName: String

    var body: some View {
        let pose: MascotPose = MascotPose.at(t, mood: mood)
        // The shadow stays on the floor and shrinks as the body rises.
        let shadowScale: Double = max(0.55, 1 + pose.lift / 0.3)
        ZStack(alignment: .bottom) {
            Ellipse()
                .fill(Theme.aubergine.opacity(0.10))
                .frame(width: size * 0.46, height: size * 0.06)
                .scaleEffect(CGFloat(shadowScale))
                .offset(y: -size * 0.03)
            Image(imageName)
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(x: CGFloat(pose.scaleX), y: CGFloat(pose.scaleY), anchor: .bottom)
                .rotationEffect(.degrees(pose.tilt), anchor: .bottom)
                .offset(x: CGFloat(pose.shiftX) * size, y: CGFloat(pose.lift) * size)
        }
        .frame(width: size, height: size)
        .overlay {
            if mood == .cheer {
                SparkleField(t: t, size: size)
            }
        }
    }
}

/// Saffron sparkles drawn in ONE Canvas from the mascot's clock. Each has a seeded angle,
/// delay and size; they drift outwards with ease-out and only fade in and out (bell).
private struct SparkleField: View {
    let t: Double
    let size: CGFloat

    var body: some View {
        Canvas { context, canvasSize in
            let centre = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            let count: Int = MascotMotion.sparkleCount
            for i in 0..<count {
                let delay: Double = seeded(i, salt: 1) * 220
                let start: Double = MascotMotion.sparkleStart + delay
                let p: Double = (t - start) / MascotMotion.sparkleLife
                guard p > 0, p < 1 else { continue }
                // Spread around the upper half, never perfectly even.
                let angle: Double = (-160 + 140 * (Double(i) + seeded(i, salt: 2) * 0.6) / Double(count)) * .pi / 180
                let travel: Double = seg(t, start, start + MascotMotion.sparkleLife)
                let radius: Double = Double(size) * (0.42 + 0.22 * travel)
                let scale: Double = (0.55 + 0.45 * seeded(i, salt: 3)) * (0.7 + 0.3 * travel)
                let symbol: String = i % 2 == 0 ? "sparkle" : "star.fill"
                var image = context.resolve(Image(systemName: symbol))
                image.shading = .color(Theme.saffron)
                var layer = context
                layer.opacity = bell(p)
                layer.translateBy(x: centre.x + CGFloat(cos(angle) * radius), y: centre.y + CGFloat(sin(angle) * radius))
                layer.rotate(by: .degrees(20 * travel * (seeded(i, salt: 4) - 0.5)))
                let side: CGFloat = size * 0.13 * CGFloat(scale)
                layer.draw(image, in: CGRect(x: -side / 2, y: -side / 2, width: side, height: side))
            }
        }
        .frame(width: size * 1.6, height: size * 1.6)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// Checks whether an optional image exists in the asset catalog.
enum AssetImage {
    static func exists(_ name: String) -> Bool {
        UIImage(named: name) != nil
    }
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
