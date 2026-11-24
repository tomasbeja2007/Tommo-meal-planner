import SwiftUI

/// A selectable answer tile used throughout onboarding and preferences.
/// Unselected: white with a 1 pt `line` border. Selected: tomato border,
/// `tomatoSoft` fill and a small tomato check badge.
struct OptionTile: View {
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    var emoji: String? = nil
    var iconTint: Color = Theme.tomato
    let isSelected: Bool
    var layout: Layout = .row
    let action: () -> Void

    enum Layout {
        case row
        case grid
    }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    var body: some View {
        Button(action: action) {
            content
                .padding(Theme.Spacing.l)
                .frame(maxWidth: .infinity, minHeight: 56, alignment: layout == .row ? .leading : .center)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                        .fill(isSelected ? Theme.tomatoSoft : Theme.card)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous)
                        .stroke(isSelected ? Theme.tomato : Theme.line, lineWidth: isSelected ? 2 : 1)
                )
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        CheckBadge()
                            .offset(x: 6, y: -6)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(Theme.motion(reduceMotion), value: isSelected)
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }

    @ViewBuilder
    private var content: some View {
        switch layout {
        case .row:
            HStack(spacing: Theme.Spacing.m) {
                icon
                VStack(alignment: .leading, spacing: 2) {
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

    @ViewBuilder
    private var icon: some View {
        if let emoji {
            Text(emoji).font(.system(size: layout == .grid ? 34 : 26))
        } else if let systemImage {
            Image(systemName: systemImage)
                .font(.system(size: layout == .grid ? 28 : 20, weight: .semibold))
                .foregroundStyle(iconTint)
                .frame(width: layout == .grid ? 44 : 28)
        }
    }
}

/// The small round tomato checkmark shown on selected tiles.
struct CheckBadge: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 11, weight: .heavy))
            .foregroundStyle(Color.white)
            .frame(width: 22, height: 22)
            .background(Circle().fill(Theme.tomato))
            .accessibilityHidden(true)
    }
}

#Preview("Option tiles") {
    VStack(spacing: 12) {
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
