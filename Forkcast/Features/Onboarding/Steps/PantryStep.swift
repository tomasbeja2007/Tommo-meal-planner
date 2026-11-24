import SwiftUI
import ForkcastCore

/// 11. What do you already have? (optional). Ticked items are left off this week's
/// shopping list and total. Tiles use the ingredient emoji until photos exist.
struct PantryStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    @State private var tab: PantryTab = .all

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.s), count: 3)

    private var items: [Ingredient] { PantryTab.items(for: tab) }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what do you already have?"),
            subtitle: String(localized: "we'll leave these off this week's list"),
            buttonTitle: state.pantry.isEmpty ? String(localized: "Skip") : continueTitle(selected: state.pantry.count),
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.s) {
                        ForEach(PantryTab.allCases) { option in
                            Chip(title: option.title, isSelected: tab == option) { tab = option }
                        }
                    }
                }
                LazyVGrid(columns: columns, spacing: Theme.Spacing.s) {
                    ForEach(items) { ingredient in
                        PantryTile(
                            ingredient: ingredient,
                            unitSystem: state.country(in: FoodCatalog.bundled).unitSystem,
                            isSelected: state.pantry.contains(ingredient.id)
                        ) {
                            if state.pantry.contains(ingredient.id) {
                                state.pantry.remove(ingredient.id)
                            } else {
                                state.pantry.insert(ingredient.id)
                            }
                        }
                    }
                }
                .animation(Theme.spring, value: tab)
            }
        }
    }
}

private struct PantryTile: View {
    let ingredient: Ingredient
    let unitSystem: UnitSystem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(ingredient.emoji).font(.system(size: 34))
                Text(ingredient.displayName(for: unitSystem, plural: ingredient.baseUnit == .piece).capitalizedFirst)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .padding(Theme.Spacing.s)
            .frame(maxWidth: .infinity, minHeight: 96)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(isSelected ? Theme.tomatoSoft : Theme.creamDeep))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).stroke(isSelected ? Theme.tomato : Color.clear, lineWidth: 2))
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    CheckBadge().padding(6).transition(.scale(scale: 0.6).combined(with: .opacity))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(Theme.spring, value: isSelected)
        .sensoryFeedback(.impact(weight: .light), trigger: isSelected)
        .accessibilityLabel(Text(ingredient.displayName(for: unitSystem).capitalizedFirst))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}

/// All / Fresh / Fridge / Pantry, from the ingredient aisles.
enum PantryTab: String, CaseIterable, Identifiable {
    case all
    case fresh
    case fridge
    case pantry

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return String(localized: "All")
        case .fresh: return String(localized: "Fresh")
        case .fridge: return String(localized: "Fridge")
        case .pantry: return String(localized: "Pantry")
        }
    }

    func contains(_ aisle: Aisle) -> Bool {
        switch self {
        case .all: return true
        case .fresh: return aisle == .produce || aisle == .bakery
        case .fridge: return aisle == .dairyEggs || aisle == .meatFish || aisle == .frozen
        case .pantry: return ![Aisle.produce, .bakery, .dairyEggs, .meatFish, .frozen].contains(aisle)
        }
    }

    /// Ingredients the bundled recipes use most (pantry staples are left out: they cost
    /// pennies and are already on the "check you have" list).
    private static let ranked: [Ingredient] = {
        let catalog: FoodCatalog = .bundled
        var uses: [String: Int] = [:]
        for recipe in catalog.recipes {
            for item in recipe.ingredients {
                if let id = item.ingredientId { uses[id, default: 0] += 1 }
            }
        }
        return catalog.ingredients
            .filter { !$0.isPantryStaple && (uses[$0.id] ?? 0) > 0 }
            .sorted { (uses[$0.id] ?? 0, $1.name) > (uses[$1.id] ?? 0, $0.name) }
    }()

    static func items(for tab: PantryTab) -> [Ingredient] {
        Array(ranked.filter { tab.contains($0.aisle) }.prefix(tab == .all ? 36 : 24))
    }
}

#Preview {
    PantryStep(state: OnboardingState()) {}.creamBackground()
}
