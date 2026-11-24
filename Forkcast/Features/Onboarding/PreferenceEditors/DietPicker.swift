import SwiftUI
import ForkcastCore

struct DietPicker: View {
    @Binding var selection: Diet
    var onPick: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            ForEach(Diet.allCases, id: \.self) { diet in
                OptionTile(
                    title: diet.displayName,
                    subtitle: subtitle(for: diet),
                    emoji: emoji(for: diet),
                    isSelected: selection == diet
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
