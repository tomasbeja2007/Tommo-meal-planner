import SwiftUI
import ForkcastCore

struct DietPicker: View {
    @Binding var selection: Diet
    var onPick: (() -> Void)? = nil
    /// `.grid`: 2-column tiles with the diet illustrations (onboarding). `.row`: the preferences list.
    var layout: OptionTile.Layout = .row

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.m), count: layout == .grid ? 2 : 1)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
            ForEach(Diet.allCases, id: \.self) { diet in
                OptionTile(
                    title: diet.displayName,
                    subtitle: subtitle(for: diet),
                    emoji: emoji(for: diet),
                    illustration: "diet-\(diet.rawValue)",
                    isSelected: selection == diet,
                    layout: layout,
                    minHeight: layout == .grid ? 132 : 64
                ) {
                    selection = diet
                    onPick?()
                }
            }
        }
    }

    private func subtitle(for diet: Diet) -> String {
        switch diet {
        case .none: return String(localized: "a bit of everything")
        case .vegetarian: return String(localized: "no meat or fish")
        case .vegan: return String(localized: "nothing from animals")
        case .pescatarian: return String(localized: "fish, but no meat")
        }
    }

    private func emoji(for diet: Diet) -> String {
        switch diet {
        case .none: return "🍽️"
        case .vegetarian: return "🥕"
        case .vegan: return "🌱"
        case .pescatarian: return "🐟"
        }
    }
}

#Preview {
    DietPicker(selection: .constant(.vegetarian)).padding().creamBackground()
}
