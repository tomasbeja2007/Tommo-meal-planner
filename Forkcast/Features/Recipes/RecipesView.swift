import SwiftUI
import ForkcastCore

struct CuisineRoute: Hashable {
    let cuisine: Cuisine
}

/// Discover · Saved · My recipes.
struct RecipesView: View {
    @Environment(AppRouter.self) private var router: AppRouter

    enum Segment: String, CaseIterable, Identifiable {
        case discover
        case saved
        case mine

        var id: String { rawValue }

        var title: String {
            switch self {
            case .discover: return String(localized: "Discover")
            case .saved: return String(localized: "Saved")
            case .mine: return String(localized: "My recipes")
            }
        }
    }

    @State private var segment: Segment = .discover

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.recipesPath) {
            VStack(spacing: Theme.Spacing.m) {
                Picker(String(localized: "Section"), selection: $segment) {
                    ForEach(Segment.allCases) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Theme.Spacing.gutter)
                switch segment {
                case .discover:
                    DiscoverView()
                case .saved:
                    SavedRecipesView { segment = .discover }
                case .mine:
                    MyRecipesView()
                }
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "Recipes"))
            .navigationDestination(for: RecipeRoute.self) { route in
                RecipeDetailView(recipeId: route.recipeId)
            }
            .navigationDestination(for: CuisineRoute.self) { route in
                CuisineListView(cuisine: route.cuisine)
            }
        }
    }
}

/// Grid/carousel card.
struct RecipeCard: View {
    let recipe: Recipe
    var width: CGFloat? = nil
    @Environment(RecipeRepository.self) private var repository: RecipeRepository

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            GeometryReader { proxy in
                DishTileView(recipe: recipe, size: proxy.size.width, height: 110, cornerRadius: 16)
            }
            .frame(height: 110)
            Text(recipe.title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
            Text("\(recipe.totalMinutes) min")
                .font(.caption)
                .foregroundStyle(Theme.aubergineMuted)
            MacrosLine(macros: repository.nutrition(for: recipe).macros, font: .caption2)
        }
        .padding(Theme.Spacing.s)
        .frame(width: width)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                .fill(Theme.card)
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
        .accessibilityElement(children: .combine)
    }
}

/// Compact list row.
struct RecipeRow: View {
    let recipe: Recipe
    @Environment(RecipeRepository.self) private var repository: RecipeRepository

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            DishTileView(recipe: recipe, size: 60)
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .lineLimit(2)
                Text("\(recipe.totalMinutes) min · \(recipe.isUserRecipe ? String(localized: "My recipe") : recipe.cuisine.displayName)")
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineMuted)
                MacrosLine(macros: repository.nutrition(for: recipe).macros)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(Theme.aubergineFaint)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

#Preview { RecipesView().previewEnvironment() }
