import SwiftUI
import ForkcastCore

/// Allergies: a hard filter. "None" clears the rest.
struct AllergyPicker: View {
    @Binding var selection: Set<Allergen>
    @Binding var noAllergies: Bool

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: Theme.Spacing.m),
        GridItem(.flexible(), spacing: Theme.Spacing.m)
    ]

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            OptionTile(title: String(localized: "None"), subtitle: String(localized: "no allergies here"), emoji: "👍", isSelected: noAllergies) {
                noAllergies = true
                selection.removeAll()
            }
            LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
                ForEach(Allergen.allCases, id: \.self) { allergen in
                    OptionTile(title: allergen.displayName, emoji: allergen.emoji, illustration: "allergen-\(allergen.rawValue)", isSelected: selection.contains(allergen)) {
                        noAllergies = false
                        if selection.contains(allergen) {
                            selection.remove(allergen)
                        } else {
                            selection.insert(allergen)
                        }
                    }
                }
            }
            Text("Always check ingredient labels and preparation for allergens and possible cross-contact.")
                .font(.footnote)
                .foregroundStyle(Theme.aubergineMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    AllergyPicker(selection: .constant([.peanut]), noAllergies: .constant(false)).padding().creamBackground()
}
