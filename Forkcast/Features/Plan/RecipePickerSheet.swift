import SwiftUI
import ForkcastCore

/// Search + Saved / My recipes / All filter. Only recipes that pass the
/// user's hard filters are offered.
struct RecipePickerSheet: View {
    let title: String
    let onPick: (String) -> Void

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(LibraryStore.self) private var library: LibraryStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    enum Filter: String, CaseIterable, Identifiable {
        case all
        case saved
        case mine

        var id: String { rawValue }

        var title: String {
            switch self {
            case .all: return String(localized: "All")
            case .saved: return String(localized: "Saved")
            case .mine: return String(localized: "My recipes")
            }
        }
    }

    @State private var filter: Filter = .all
    @State private var query: String = ""

    private var recipes: [Recipe] {
        let pool: [Recipe] = repository.browsable(rules: profileStore.plannerProfile, notForMe: library.notForMeIds)
        let filtered: [Recipe]
        switch filter {
        case .all: filtered = pool
        case .saved: filtered = pool.filter { library.isSaved($0.id) }
        case .mine: filtered = pool.filter { $0.isUserRecipe }
        }
        let trimmed: String = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return filtered }
        return filtered.filter { $0.title.localizedCaseInsensitiveContains(trimmed) || $0.cuisine.rawValue.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.m) {
                SearchField(text: $query, prompt: String(localized: "Search recipes"))
                Picker(String(localized: "Filter"), selection: $filter) {
                    ForEach(Filter.allCases) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                if recipes.isEmpty {
                    EmptyState(title: String(localized: "nothing here yet"), message: String(localized: "try another filter or search"), showsMascot: false)
                    Spacer()
                } else {
                    List(recipes) { recipe in
                        PickerRow(recipe: recipe) {
                            onPick(recipe.id)
                            dismiss()
                        }
                        .listRowBackground(Theme.card)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.top, Theme.Spacing.s)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
        }
    }
}

private struct PickerRow: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    let recipe: Recipe
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.m) {
                DishTileView(recipe: recipe, size: 52)
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                        .lineLimit(2)
                    Text("\(recipe.totalMinutes) min · \(recipe.cuisine.displayName)")
                        .font(.caption)
                        .foregroundStyle(Theme.aubergineMuted)
                    MacrosLine(macros: repository.nutrition(for: recipe).macros)
                }
                Spacer(minLength: 0)
                Image(systemName: "plus.circle.fill").foregroundStyle(Theme.tomato).font(.title3)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview { RecipePickerSheet(title: "add a meal") { _ in }.previewEnvironment() }
