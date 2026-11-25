import SwiftUI
import ForkcastCore

/// Pick up to 3 vibes.
struct VibePicker: View {
    @Binding var selection: Set<Vibe>
    var maxSelection: Int = 3
    @State private var nudge: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    @Environment(\.dynamicTypeSize) private var typeSize

    private var options: [Vibe] {
        let featured: [Vibe] = [.quickEasy, .onePan, .batchFriendly, .family, .comfort, .healthyish, .fiberForward, .fakeaway]
        return featured + [.highProtein, .lowCalorie].filter { selection.contains($0) }
    }

    private func details(for vibe: Vibe) -> (String, String, String) {
        switch vibe {
        case .quickEasy: return (String(localized: "Quick & Easy"), String(localized: "Ready in about 20 minutes"), "bolt")
        case .onePan: return (String(localized: "One Pan"), String(localized: "Minimal cleanup"), "frying.pan")
        case .batchFriendly: return (String(localized: "Batch Cook"), String(localized: "Cook once, eat twice"), "square.stack")
        case .family: return (String(localized: "Family Favorites"), String(localized: "Meals for the whole table"), "person.2")
        case .comfort: return (String(localized: "Comfort Classics"), String(localized: "Hearty favorites"), "flame")
        case .healthyish: return (String(localized: "Fresh & Light"), String(localized: "Lighter, veg-forward meals"), "leaf")
        case .fiberForward: return (String(localized: "Fiber-Forward"), String(localized: "Beans, grains and greens"), "leaf.circle")
        case .fakeaway: return (String(localized: "Takeout at Home"), String(localized: "Takeout favorites for less"), "takeoutbag.and.cup.and.straw")
        default: return (vibe.displayName, "", vibe.systemImage)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            // A 4th tap gently shakes the whole grid (and the counter turns tomato).
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.m), count: typeSize.isAccessibilitySize ? 1 : 2), spacing: Theme.Spacing.m) {
                ForEach(options, id: \.self) { vibe in
                    let (title, subtitle, icon) = details(for: vibe)
                    OptionTile(
                        title: title,
                        subtitle: subtitle.isEmpty ? nil : subtitle,
                        systemImage: icon,
                        illustration: "vibe-\(vibe.rawValue)",
                        iconTint: Color(hexString: vibe.tintHex),
                        isSelected: selection.contains(vibe),
                        layout: .grid,
                        minHeight: 128
                    ) {
                        toggle(vibe)
                    }
                }
            }
            .modifier(ShakeEffect(animatableData: CGFloat(nudge)))
            Text("\(selection.count) of \(maxSelection) picked")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(selection.count == maxSelection ? Theme.tomatoDeep : Theme.aubergineMuted)
                .frame(maxWidth: .infinity)
        }
        .sensoryFeedback(.warning, trigger: nudge)
    }

    private func toggle(_ vibe: Vibe) {
        if selection.contains(vibe) {
            selection.remove(vibe)
        } else if selection.count < maxSelection {
            selection.insert(vibe)
        } else {
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.4)) { nudge += 1 }
        }
    }
}

/// Small horizontal shake.
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 6 * sin(animatableData * .pi * 4), y: 0))
    }
}

#Preview {
    VibePicker(selection: .constant([.quickEasy, .comfort])).padding().creamBackground()
}
