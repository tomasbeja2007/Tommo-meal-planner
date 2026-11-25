import SwiftUI
import ForkcastCore

/// Search, "Your vibes", "Going viral", "Quick", and "Browse by cuisine". Hard filters always apply.
struct DiscoverView: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(LibraryStore.self) private var library: LibraryStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var query = ""
    @State private var filter: Filter = .all
    @State private var limit = 24

    private enum Filter: Hashable {
        case all, mealPrep, viral, quick, family, type(MealType)

        static let options: [Self] = [.all, .mealPrep, .viral, .type(.dinner), .type(.lunch), .type(.breakfast), .type(.snack), .family, .quick]

        var title: String {
            switch self {
            case .all: return String(localized: "All")
            case .mealPrep: return String(localized: "Meal prep")
            case .viral: return String(localized: "Going viral")
            case .quick: return String(localized: "Under 25 min")
            case .family: return String(localized: "Family")
            case .type(let meal): return meal.title
            }
        }

        func includes(_ recipe: Recipe) -> Bool {
            switch self {
            case .all: return true
            case .mealPrep: return recipe.isLeftoverFriendly && recipe.vibes.contains(.batchFriendly)
            case .viral: return recipe.isTrending
            case .quick: return recipe.totalMinutes < 25
            case .family: return recipe.vibes.contains(.family)
            case .type(let type): return recipe.mealType == type
            }
        }
    }

    private var pool: [Recipe] {
        repository.browsable(rules: profileStore.plannerProfile, notForMe: library.notForMeIds)
    }

    private func vibeMatches(in recipes: [Recipe]) -> [Recipe] {
        let preferred = Set(profileStore.profile?.vibes ?? [])
        guard !preferred.isEmpty else { return [] }
        return recipes
            .map { recipe in (recipe: recipe, score: preferred.intersection(recipe.vibes).count) }
            .filter { $0.score > 0 }
            .sorted { $0.score > $1.score }
            .prefix(10)
            .map(\.recipe)
    }

    private func matching(_ recipes: [Recipe], text: String) -> [Recipe] {
        return recipes.filter { recipe in
            filter.includes(recipe) && (text.isEmpty || recipe.title.localizedStandardContains(text)
                || recipe.cuisine.displayName.localizedStandardContains(text)
                || recipe.vibes.contains { $0.displayName.localizedStandardContains(text) })
        }
    }

    var body: some View {
        let all = pool
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        VStack(spacing: 0) {
            SearchField(text: $query, prompt: String(localized: "Search recipes"))
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.s)
            filterRail
            ScrollViewReader { scroll in
                ScrollView {
                    LazyVStack(spacing: Theme.Spacing.l) {
                        Color.clear.frame(height: 0).id("discover-start").accessibilityHidden(true)
                        if filter == .all && text.isEmpty {
                            featuredRecipes(in: all)
                        }
                        resultsGrid(matching(all, text: text))
                    }
                    .padding(.bottom, Theme.Spacing.xxl)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: filter) { _, _ in
                    limit = 24
                    scroll.scrollTo("discover-start", anchor: .top)
                }
                .onChange(of: text) { _, _ in
                    limit = 24
                    scroll.scrollTo("discover-start", anchor: .top)
                }
            }
        }
        .background(Theme.cream.ignoresSafeArea())
    }

    private var filterRail: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.s) {
                ForEach(Filter.options, id: \.self) { item in
                    Chip(title: item.title, systemImage: item == .mealPrep ? "square.stack" : nil, isSelected: item == filter) {
                        filter = item
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.vertical, Theme.Spacing.s)
        }
    }

    @ViewBuilder
    private func featuredRecipes(in recipes: [Recipe]) -> some View {
        let grouped = Dictionary(grouping: recipes, by: \.cuisine)
        RecipeCarousel(title: String(localized: "Going viral"), recipes: Array(recipes.filter(\.isTrending).prefix(12)))
        RecipeCarousel(title: String(localized: "Your vibes"), recipes: vibeMatches(in: recipes))
        CuisineGrid(cuisines: Cuisine.allCases.filter { grouped[$0] != nil && $0 != .other }, counts: grouped.mapValues(\.count))
    }

    @ViewBuilder
    private func resultsGrid(_ recipes: [Recipe]) -> some View {
        if recipes.isEmpty {
            EmptyState(title: String(localized: "No matches"), message: String(localized: "Try another search or filter."), showsMascot: false)
                .padding(.horizontal, Theme.Spacing.gutter)
        } else {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.m),
                                     count: typeSize.isAccessibilitySize ? 1 : 2), spacing: Theme.Spacing.m) {
                ForEach(recipes.prefix(limit)) { recipe in
                    NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                        RecipeCard(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            if recipes.count > limit {
                Button {
                    withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) { limit += 24 }
                } label: {
                    Label("View more recipes", systemImage: "chevron.down")
                }
                .buttonStyle(SecondaryButtonStyle(outlined: true))
                .padding(.horizontal, Theme.Spacing.gutter)
            }
        }
    }
}

struct RecipeCarousel: View {
    let title: String
    let recipes: [Recipe]

    var body: some View {
        if !recipes.isEmpty {
            VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                SectionHeader(title: title)
                    .padding(.horizontal, Theme.Spacing.gutter)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: Theme.Spacing.m) {
                        ForEach(recipes) { recipe in
                            NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                                RecipeCard(recipe: recipe, width: 168)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .padding(.vertical, 6)
                }
            }
        }
    }
}

private struct CuisineGrid: View {
    let cuisines: [Cuisine]
    let counts: [Cuisine: Int]

    private let columns: [GridItem] = [GridItem(.flexible(), spacing: Theme.Spacing.m), GridItem(.flexible(), spacing: Theme.Spacing.m)]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            SectionHeader(title: String(localized: "Browse by cuisine"))
            LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
                ForEach(cuisines, id: \.self) { cuisine in
                    NavigationLink(value: CuisineRoute(cuisine: cuisine)) {
                        HStack(spacing: Theme.Spacing.s) {
                            Text(cuisine.emoji).font(.title2)
                            VStack(alignment: .leading, spacing: 0) {
                                Text(cuisine.displayName)
                                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                    .foregroundStyle(Theme.aubergine)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                Text("\(counts[cuisine] ?? 0) recipes")
                                    .font(.caption)
                                    .foregroundStyle(Theme.aubergineMuted)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(Theme.Spacing.m)
                        .frame(minHeight: 60)
                        .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(Color(hexString: DishPalette.hex(for: cuisine.rawValue)).opacity(0.18)))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.gutter)
    }
}

struct CuisineListView: View {
    let cuisine: Cuisine
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(LibraryStore.self) private var library: LibraryStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        let recipes: [Recipe] = repository.browsable(rules: profileStore.plannerProfile, notForMe: library.notForMeIds).filter { $0.cuisine == cuisine }
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.m) {
                ForEach(recipes) { recipe in
                    NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                        RecipeRow(recipe: recipe)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Theme.Spacing.gutter)
        }
        .background(Theme.cream.ignoresSafeArea())
        .navigationTitle(cuisine.displayName)
    }
}

#Preview { NavigationStack { DiscoverView() }.previewEnvironment() }
