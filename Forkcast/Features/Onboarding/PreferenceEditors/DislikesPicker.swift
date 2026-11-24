import SwiftUI
import ForkcastCore

/// Search over ingredients plus "common picks". Selected dislikes show as removable chips.
struct DislikesPicker: View {
    @Binding var selection: Set<String>
    let unitSystem: UnitSystem
    @State private var query: String = ""

    private var catalog: FoodCatalog { FoodCatalog.bundled }

    private var results: [Ingredient] {
        let trimmed: String = query.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 2 else { return [] }
        let matches: [Ingredient] = catalog.ingredients.filter { ingredient in
            ingredient.name.localizedCaseInsensitiveContains(trimmed)
                || ingredient.pluralName.localizedCaseInsensitiveContains(trimmed)
                || (ingredient.ukName?.localizedCaseInsensitiveContains(trimmed) ?? false)
        }
        return Array(matches.prefix(8))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            SearchField(text: $query, prompt: String(localized: "Search ingredients"))
            if !results.isEmpty {
                VStack(spacing: 0) {
                    ForEach(results) { ingredient in
                        Button {
                            selection.insert(ingredient.id)
                            query = ""
                        } label: {
                            HStack {
                                Text(ingredient.emoji)
                                Text(ingredient.displayName(for: unitSystem).capitalizedFirst)
                                    .foregroundStyle(Theme.aubergine)
                                Spacer()
                                Image(systemName: selection.contains(ingredient.id) ? "checkmark" : "plus")
                                    .foregroundStyle(Theme.tomato)
                            }
                            .padding(.horizontal, Theme.Spacing.l)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        Divider().overlay(Theme.line)
                    }
                }
                .background(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).fill(Theme.card))
            }

            if !selection.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                    Text("Not for you").font(.subheadline.weight(.semibold)).foregroundStyle(Theme.aubergineMuted)
                    FlowLayout(spacing: 8) {
                        ForEach(selection.sorted(), id: \.self) { id in
                            Chip(title: DislikeCatalog.label(for: id, catalog: catalog, system: unitSystem), isSelected: true, showsRemove: true) {
                                selection.remove(id)
                            }
                            .accessibilityLabel(Text("Remove \(DislikeCatalog.label(for: id, catalog: catalog, system: unitSystem))"))
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                Text("Common picks").font(.subheadline.weight(.semibold)).foregroundStyle(Theme.aubergineMuted)
                FlowLayout(spacing: 8) {
                    ForEach(DislikeCatalog.commonPicks) { pick in
                        Chip(title: "\(pick.emoji) \(pick.label)", isSelected: selection.contains(pick.id)) {
                            if selection.contains(pick.id) {
                                selection.remove(pick.id)
                            } else {
                                selection.insert(pick.id)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ScrollView { DislikesPicker(selection: .constant(["mushrooms", "group:spicy"]), unitSystem: .imperial).padding() }.creamBackground()
}
