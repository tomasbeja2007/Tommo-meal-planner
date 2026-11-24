import SwiftUI
import ForkcastCore

/// 2×3 grid of appliance tiles (at least one).
struct AppliancePicker: View {
    @Binding var selection: Set<Appliance>

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: Theme.Spacing.m),
        GridItem(.flexible(), spacing: Theme.Spacing.m)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
            ForEach(Appliance.allCases, id: \.self) { appliance in
                OptionTile(
                    title: appliance.displayName,
                    subtitle: subtitle(for: appliance),
                    systemImage: appliance.systemImage,
                    illustration: "appliance-\(appliance.rawValue)",
                    isSelected: selection.contains(appliance),
                    layout: .grid
                ) {
                    if selection.contains(appliance) {
                        if selection.count > 1 { selection.remove(appliance) }
                    } else {
                        selection.insert(appliance)
                    }
                }
            }
        }
    }

    private func subtitle(for appliance: Appliance) -> String {
        switch appliance {
        case .oven: return String(localized: "bakes & roasts")
        case .stovetop: return String(localized: "pans & pots")
        case .microwave: return String(localized: "zap it")
        case .airFryer: return String(localized: "crispy, fast")
        case .slowCooker: return String(localized: "set & forget")
        case .blender: return String(localized: "sauces & soups")
        }
    }
}

#Preview {
    AppliancePicker(selection: .constant([.oven, .stovetop])).padding().creamBackground()
}
