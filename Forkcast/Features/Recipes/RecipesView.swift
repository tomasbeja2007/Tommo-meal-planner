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
                    ScreenTitleBar(String(localized: "Cookbooks"))
                    NavigationLink(value: CookbookRoute.discover) { discoverCover }
                        .buttonStyle(.plain)
                    SearchField(text: $query, prompt: String(localized: "Search my cookbooks"))
                    LazyVGrid(columns: columns, spacing: Theme.Spacing.l) {
                        if query.isEmpty {
                            Button {
                                title = ""
                                createsCollection = true
                            } label: {
                                newCookbookCover
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
                .padding(.bottom, Theme.Size.tabBarClearance)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Cookbooks")
            .toolbar(.hidden, for: .navigationBar)
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

    /// Three sharp, colourful photos for the Discover card.
    private var discoverRecipes: [Recipe] {
        ["shakshuka", "chicken-caesar-salad", "black-bean-tacos"].compactMap { repository.recipe(id: $0) }
    }

    /// A bold tomato card: eyebrow, title, line, white "Browse recipes" pill, and a fan of three photos.
    private var discoverCover: some View {
        HStack(alignment: .center, spacing: Theme.Spacing.s) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text("Tommo recipes")
                    .font(Theme.Typography.eyebrow)
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.white.opacity(0.85))
                Text("Discover")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.white)
                Text("Fresh ideas for your week")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.white.opacity(0.92))
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: Theme.Spacing.xs) {
                    Text("Browse recipes")
                    Image(systemName: "chevron.right").font(.caption.weight(.bold))
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.tomatoDeep)
                .padding(.horizontal, Theme.Spacing.l)
                .frame(minHeight: 40)
                .background(Capsule().fill(Color.white))
                .padding(.top, Theme.Spacing.m)
            }
            .layoutPriority(1)
            Spacer(minLength: 0)
            PhotoFan(recipes: discoverRecipes)
                .frame(width: 128, height: 132)
                .accessibilityHidden(true)
        }
        .padding(Theme.Spacing.gutter)
        .background(Theme.tomatoDeep, in: RoundedRectangle(cornerRadius: Theme.Radius.large, style: .continuous))
        .elevation(Theme.Elevation.card)
        .accessibilityElement(children: .combine)
    }

    /// Dashed-feel outlined tile with a big plus, same size as the cookbook covers.
    private var newCookbookCover: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
            RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                .fill(Theme.tomatoSoft.opacity(0.45))
                .overlay(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).strokeBorder(Theme.tomato, lineWidth: 2))
                .overlay {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Theme.tomatoDeep)
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Theme.tomatoSoft))
                }
                .frame(height: CookbookMosaic.height)
            coverCaption(title: String(localized: "New cookbook"), subtitle: String(localized: "Start a collection"))
        }
        .accessibilityElement(children: .combine)
    }

    private func collectionCover(title: String, subtitle: String, icon: String, recipes: [Recipe]) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
            CookbookMosaic(recipes: recipes, icon: icon)
            coverCaption(title: title, subtitle: subtitle)
        }
        .accessibilityElement(children: .combine)
    }

    private func coverCaption(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
            Text(title)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(1)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.aubergineMuted)
        }
        .padding(.top, Theme.Spacing.s)
        .padding(.horizontal, Theme.Spacing.xxs)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// The Discover card's fanned stack of photos with white borders.
private struct PhotoFan: View {
    let recipes: [Recipe]

    var body: some View {
        // Back-left, back-right, then the front card in the middle.
        let poses: [(angle: Double, x: CGFloat, y: CGFloat)] = [(-12, -30, 8), (11, 30, -2), (0, 0, 6)]
        ZStack {
            ForEach(Array(recipes.prefix(3).enumerated()), id: \.offset) { index, recipe in
                let pose = poses[index]
                DishTileView(recipe: recipe, size: 76, height: 100, cornerRadius: Theme.Radius.button)
                    .overlay(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).strokeBorder(Color.white, lineWidth: 3))
                    .elevation(Theme.Elevation.lifted)
                    .rotationEffect(.degrees(pose.angle))
                    .offset(x: pose.x, y: pose.y)
            }
        }
    }
}

/// A cookbook cover: one big photo and two small ones, with the recipe count on a badge.
/// Empty cookbooks show soft placeholder blocks and their icon.
private struct CookbookMosaic: View {
    static let height: CGFloat = 150
    let recipes: [Recipe]
    let icon: String

    var body: some View {
        GeometryReader { proxy in
            let gap: CGFloat = Theme.Spacing.xxs
            let bigWidth = (proxy.size.width - gap) * 0.62
            let smallWidth = proxy.size.width - gap - bigWidth
            let smallHeight = (proxy.size.height - gap) / 2
            HStack(spacing: gap) {
                slot(0, width: bigWidth, height: proxy.size.height, showsIcon: true)
                VStack(spacing: gap) {
                    slot(1, width: smallWidth, height: smallHeight)
                    slot(2, width: smallWidth, height: smallHeight)
                }
            }
        }
        .frame(height: Self.height)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
        .overlay(alignment: .bottomLeading) {
            HStack(spacing: Theme.Spacing.xs) {
                Image(systemName: "book.closed").font(.caption.weight(.semibold))
                Text("\(recipes.count)").font(.subheadline.weight(.bold)).monospacedDigit()
            }
            .foregroundStyle(Theme.aubergine)
            .padding(.horizontal, Theme.Spacing.m)
            .padding(.vertical, Theme.Spacing.xs)
            .background(Capsule().fill(Theme.card.opacity(0.92)))
            .padding(Theme.Spacing.m)
            .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private func slot(_ index: Int, width: CGFloat, height: CGFloat, showsIcon: Bool = false) -> some View {
        if index < recipes.count {
            DishTileView(recipe: recipes[index], size: width, height: height, cornerRadius: 0)
        } else {
            Rectangle()
                .fill(Theme.creamDeep)
                .frame(width: width, height: height)
                .overlay {
                    if showsIcon && recipes.isEmpty {
                        Image(systemName: icon)
                            .font(.system(size: 26, weight: .medium))
                            .foregroundStyle(Theme.tomato.opacity(0.7))
                    }
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
                .elevation(Theme.Elevation.card)
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
