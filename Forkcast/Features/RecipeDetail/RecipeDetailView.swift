import SwiftUI
import ForkcastCore

struct RecipeDetailView: View {
    let recipeId: String

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        if let recipe = repository.recipe(id: recipeId) {
            RecipeDetailContent(recipe: recipe, plannedMeal: planStore.plannedMeal(for: recipeId))
        } else {
            EmptyState(title: String(localized: "recipe not found"), message: String(localized: "it may have been deleted."), showsMascot: true)
                .creamBackground()
        }
    }
}

private enum DetailTab: String, CaseIterable, Identifiable {
    case ingredients
    case method

    var id: String { rawValue }
    var title: String { self == .ingredients ? String(localized: "Ingredients") : String(localized: "Instructions") }
}

private struct RecipeDetailContent: View {
    let recipe: Recipe
    let plannedMeal: PlannedMeal?

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(LibraryStore.self) private var library: LibraryStore

    @State private var servings: Int = 2
    @State private var showNutritionTotal = false
    @State private var tab: DetailTab = .ingredients
    @State private var timer: CountdownTimer = CountdownTimer()
    @State private var isCookModeShown: Bool = false
    @State private var cookStep = 0
    @State private var isSwapShown: Bool = false
    @State private var isAddToPlanShown: Bool = false
    @State private var isEditShown: Bool = false
    @State private var isStarsShown: Bool = false
    @State private var addedToList: Bool = false
    @State private var didSetServings: Bool = false

    private var nutrition: NutritionResult { repository.nutrition(for: recipe) }

    private var nutritionCaption: String {
        if showNutritionTotal {
            return nutrition.isManualOverride
                ? String(localized: "total for \(servings) · based on your entry")
                : String(localized: "total for \(servings) · estimated")
        }
        return nutrition.isManualOverride
            ? String(localized: "per serving · entered by you")
            : String(localized: "per serving · estimated")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                DishHeroView(recipe: recipe, height: 260)
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    DetailHeader(recipe: recipe, servings: Double(servings), costPerServing: repository.costPerServing(recipe, pricing: profileStore.pricing, unitSystem: profileStore.unitSystem), currencyCode: profileStore.currencyCode, profile: repository.profile(for: recipe))
                    VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                        Picker(String(localized: "Nutrition amounts"), selection: $showNutritionTotal) {
                            Text("Per serving").tag(false)
                            Text("Selected servings").tag(true)
                        }
                        .pickerStyle(.segmented)
                        MacrosCard(
                            macros: nutrition.macros.scaled(by: showNutritionTotal ? Double(servings) : 1),
                            caption: nutritionCaption,
                            note: nutrition.hasIncompleteData ? String(localized: "some ingredients have no nutrition data") : nil
                        )
                    }
                    Picker(String(localized: "Section"), selection: $tab) {
                        ForEach(DetailTab.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    if tab == .ingredients {
                        IngredientsSection(
                            recipe: recipe,
                            servings: $servings,
                            isInPlan: plannedMeal != nil,
                            addedToList: addedToList,
                            onAddToList: {
                                planStore.addRecipeToExtras(recipe, servings: Double(servings))
                                addedToList = true
                            }
                        )
                    } else {
                        MethodSection(recipe: recipe, servings: Double(servings), timer: timer) { isCookModeShown = true }
                    }
                    DetailFooter(
                        recipe: recipe,
                        plannedMeal: plannedMeal,
                        onMarkCooked: { isStarsShown = true },
                        onSwap: { isSwapShown = true },
                        onAddToPlan: { isAddToPlanShown = true }
                    )
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.l)
                .padding(.bottom, timer.isActive ? 100 : Theme.Spacing.xxl)
            }
        }
        .background(Theme.cream.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar { toolbarContent }
        .overlay(alignment: .bottom) {
            if timer.isActive {
                TimerPill(timer: timer)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .padding(.bottom, Theme.Spacing.s)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(Theme.spring, value: timer.isActive)
        .fullScreenCover(isPresented: $isCookModeShown) {
            CookModeView(recipe: recipe, servings: Double(servings), index: $cookStep, timer: timer, isPlanned: plannedMeal != nil) { stars in
                markCooked(stars: stars)
                cookStep = 0
            }
        }
        .sheet(isPresented: $isSwapShown) {
            if let plannedMeal {
                SwapSheet(meal: plannedMeal)
            }
        }
        .sheet(isPresented: $isAddToPlanShown) {
            AddToPlanSheet(recipe: recipe, servings: Double(servings))
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isStarsShown) {
            CookedRatingSheet(recipe: recipe) { stars in
                markCooked(stars: stars)
            }
            .presentationDetents([.height(340)])
        }
        .sheet(isPresented: $isEditShown) {
            if let model = repository.userRecipeModel(id: recipe.id) {
                CreateRecipeView(editing: model)
            }
        }
        .onAppear {
            guard !didSetServings else { return }
            didSetServings = true
            let planned: Double = plannedMeal?.servings ?? profileStore.defaultServings
            servings = max(1, Int(planned.rounded()))
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            if recipe.isUserRecipe {
                Button(String(localized: "Edit")) { isEditShown = true }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.card)
                    .foregroundStyle(Theme.aubergine)
            }
            Button {
                library.toggleSaved(recipe.id)
            } label: {
                Image(systemName: library.isSaved(recipe.id) ? "heart.fill" : "heart")
                    .foregroundStyle(Theme.tomato)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Theme.card))
            }
            .sensoryFeedback(.selection, trigger: library.isSaved(recipe.id))
            .accessibilityLabel(Text(library.isSaved(recipe.id) ? "Remove from saved" : "Save recipe"))
            ShareLink(item: RecipeShareText.make(recipe: recipe, servings: Double(servings), catalog: repository.catalog, system: profileStore.unitSystem)) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(Theme.aubergine)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Theme.card))
            }
            .accessibilityLabel(Text("Share recipe"))
        }
    }

    private func markCooked(stars: Int) {
        if stars > 0 {
            library.setStars(stars, for: recipe.id)
        }
        if plannedMeal != nil {
            planStore.markCooked(recipeId: recipe.id)
        }
        Haptics.success()
    }
}

private struct DetailHeader: View {
    let recipe: Recipe
    let servings: Double
    let costPerServing: Double
    let currencyCode: String
    let profile: RecipeProfile

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text(recipe.title)
                .font(.system(.title, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            HStack(spacing: Theme.Spacing.m) {
                Label("\(recipe.totalMinutes) min", systemImage: "clock")
                Label(String(localized: "serves \(FractionFormatter.string(servings))"), systemImage: "person.2")
                Label("~\(MoneyFormat.string(costPerServing, currencyCode: currencyCode)) / serving", systemImage: "tag")
            }
            .font(.subheadline)
            .labelStyle(CompactLabelStyle())
            .foregroundStyle(Theme.aubergineMuted)
            .monospacedDigit()
            FlowLayout(spacing: 6) {
                if profile.diet != .omnivore {
                    TagLabel(text: profile.diet.displayName, tint: Theme.herb, fill: Theme.herbSoft)
                }
                if profile.isGlutenFree {
                    TagLabel(text: String(localized: "Gluten-free"))
                }
                if profile.isDairyFree {
                    TagLabel(text: String(localized: "Dairy-free"))
                }
                ForEach(recipe.vibes, id: \.self) { vibe in
                    TagLabel(text: vibe.displayName, tint: Theme.tomatoDeep, fill: Theme.tomatoSoft)
                }
            }
        }
    }
}

private struct IngredientsSection: View {
    let recipe: Recipe
    @Binding var servings: Int
    let isInPlan: Bool
    let addedToList: Bool
    let onAddToList: () -> Void

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        let lines: [IngredientLine] = IngredientLine.lines(for: recipe, servings: Double(servings), catalog: repository.catalog, system: profileStore.unitSystem)
        let main: [IngredientLine] = lines.filter { !$0.isPantryStaple }
        let staples: [IngredientLine] = lines.filter { $0.isPantryStaple }
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            HStack {
                Text("Servings")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                Spacer()
                RoundStepper(value: $servings, range: 1...12)
            }
            .cardStyle(padding: Theme.Spacing.m)
            VStack(spacing: 0) {
                ForEach(main) { line in
                    IngredientRow(line: line)
                    if line.id != main.last?.id { Divider().overlay(Theme.line) }
                }
            }
            .cardStyle(padding: Theme.Spacing.m)
            if !staples.isEmpty {
                Text("you probably have these")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.aubergineMuted)
                VStack(spacing: 0) {
                    ForEach(staples) { line in
                        IngredientRow(line: line)
                    }
                }
                .cardStyle(padding: Theme.Spacing.m)
            }
            if !isInPlan {
                Button(action: onAddToList) {
                    Label(addedToList ? String(localized: "Added to Extras") : String(localized: "Add to grocery list"), systemImage: addedToList ? "checkmark" : "cart.badge.plus")
                }
                .buttonStyle(SecondaryButtonStyle(outlined: true))
                .disabled(addedToList)
                .sensoryFeedback(.success, trigger: addedToList)
            }
        }
    }
}

private struct IngredientRow: View {
    let line: IngredientLine

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            IngredientThumbnail(ingredientID: line.ingredientID)
            VStack(alignment: .leading, spacing: 1) {
                Text(line.name.capitalizedFirst)
                    .font(.body)
                    .foregroundStyle(Theme.aubergine)
                if let note = line.note {
                    Text(note).font(.caption).foregroundStyle(Theme.aubergineFaint)
                }
                if !line.isLinked {
                    Text("no nutrition data").font(.caption2).foregroundStyle(Theme.aubergineFaint)
                }
            }
            Spacer(minLength: 8)
            Text(line.amountText)
                .font(.body.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(Theme.aubergine)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}

private struct MethodSection: View {
    let recipe: Recipe
    let servings: Double
    let timer: CountdownTimer
    let onCook: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            PrimaryButton(String(localized: "Cook step by step"), systemImage: "play.fill", action: onCook)
                .disabled(recipe.steps.isEmpty)
            if recipe.steps.isEmpty {
                Text("no steps yet").foregroundStyle(Theme.aubergineMuted)
            }
            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                StepRow(number: index + 1, text: step, recipe: recipe, servings: servings, timer: timer)
            }
        }
    }
}

private struct StepRow: View {
    let number: Int
    let text: String
    let recipe: Recipe
    let servings: Double
    let timer: CountdownTimer

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            Text("\(number)")
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.tomatoDeep)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Theme.tomatoSoft))
            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                Text(text)
                    .font(.body)
                    .foregroundStyle(Theme.aubergine)
                    .fixedSize(horizontal: false, vertical: true)
                StepChips(text: text, recipe: recipe, servings: servings, timer: timer)
            }
        }
    }
}

/// Ingredient chips and tappable timer chips for one step.
struct StepChips: View {
    let text: String
    let recipe: Recipe
    let servings: Double
    let timer: CountdownTimer

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        let used = StepIngredientMatcher.ingredients(in: text, recipe: recipe, catalog: repository.catalog)
        let timers = TimerDetector.timers(in: text)
        if !used.isEmpty || !timers.isEmpty {
            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                if !used.isEmpty {
                    Text("Amounts for the full recipe")
                        .font(.caption)
                        .foregroundStyle(Theme.aubergineMuted)
                    FlowLayout(spacing: 6) {
                        ForEach(Array(used.enumerated()), id: \.offset) { _, item in
                            ingredientChip(item)
                        }
                    }
                }
                if !timers.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(timers) { stepTimer in
                            Button {
                                timer.start(label: stepTimer.label, seconds: stepTimer.seconds)
                            } label: {
                                Label(stepTimer.label, systemImage: "timer")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.aubergine)
                                    .padding(.horizontal, 10)
                                    .frame(minHeight: 44)
                                    .background(Capsule().fill(Theme.saffronSoft))
                                    .overlay(Capsule().stroke(Theme.saffron, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(Text("Start a \(stepTimer.label) timer"))
                        }
                    }
                }
            }
        }
    }

    private func ingredientChip(_ item: RecipeIngredient) -> some View {
        let ingredient = item.ingredientId.flatMap { repository.catalog.ingredient(id: $0) }
        let system = profileStore.unitSystem
        let amount = item.amount * servings / Double(max(1, recipe.baseServings))
        let quantity = QuantityFormatter.string(amount: amount, unit: item.unit, system: system, ingredient: ingredient)
        let name = ingredient?.displayName(for: system) ?? item.name ?? String(localized: "Ingredient")
        return HStack(spacing: 4) {
            IngredientThumbnail(ingredientID: ingredient?.id, size: 24)
            Text(name.capitalizedFirst)
                .font(.caption.weight(.semibold))
            if !quantity.isEmpty {
                Text(quantity)
                    .font(.caption.monospacedDigit())
            }
        }
        .foregroundStyle(Theme.aubergine)
        .padding(.leading, 2)
        .padding(.trailing, 8)
        .padding(.vertical, 2)
        .background(Theme.creamDeep, in: Capsule())
        .accessibilityElement(children: .combine)
    }
}

/// Floating countdown.
struct TimerPill: View {
    let timer: CountdownTimer

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            ProgressRing(value: timer.progress, lineWidth: 4, tint: timer.didFinish ? Theme.herb : Theme.saffron)
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 0) {
                Text(timer.didFinish ? String(localized: "time's up") : timer.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.aubergineMuted)
                Text(TimerDetector.clock(timer.remaining))
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergine)
                    .contentTransition(.numericText(countsDown: true))
            }
            Spacer()
            if !timer.didFinish {
                Button {
                    timer.togglePause()
                } label: {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.creamDeep))
                }
                .accessibilityLabel(Text(timer.isRunning ? "Pause timer" : "Resume timer"))
            }
            Button {
                timer.reset()
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Theme.creamDeep))
            }
            .accessibilityLabel(Text("Restart timer"))
            Button {
                timer.stop()
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Theme.creamDeep))
            }
            .accessibilityLabel(Text("Stop timer"))
        }
        .foregroundStyle(Theme.aubergine)
        .padding(Theme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                .fill(Theme.card)
                .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 4)
        )
        .animation(.default, value: timer.remaining)
    }
}

/// Like / Not for me, Mark as cooked, Swap or Add to plan.
private struct DetailFooter: View {
    let recipe: Recipe
    let plannedMeal: PlannedMeal?
    let onMarkCooked: () -> Void
    let onSwap: () -> Void
    let onAddToPlan: () -> Void

    @Environment(LibraryStore.self) private var library: LibraryStore

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            Divider().overlay(Theme.line).padding(.vertical, Theme.Spacing.s)
            HStack(spacing: Theme.Spacing.m) {
                PillToggle(title: String(localized: "Like"), systemImage: "heart", isOn: library.rating(for: recipe.id) == .like) {
                    library.setRating(.like, for: recipe.id)
                }
                PillToggle(title: String(localized: "Not for me"), systemImage: "hand.thumbsdown", isOn: library.rating(for: recipe.id) == .notForMe) {
                    library.setRating(.notForMe, for: recipe.id)
                }
            }
            if let plannedMeal {
                Button(action: onMarkCooked) {
                    Label(plannedMeal.isCooked ? String(localized: "Cooked") : String(localized: "Mark as cooked"), systemImage: plannedMeal.isCooked ? "checkmark.circle.fill" : "checkmark.circle")
                }
                .buttonStyle(SecondaryButtonStyle(outlined: false))
                .disabled(plannedMeal.isCooked)
                Button(action: onSwap) {
                    Label(String(localized: "Swap this meal"), systemImage: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(SecondaryButtonStyle(outlined: true))
            } else {
                Button(action: onMarkCooked) {
                    Label(String(localized: "Mark as cooked"), systemImage: "checkmark.circle")
                }
                .buttonStyle(SecondaryButtonStyle(outlined: false))
                Button(action: onAddToPlan) {
                    Label(String(localized: "Add to plan"), systemImage: "calendar.badge.plus")
                }
                .buttonStyle(SecondaryButtonStyle(outlined: true))
            }
        }
    }
}

struct PillToggle: View {
    let title: String
    let systemImage: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: isOn ? systemImage + ".fill" : systemImage)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(isOn ? Color.white : Theme.aubergine)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Capsule().fill(isOn ? Theme.tomato : Theme.creamDeep))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isOn)
        .accessibilityAddTraits(isOn ? [.isSelected] : [])
    }
}

#Preview {
    NavigationStack { RecipeDetailView(recipeId: "chickpea-spinach-curry") }.previewEnvironment()
}
