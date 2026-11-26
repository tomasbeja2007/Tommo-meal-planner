import SwiftUI
import ForkcastCore

/// 11. What do you already have? (optional). Ticked items are left off this week's
/// shopping list and total. Tiles show a real photo (`ingredient-<id>`) when it exists, else the emoji.
struct PantryStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "What do you already have?"),
            subtitle: String(localized: "We'll leave these off this week's list."),
            buttonTitle: state.pantry.isEmpty ? String(localized: "Skip for now") : continueTitle(selected: state.pantry.count),
            onContinue: onContinue
        ) {
            PantryPicker(selection: $state.pantry, unitSystem: state.units(in: .bundled))
        }
    }
}

struct PantryPicker: View {
    @Binding var selection: Set<String>
    let unitSystem: UnitSystem

    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var tab: PantryTab = .all
    @State private var query = ""

    private var items: [Ingredient] {
        let search = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return PantryTab.ranked.filter { item in
            tab.contains(item.aisle) && (search.isEmpty || item.displayName(for: unitSystem).localizedStandardContains(search)
                || item.name.localizedStandardContains(search))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            HStack(spacing: Theme.Spacing.s) {
                Image(systemName: "magnifyingglass").accessibilityHidden(true)
                TextField("Search foods", text: $query)
                    .autocorrectionDisabled()
                if !query.isEmpty {
                    Button { query = "" } label: { Image(systemName: "xmark.circle.fill") }
                        .buttonStyle(.plain)
                        .accessibilityLabel(Text("Clear search"))
                }
            }
            .foregroundStyle(Theme.aubergine)
            .padding(Theme.Spacing.m)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.Radius.button))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.s) {
                    ForEach(PantryTab.allCases) { option in
                        Chip(title: option.title, isSelected: tab == option) { tab = option }
                    }
                }
            }
            if items.isEmpty {
                Text("No foods found").foregroundStyle(Theme.aubergineMuted)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: typeSize.isAccessibilitySize ? 136 : 74), spacing: Theme.Spacing.s)], spacing: Theme.Spacing.s) {
                ForEach(items) { ingredient in
                    PantryTile(ingredient: ingredient, unitSystem: unitSystem, isSelected: selection.contains(ingredient.id)) {
                        if selection.contains(ingredient.id) { selection.remove(ingredient.id) }
                        else { selection.insert(ingredient.id) }
                    }
                }
            }
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: tab)
        }
    }
}

private struct PantryTile: View {
    let ingredient: Ingredient
    let unitSystem: UnitSystem
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.inline) {
                IngredientPhoto(ingredient: ingredient, side: 48)
                Text(ingredient.displayName(for: unitSystem, plural: ingredient.baseUnit == .piece).capitalizedFirst)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Theme.Spacing.s)
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(isSelected ? Theme.tomatoSoft : Theme.creamDeep))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).stroke(isSelected ? Theme.tomato : Color.clear, lineWidth: 2))
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    CheckBadge().padding(Theme.Spacing.inline).transition(reduceMotion ? .opacity : .scale(scale: 0.6).combined(with: .opacity))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(Theme.motion(reduceMotion), value: isSelected)
        .sensoryFeedback(.impact(weight: .light), trigger: isSelected)
        .accessibilityLabel(Text(ingredient.displayName(for: unitSystem).capitalizedFirst))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}

/// A real photo of the ingredient (asset `ingredient-<id>`, see Design/IMAGE_REQUESTS.md section 6),
/// falling back to its emoji until the photo is added.
struct IngredientPhoto: View {
    let ingredient: Ingredient
    var side: CGFloat = 60

    private var assetName: String { "ingredient-" + ingredient.id }

    var body: some View {
        if AssetImage.exists(assetName) {
            Image(assetName)
                .resizable()
                .interpolation(.high)
                .scaledToFill()
                .frame(width: side, height: side)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous))
                .accessibilityHidden(true)
        } else {
            Text(ingredient.emoji)
                .font(.system(size: side * 0.56))
                .frame(width: side, height: side)
                .accessibilityHidden(true)
        }
    }
}

/// All / Fresh / Fridge / Pantry, from the ingredient aisles.
enum PantryTab: String, CaseIterable, Identifiable {
    case all
    case fresh
    case meat
    case fridge
    case pantry

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return String(localized: "All")
        case .fresh: return String(localized: "Fresh")
        case .meat: return String(localized: "Meat")
        case .fridge: return String(localized: "Fridge")
        case .pantry: return String(localized: "Pantry")
        }
    }

    func contains(_ aisle: Aisle) -> Bool {
        switch self {
        case .all: return true
        case .fresh: return aisle == .produce || aisle == .bakery
        case .meat: return aisle == .meatFish
        case .fridge: return aisle == .dairyEggs || aisle == .frozen
        case .pantry: return ![Aisle.produce, .bakery, .dairyEggs, .meatFish, .frozen].contains(aisle)
        }
    }

    /// Common ingredients first, with the full catalog available through search.
    static let ranked: [Ingredient] = {
        let catalog: FoodCatalog = .bundled
        var uses: [String: Int] = [:]
        for recipe in catalog.recipes {
            for item in recipe.ingredients {
                if let id = item.ingredientId { uses[id, default: 0] += 1 }
            }
        }
        return catalog.ingredients.sorted { first, second in
            let left = uses[first.id, default: 0]
            let right = uses[second.id, default: 0]
            return left == right ? first.name < second.name : left > right
        }
    }()

}

#Preview {
    PantryStep(state: OnboardingState()) {}.creamBackground()
}
