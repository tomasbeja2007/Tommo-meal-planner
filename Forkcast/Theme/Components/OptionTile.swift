import SwiftUI

/// A selectable answer tile used throughout onboarding and preferences.
/// 64 pt minimum height. Unselected: `creamDeep` fill. Selected: 2 pt tomato border,
/// `tomatoSoft` fill and a herb tick that pops in. The illustration gives a small bounce
/// when the tile is picked. Light haptic on every tap.
struct OptionTile: View {
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    var emoji: String? = nil
    /// Optional illustration from the asset catalog; used instead of the symbol/emoji when present.
    var illustration: String? = nil
    var iconTint: Color = Theme.tomato
    let isSelected: Bool
    var layout: Layout = .row
    var minHeight: CGFloat = 64
    let action: () -> Void

    enum Layout {
        case row
        case grid
    }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @State private var bounce: Int = 0

    var body: some View {
        Button(action: action) {
            content
                .padding(Theme.Spacing.l)
                .frame(maxWidth: .infinity, minHeight: minHeight, alignment: layout == .row ? .leading : .center)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                        .fill(isSelected ? Theme.tomatoSoft : Theme.creamDeep)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                        .stroke(isSelected ? Theme.tomato : Color.clear, lineWidth: 2)
                )
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        CheckBadge()
                            .offset(x: 6, y: -6)
                            .transition(.scale(scale: 0.6).combined(with: .opacity))
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(Theme.motion(reduceMotion), value: isSelected)
        .sensoryFeedback(.impact(weight: .light), trigger: isSelected)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }

    @ViewBuilder
    private var content: some View {
        switch layout {
        case .row:
            HStack(spacing: Theme.Spacing.m) {
                icon
                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text(title)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                        .multilineTextAlignment(.leading)
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(Theme.aubergineMuted)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer(minLength: 0)
            }
        case .grid:
            VStack(spacing: Theme.Spacing.s) {
                icon
                Text(title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Theme.aubergineMuted)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }

    /// The icon gives one small bounce when the tile is picked (none with Reduce Motion).
    private var icon: some View {
        iconContent
            .keyframeAnimator(initialValue: 1.0, trigger: bounce) { content, scale in
                content.scaleEffect(scale)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(1.14, duration: 0.14)
                    CubicKeyframe(0.96, duration: 0.12)
                    CubicKeyframe(1.0, duration: 0.16)
                }
            }
            .onChange(of: isSelected) { _, now in
                if now && !reduceMotion { bounce += 1 }
            }
    }

    @ViewBuilder
    private var iconContent: some View {
        if let illustration, AssetImage.exists(illustration) {
            Image(illustration)
                .resizable()
                .scaledToFit()
                .frame(width: layout == .grid ? 56 : 32, height: layout == .grid ? 56 : 32)
                .accessibilityHidden(true)
        } else if let emoji {
            Text(emoji).font(.system(size: layout == .grid ? 34 : 26))
        } else if let systemImage {
            Image(systemName: systemImage)
                .font(.system(size: layout == .grid ? 28 : 20, weight: .semibold))
                .foregroundStyle(iconTint)
                .frame(width: layout == .grid ? 44 : 28)
        }
    }
}

/// The small round herb tick shown on selected tiles (herb green is for ticks and success only).
struct CheckBadge: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 11, weight: .heavy))
            .foregroundStyle(Color.white)
            .frame(width: 22, height: 22)
            .background(Circle().fill(Theme.herb))
            .accessibilityHidden(true)
    }
}

#Preview("Option tiles") {
    VStack(spacing: Theme.Spacing.m) {
        OptionTile(title: "Spend less on food", systemImage: "banknote", isSelected: true) {}
        OptionTile(title: "Eat healthier", subtitle: "more veg, less fuss", systemImage: "leaf", isSelected: false) {}
        HStack {
            OptionTile(title: "Air fryer", systemImage: "fan", isSelected: true, layout: .grid) {}
            OptionTile(title: "Oven", systemImage: "oven", isSelected: false, layout: .grid) {}
        }
    }
    .padding()
    .creamBackground()
}
