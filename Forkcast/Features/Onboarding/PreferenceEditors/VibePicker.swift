import SwiftUI
import ForkcastCore

/// Pick up to 3 vibes.
struct VibePicker: View {
    @Binding var selection: Set<Vibe>
    var maxSelection: Int = 3
    @State private var nudge: Int = 0

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: Theme.Spacing.m),
        GridItem(.flexible(), spacing: Theme.Spacing.m),
        GridItem(.flexible(), spacing: Theme.Spacing.m)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
                ForEach(Vibe.allCases, id: \.self) { vibe in
                    OptionTile(
                        title: vibe.displayName,
                        systemImage: vibe.systemImage,
                        illustration: "vibe-\(vibe.rawValue)",
                        iconTint: Color(hexString: vibe.tintHex),
                        isSelected: selection.contains(vibe),
                        layout: .grid
                    ) {
                        toggle(vibe)
                    }
                }
            }
            Text("\(selection.count) of \(maxSelection) picked")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(selection.count == maxSelection ? Theme.tomatoDeep : Theme.aubergineMuted)
                .frame(maxWidth: .infinity)
                .modifier(ShakeEffect(animatableData: CGFloat(nudge)))
        }
        .sensoryFeedback(.warning, trigger: nudge)
    }

    private func toggle(_ vibe: Vibe) {
        if selection.contains(vibe) {
            selection.remove(vibe)
        } else if selection.count < maxSelection {
            selection.insert(vibe)
        } else {
            withAnimation(.default) { nudge += 1 }
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
