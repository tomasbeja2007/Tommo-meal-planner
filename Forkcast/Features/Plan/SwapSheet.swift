import SwiftUI
import ForkcastCore

/// "swap Tuesday's dinner": top planner alternatives + saved recipes.
struct SwapSheet: View {
    let meal: PlannedMeal

    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(LibraryStore.self) private var library: LibraryStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    @State private var suggestions: [SwapSuggestion] = []
    @State private var isLoading: Bool = true
    @State private var isPickerShown: Bool = false
    @State private var swappedTo: String? = nil

    private var savedOptions: [Recipe] {
        let rules: PlannerProfile = profileStore.plannerProfile
        let notForMe: Set<String> = library.notForMeIds
        return library.savedIds.compactMap { repository.recipe(id: $0) }.filter { recipe in
            !planStore.isInPlan(recipe.id) && repository.passesHardFilters(recipe, rules: rules, notForMe: notForMe)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if isLoading {
                        HStack {
                            ProgressView().tint(Theme.tomato)
                            Text("finding swaps that fit your rules…").foregroundStyle(Theme.aubergineMuted)
                        }
                    } else if suggestions.isEmpty {
                        Text("nothing else fits your rules this week. Try a saved recipe or pick any recipe.")
                            .foregroundStyle(Theme.aubergineMuted)
                    } else {
                        ForEach(suggestions, id: \.recipeId) { suggestion in
                            if let recipe = repository.recipe(id: suggestion.recipeId) {
                                SwapRow(recipe: recipe, delta: suggestion.costDelta, currencyCode: profileStore.currencyCode) {
                                    apply(recipe.id)
                                }
                            }
                        }
                    }
                } header: {
                    Text("suggestions")
                }
                Section {
                    if savedOptions.isEmpty {
                        Text("tap ♡ on a recipe to keep it here")
                            .foregroundStyle(Theme.aubergineMuted)
                    } else {
                        ForEach(savedOptions) { recipe in
                            SwapRow(recipe: recipe, delta: planStore.costDelta(replacing: meal, with: recipe.id), currencyCode: profileStore.currencyCode) {
                                apply(recipe.id)
                            }
                        }
                    }
                } header: {
                    Text("from your saved recipes")
                }
                Section {
                    Button {
                        isPickerShown = true
                    } label: {
                        Label(String(localized: "Pick any recipe"), systemImage: "magnifyingglass")
                            .foregroundStyle(Theme.tomato)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "swap \(DateText.weekdayName(meal.date))'s dinner"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }
            }
            .sheet(isPresented: $isPickerShown) {
                RecipePickerSheet(title: String(localized: "pick a recipe")) { recipeId in
                    isPickerShown = false
                    apply(recipeId)
                }
            }
        }
        .sensoryFeedback(.success, trigger: swappedTo)
        .task {
            suggestions = await planStore.alternatives(for: meal)
            isLoading = false
        }
    }

    private func apply(_ recipeId: String) {
        withAnimation(Theme.spring) {
            planStore.swap(meal, to: recipeId)
        }
        swappedTo = recipeId
        dismiss()
    }
}

private struct SwapRow: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    let recipe: Recipe
    let delta: Double
    let currencyCode: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.m) {
                DishTileView(recipe: recipe, size: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                        .lineLimit(2)
                    Text("\(recipe.totalMinutes) min")
                        .font(.caption)
                        .foregroundStyle(Theme.aubergineMuted)
                    MacrosLine(macros: repository.nutrition(for: recipe).macros)
                }
                Spacer(minLength: 4)
                DeltaChip(delta: delta, currencyCode: currencyCode)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(Theme.card)
    }
}

/// "+$1.20" / "−$0.80"
struct DeltaChip: View {
    let delta: Double
    let currencyCode: String

    var body: some View {
        let cheaper: Bool = delta < -0.005
        Text(MoneyFormat.delta(delta, currencyCode: currencyCode))
            .font(.caption.weight(.bold))
            .monospacedDigit()
            .foregroundStyle(cheaper ? Theme.herb : Theme.aubergineMuted)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(cheaper ? Theme.herbSoft : Theme.creamDeep))
            .accessibilityLabel(Text(cheaper ? "saves \(MoneyFormat.string(-delta, currencyCode: currencyCode))" : "adds \(MoneyFormat.string(delta, currencyCode: currencyCode))"))
    }
}

#Preview {
    Group {
        if let meal = PreviewData.firstMeal {
            SwapSheet(meal: meal)
        } else {
            Text("No meal")
        }
    }
    .previewEnvironment()
}
