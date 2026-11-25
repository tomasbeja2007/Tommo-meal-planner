import SwiftUI
import ForkcastCore

struct CuisineRoute: Hashable {
    let cuisine: Cuisine
}

private enum CookbookRoute: Hashable {
    case discover, favorites, saved, plan, mine
    case collection(String)
}

struct RecipesView: View {
    @Environment(AppRouter.self) private var router
    @Environment(RecipeRepository.self) private var repository
    @Environment(LibraryStore.self) private var library
    @Environment(PlanStore.self) private var planStore
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var query = ""
    @State private var createsCollection = false
    @State private var title = ""

    private var sections: [(CookbookRoute, String, String)] {
        [
            (.favorites, String(localized: "Favorites"), "heart"),
            (.saved, String(localized: "Saved"), "bookmark"),
            (.plan, String(localized: "This Week’s Plan"), "calendar"),
            (.mine, String(localized: "My Recipes"), "square.and.pencil")
        ] + library.collections.map { (.collection($0.id), $0.title, "book.closed") }
    }

    private var filtered: [(CookbookRoute, String, String)] {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return sections.filter { text.isEmpty || $0.1.localizedStandardContains(text) }
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.m), count: typeSize.isAccessibilitySize ? 1 : 2)
    }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.recipesPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    NavigationLink(value: CookbookRoute.discover) { discoverCover }
                        .buttonStyle(.plain)
                    SearchField(text: $query, prompt: String(localized: "Search my cookbooks"))
                    LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
                        if query.isEmpty {
                            Button {
                                title = ""
                                createsCollection = true
                            } label: {
                                collectionCover(title: String(localized: "New cookbook"), subtitle: String(localized: "Start a collection"),
                                                icon: "plus", recipes: [])
                            }
                            .buttonStyle(.plain)
                        }
                        ForEach(filtered, id: \.0) { route, label, icon in
                            let items = recipes(for: route)
                            NavigationLink(value: route) {
                                collectionCover(title: label, subtitle: items.count == 1 ? String(localized: "1 recipe") :
                                    String(localized: "\(items.count) recipes"), icon: icon, recipes: items)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    if filtered.isEmpty && !query.isEmpty {
                        Text("No cookbooks found").foregroundStyle(Theme.aubergineMuted)
                    }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.bottom, 82)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Cookbooks")
            .navigationDestination(for: RecipeRoute.self) { route in
                RecipeDetailView(recipeId: route.recipeId)
            }
            .navigationDestination(for: CuisineRoute.self) { route in
                CuisineListView(cuisine: route.cuisine).toolbar(.hidden, for: .tabBar)
            }
            .navigationDestination(for: CookbookRoute.self) { route in
                destination(route)
            }
            .alert("New cookbook", isPresented: $createsCollection) {
                TextField("Cookbook name", text: $title)
                Button("Cancel", role: .cancel) {}
                Button("Create") {
                    if let id = library.createCollection(title) { router.recipesPath.append(CookbookRoute.collection(id)) }
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    @ViewBuilder
    private func destination(_ route: CookbookRoute) -> some View {
        switch route {
        case .discover:
            DiscoverView()
                .navigationTitle("Discover")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
        case .mine:
            MyRecipesView().navigationTitle("My Recipes")
        default:
            ScrollView {
                let items = recipes(for: route)
                if items.isEmpty {
                    EmptyState(title: String(localized: "No recipes yet"),
                               message: String(localized: "Browse recipes to fill your cookbook."), actionTitle: String(localized: "Discover recipes")) {
                        router.recipesPath.append(CookbookRoute.discover)
                    }
                    .padding(Theme.Spacing.gutter)
                } else {
                    LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
                        ForEach(items) { recipe in
                            NavigationLink(value: RecipeRoute(recipeId: recipe.id)) { RecipeCard(recipe: recipe) }
                                .buttonStyle(.plain)
                        }
                    }
                    .padding(Theme.Spacing.gutter)
                }
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(sections.first { $0.0 == route }?.1 ?? "")
        }
    }

    private func recipes(for route: CookbookRoute) -> [Recipe] {
        let ids: [String]
        switch route {
        case .favorites: ids = library.favorites.sorted()
        case .saved: ids = library.savedIds
        case .plan: ids = planStore.meals.map(\.recipeId)
        case .mine: return repository.userRecipes
        case .collection(let id): ids = library.collections.first { $0.id == id }?.recipeIDs ?? []
        case .discover: return []
        }
        var seen: Set<String> = []
        return ids.compactMap { seen.insert($0).inserted ? repository.recipe(id: $0) : nil }
    }

    private var discoverCover: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Tommo recipes").font(.caption.weight(.heavy)).textCase(.uppercase)
                        .foregroundStyle(Theme.tomatoDeep)
                    Text("Discover").font(.system(.title, design: .rounded, weight: .bold)).foregroundStyle(Theme.aubergine)
                    Text("Fresh ideas for your week").font(.subheadline).foregroundStyle(Theme.aubergineMuted)
                }
                Spacer(minLength: 0)
                ZStack {
                    if let first = repository.recipe(id: "crispy-salmon-rice-bowl") {
                        DishTileView(recipe: first, size: 70).rotationEffect(.degrees(-12)).offset(x: -17, y: -8)
                    }
                    if let second = repository.recipe(id: "smash-burger-tacos") {
                        DishTileView(recipe: second, size: 70).rotationEffect(.degrees(12)).offset(x: 13, y: 10)
                    }
                }
                .frame(width: 112, height: 94)
            }
            Label("Browse recipes", systemImage: "arrow.right").font(.subheadline.weight(.bold)).foregroundStyle(Theme.tomatoDeep)
        }
        .padding(Theme.Spacing.l)
        .background(Theme.tomatoSoft, in: RoundedRectangle(cornerRadius: Theme.Radius.card))
        .accessibilityElement(children: .combine)
    }

    private func collectionCover(title: String, subtitle: String, icon: String, recipes: [Recipe]) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            HStack(spacing: Theme.Spacing.xs) {
                if recipes.isEmpty {
                    Image(systemName: icon).font(.title2.weight(.medium)).foregroundStyle(Theme.tomatoDeep)
                        .accessibilityHidden(true)
                } else {
                    ForEach(recipes.prefix(2)) { recipe in
                        DishTileView(recipe: recipe, size: 45, cornerRadius: Theme.Radius.small)
                    }
                }
            }
            .frame(height: 48)
            Text(title).font(.system(.subheadline, design: .rounded, weight: .bold)).foregroundStyle(Theme.aubergine)
            Text(subtitle).font(.caption).foregroundStyle(Theme.aubergineMuted)
        }
        .frame(maxWidth: .infinity, minHeight: 108, alignment: .leading)
        .cardStyle(padding: Theme.Spacing.m)
        .accessibilityElement(children: .combine)
    }
}

/// Grid/carousel card.
struct RecipeCard: View {
    let recipe: Recipe
    var width: CGFloat? = nil
    @Environment(RecipeRepository.self) private var repository: RecipeRepository

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.inline) {
            GeometryReader { proxy in
                DishTileView(recipe: recipe, size: proxy.size.width, height: 110, cornerRadius: Theme.Radius.button)
            }
            .frame(height: 110)
            Text(recipe.title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
            Text("\(recipe.prepMinutes)m prep · \(recipe.cookMinutes)m cook")
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
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
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
