import SwiftUI

/// Capsule chip. At rest: `creamDeep`. Selected: `tomatoSoft` with tomatoDeep text.
struct Chip: View {
    let title: String
    var systemImage: String? = nil
    var isSelected: Bool = false
    var showsRemove: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        if let action {
            Button(action: action) { label }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: isSelected)
                .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        } else {
            label
        }
    }

    private var label: some View {
        HStack(spacing: Theme.Spacing.inline) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption.weight(.semibold))
            }
            Text(title)
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .lineLimit(1)
            if showsRemove {
                Image(systemName: "xmark")
                    .font(.caption2.weight(.bold))
                    .accessibilityLabel(Text("Remove"))
            }
        }
        .foregroundStyle(isSelected ? Theme.tomatoDeep : Theme.aubergine)
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .frame(minHeight: 36)
        .background(Capsule().fill(isSelected ? Theme.tomatoSoft : Theme.creamDeep))
        .overlay(Capsule().stroke(isSelected ? Theme.tomato : Color.clear, lineWidth: 1))
        .contentShape(Capsule())
    }
}

/// Small quiet tag used on cards ("Quick & easy").
struct TagLabel: View {
    let text: String
    var tint: Color = Theme.aubergineMuted
    var fill: Color = Theme.creamDeep

    var body: some View {
        Text(text)
            .font(.system(.caption, design: .rounded).weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(fill))
            .lineLimit(1)
    }
}

/// Simple wrapping layout for chips (iOS 16+ Layout protocol).
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth: CGFloat = proposal.width ?? .greatestFiniteMagnitude
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widest: CGFloat = 0
        for subview in subviews {
            let size: CGSize = subview.sizeThatFits(.unspecified)
            let itemWidth: CGFloat = min(size.width, maxWidth)
            if x > 0 && x + itemWidth > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += itemWidth + spacing
            rowHeight = max(rowHeight, size.height)
            widest = max(widest, x - spacing)
        }
        return CGSize(width: proposal.width ?? widest, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0
        for subview in subviews {
            let size: CGSize = subview.sizeThatFits(.unspecified)
            let itemWidth: CGFloat = min(size.width, bounds.width)
            if x > bounds.minX && x + itemWidth > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(width: itemWidth, height: size.height))
            x += itemWidth + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview("Chips") {
    FlowLayout(spacing: Theme.Spacing.s) {
        Chip(title: "Mushrooms", isSelected: true, showsRemove: true) {}
        Chip(title: "Olives") {}
        Chip(title: "Cilantro") {}
        TagLabel(text: "Quick & easy")
    }
    .padding()
    .creamBackground()
}
