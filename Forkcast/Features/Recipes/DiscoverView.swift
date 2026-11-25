import SwiftUI
import ForkcastCore

/// Search, "Your vibes", "Going viral", "Quick", and "Browse by cuisine". Hard filters always apply.
struct DiscoverView: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(LibraryStore.self) private var library: LibraryStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @State private var query: String = ""
    /// nil = every meal type.
    @State private var mealFilter: MealType? = nil

    private var pool: [Recipe] {
        let all: [Recipe] = repository.browsable(rules: profileStore.plannerProfile, notForMe: library.notForMeIds)
        guard let mealFilter else { return all }
        return all.filter { $0.mealType == mealFilter }
    }

    private var vibeMatches: [Recipe] {
        let vibes: Set<Vibe> = Set(profileStore.profile?.vibes ?? [])
        guard !vibes.isEmpty else { return Array(pool.prefix(10)) }
        return pool
            .filter { !Set($0.vibes).isDisjoint(with: vibes) }
            .sorted { Set($0.vibes).intersection(vibes).count > Set($1.vibes).intersection(vibes).count }
    }

    private var trending: [Recipe] {
        pool.filter { $0.isTrending }
    }

    private var quick: [Recipe] {
        pool.filter { $0.totalMinutes < 25 }.sorted { $0.totalMinutes < $1.totalMinutes }
    }

    private var cuisines: [Cuisine] {
        let present: Set<Cuisine> = Set(pool.map { $0.cuisine })
        return Cuisine.allCases.filter { present.contains($0) && $0 != .other }
    }

    private var searchResults: [Recipe] {
        let trimmed: String = query.trimmingCharacters(in: .whitespaces)
        return pool.filter { recipe in
            recipe.title.localizedCaseInsensitiveContains(trimmed)
                || recipe.cuisine.rawValue.localizedCaseInsensitiveContains(trimmed)
                || recipe.vibes.contains { $0.displayName.localizedCaseInsensitiveContains(trimmed) }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    SearchField(text: $query, prompt: String(localized: "Search recipes"))
                    Label(String(localized: "only showing recipes that fit your diet and allergies"), systemImage: "checkmark.shield")
                        .font(.caption)
                        .foregroundStyle(Theme.aubergineMuted)
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.s) {
                        Chip(title: String(localized: "All"), isSelected: mealFilter == nil) { mealFilter = nil }
                        ForEach(MealType.allCases) { type in
                            Chip(title: "\(type.emoji) \(type.title)", isSelected: mealFilter == type) {
                                mealFilter = mealFilter == type ? nil : type
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.gutter)
                }
                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    RecipeCarousel(title: String(localized: "Your vibes"), recipes: vibeMatches)
                    RecipeCarousel(title: String(localized: "Going viral"), recipes: trending)
                    RecipeCarousel(title: String(localized: "Quick (under 25 min)"), recipes: quick)
                    CuisineGrid(cuisines: cuisines, counts: Dictionary(grouping: pool, by: { $0.cuisine }).mapValues { $0.count })
                } else if searchResults.isEmpty {
                    EmptyState(title: String(localized: "no matches"), message: String(localized: "try a dish, a cuisine or a vibe"), showsMascot: false)
                } else {
                    LazyVStack(spacing: Theme.Spacing.m) {
                        ForEach(searchResults) { recipe in
                            NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                                RecipeRow(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.gutter)
                }
            }
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .scrollDismissesKeyboard(.interactively)
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
