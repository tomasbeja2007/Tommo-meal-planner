import SwiftUI
import ForkcastCore

struct SavedRecipesView: View {
    let onBrowse: () -> Void
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(LibraryStore.self) private var library: LibraryStore

    private let columns: [GridItem] = [GridItem(.flexible(), spacing: Theme.Spacing.m), GridItem(.flexible(), spacing: Theme.Spacing.m)]

    var body: some View {
        let saved: [Recipe] = library.savedIds.compactMap { repository.recipe(id: $0) }
        if saved.isEmpty {
            EmptyState(
                title: String(localized: "no saved recipes yet"),
                message: String(localized: "tap ♡ on any recipe to keep it here."),
                actionTitle: String(localized: "Browse recipes"),
                action: onBrowse
            )
            .frame(maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
                    ForEach(saved) { recipe in
                        NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Theme.Spacing.gutter)
            }
        }
    }
}

struct MyRecipesView: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(AppRouter.self) private var router: AppRouter
    @State private var newDraft: RecipeDraft? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                HStack(spacing: Theme.Spacing.m) {
                    BigActionButton(title: String(localized: "Create a recipe"), systemImage: "square.and.pencil") {
                        newDraft = RecipeDraft()
                    }
                    BigActionButton(title: String(localized: "Import from TikTok / Instagram"), systemImage: "square.and.arrow.down") {
                        router.pendingImportText = nil
                        router.isImportPresented = true
                    }
                }
                if repository.userRecipes.isEmpty {
                    MyRecipesEmptyState()
                } else {
                    LazyVStack(spacing: Theme.Spacing.m) {
                        ForEach(repository.userRecipes) { recipe in
                            NavigationLink(value: RecipeRoute(recipeId: recipe.id)) {
                                RecipeRow(recipe: recipe)
                                    .cardStyle(padding: Theme.Spacing.m)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    repository.delete(userRecipeId: recipe.id)
                                    planStore.recompute()
                                } label: {
                                    Label(String(localized: "Delete"), systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .padding(Theme.Spacing.gutter)
        }
        .fullScreenCover(item: $newDraft) { draft in
            CreateRecipeView(draft: draft)
        }
    }
}

private struct BigActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.s) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Theme.tomato)
                Text(title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Theme.Spacing.m)
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.tomatoSoft))
        }
        .buttonStyle(.plain)
    }
}

private struct MyRecipesEmptyState: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            MascotView(size: 110, mood: .idle)
            Text("your recipes live here")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
            VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                ImportStepRow(number: 1, text: String(localized: "Open a recipe video in TikTok or Instagram"))
                ImportStepRow(number: 2, text: String(localized: "Tap Share, then choose Forkcast"))
                ImportStepRow(number: 3, text: String(localized: "Open Forkcast to check it and save"))
            }
            .cardStyle()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Theme.Spacing.l)
    }
}

struct ImportStepRow: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Text("\(number)")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.white)
                .frame(width: 26, height: 26)
                .background(Circle().fill(Theme.tomato))
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Theme.aubergine)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview { NavigationStack { MyRecipesView() }.previewEnvironment() }
