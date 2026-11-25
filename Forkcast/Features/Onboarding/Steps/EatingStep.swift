import SwiftUI
import ForkcastCore

/// 6. How do you eat? Diet tiles, a "More" chip row, then allergies, on one screen.
struct EatingStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "how do you eat?"),
            subtitle: String(localized: "we'll never include an allergen, and that includes hidden sources"),
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                DietPicker(selection: $state.diet, layout: .grid)
                VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                    Text("More")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Theme.aubergine)
                    FlowLayout(spacing: 8) {
                        ForEach(ExtraDiet.allCases) { extra in
                            Chip(title: extra.title, isSelected: state.extraDiets.contains(extra)) {
                                if state.extraDiets.contains(extra) {
                                    state.extraDiets.remove(extra)
                                } else {
                                    state.extraDiets.insert(extra)
                                }
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                    Text("Allergies")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Theme.aubergine)
                    AllergyChips(selection: $state.allergens, noAllergies: $state.noAllergies)
                }
            }
        }
    }
}

/// "No allergies" (preselected) plus one chip per allergen. Picking an allergen clears
/// "No allergies"; clearing the last allergen brings it back.
struct AllergyChips: View {
    @Binding var selection: Set<Allergen>
    @Binding var noAllergies: Bool

    var body: some View {
        FlowLayout(spacing: 8) {
            Chip(title: String(localized: "No allergies"), systemImage: "hand.thumbsup.fill", isSelected: noAllergies) {
                noAllergies = true
                selection.removeAll()
            }
            ForEach(Allergen.allCases, id: \.self) { allergen in
                Chip(title: "\(allergen.emoji) \(allergen.displayName)", isSelected: selection.contains(allergen)) {
                    if selection.contains(allergen) {
                        selection.remove(allergen)
                    } else {
                        selection.insert(allergen)
                    }
                    noAllergies = selection.isEmpty
                }
            }
        }
    }
}

#Preview {
    EatingStep(state: OnboardingState()) {}.creamBackground()
}
