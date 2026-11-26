import SwiftUI
import PhotosUI
import ImageIO
import UIKit
import StoreKit
import ForkcastCore

struct RecipeDetailView: View {
    let recipeId: String
    var plannedMealID: UUID? = nil

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        if let recipe = repository.recipe(id: recipeId) {
            RecipeDetailContent(recipe: recipe, plannedMeal: planStore.plannedMeal(for: recipeId, id: plannedMealID))
                .toolbar(.hidden, for: .tabBar)
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
    @Environment(\.requestReview) private var requestReview: RequestReviewAction
    @AppStorage(FeatureFlags.reviewRequestedKey) private var didAskForReview = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsListPicker = false
    @State private var photoItem: PhotosPickerItem?
    @State private var personalPhoto: UIImage?
    @State private var photoError = false
    @State private var loadingPhoto = false
    @State private var servings: Double = 2
    @State private var showNutritionTotal = false
    @State private var tab: DetailTab = .ingredients
    @State private var displayUnits: UnitSystem?

    private var unitSystem: UnitSystem { displayUnits ?? profileStore.unitSystem }
    @State private var timer: CountdownTimer = CountdownTimer()
    @State private var isCookModeShown: Bool = false
    @State private var cookStep = 0
    @State private var isSwapShown: Bool = false
    @State private var isAddToPlanShown: Bool = false
    @State private var isEditShown: Bool = false
    @State private var addedLists: Set<String> = []
    @State private var didSetServings: Bool = false
    /// The page settles in once: the photo eases from 106% to 100%, the sheet rises 14 pt.
    @State private var appeared = false
    @Namespace private var segmentPill

    private let heroHeight: CGFloat = 420
    /// How far the cream sheet rises over the photo.
    private let sheetOverlap: CGFloat = 28

    private var nutrition: NutritionResult { repository.nutrition(for: recipe) }

    private var plannedServings: Double {
        plannedMeal.map { planStore.servingsToCook(for: $0) } ?? profileStore.defaultServings
    }

    private var nutritionCaption: String {
        if showNutritionTotal {
            let count = FractionFormatter.string(servings)
            return nutrition.isManualOverride
                ? String(localized: "total for \(count) · based on your entry")
                : String(localized: "total for \(count) · estimated")
        }
        return nutrition.isManualOverride
            ? String(localized: "per serving · entered by you")
            : String(localized: "per serving · estimated")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                hero
                VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                    DetailHeader(recipe: recipe, profile: repository.profile(for: recipe))
                    FactsStrip(
                        recipe: recipe,
                        kcal: nutrition.macros.kcal,
                        costText: "~" + MoneyFormat.string(repository.costPerServing(recipe, pricing: profileStore.pricing, unitSystem: profileStore.unitSystem), currencyCode: profileStore.currencyCode)
                    )
                    actionBar
                    VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                        CapsuleSegments(options: DetailTab.allCases, selection: $tab, title: { $0.title }, namespace: segmentPill, id: "tab")
                        if tab == .ingredients {
                            IngredientsSection(
                                recipe: recipe,
                                servings: $servings,
                                maxServings: max(12, plannedServings.rounded(.up)),
                                system: unitSystem,
                                onChangeUnits: { displayUnits = $0 },
                                addedToList: !addedLists.isEmpty,
                                onAddToList: { showsListPicker = true }
                            )
                            .transition(.opacity)
                        } else {
                            MethodSection(recipe: recipe, servings: servings, system: unitSystem, timer: timer)
                                .transition(.opacity)
                        }
                    }
                    VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                        Text("Nutrition")
                            .font(Theme.Typography.title3)
                            .foregroundStyle(Theme.aubergine)
                            .accessibilityAddTraits(.isHeader)
                        CapsuleSegments(options: [false, true], selection: $showNutritionTotal,
                                        title: { $0 ? String(localized: "All \(FractionFormatter.string(servings)) servings") : String(localized: "Per serving") },
                                        namespace: segmentPill, id: "nutrition")
                        MacrosCard(
                            macros: nutrition.macros.scaled(by: showNutritionTotal ? servings : 1),
                            caption: nutritionCaption,
                            note: nutrition.hasIncompleteData ? String(localized: "Some ingredients have no nutrition data") : nil,
                            title: showNutritionTotal ? String(localized: "Macros · selected servings") : String(localized: "Macros · your portion")
                        )
                    }
                    cookedCard
                    RecipeVote(recipeID: recipe.id)
                    if isIllustrative {
                        // Honest, but out of the way: the note lives at the foot of the page, not on the photo.
                        Text("Photo shows how the dish can look.")
                            .font(Theme.Typography.footnote)
                            .foregroundStyle(Theme.aubergineMuted)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.xl)
                .padding(.bottom, Theme.Spacing.xxl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    UnevenRoundedRectangle(topLeadingRadius: sheetOverlap, topTrailingRadius: sheetOverlap, style: .continuous)
                        .fill(Theme.cream)
                        .shadow(color: Theme.aubergine.opacity(0.06), radius: 10, y: -4)
                )
                .padding(.top, -sheetOverlap)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)
            }
        }
        .coordinateSpace(.named("detailScroll"))
        .animation(Theme.motion(reduceMotion), value: tab)
        .background(Theme.cream.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar { toolbarContent }
        .safeAreaInset(edge: .bottom) { bottomBar }
        .animation(Theme.motion(reduceMotion), value: timer.isActive)
        .fullScreenCover(isPresented: $isCookModeShown) {
            CookModeView(recipe: recipe, servings: servings, system: unitSystem, index: $cookStep, timer: timer, isPlanned: plannedMeal != nil) { stars in
                markCooked(stars: stars)
                cookStep = 0
            }
        }
        .confirmationDialog("Add to groceries", isPresented: $showsListPicker, titleVisibility: .visible) {
            Button(plannedMeal == nil ? "Main list" : "Main list · already planned") { addToGroceries(nil) }
                .disabled(plannedMeal != nil || addedLists.contains(""))
            Button("Usuals") { addToGroceries(PlanStore.usualsListID) }
                .disabled(addedLists.contains(PlanStore.usualsListID))
            ForEach(planStore.groceryCollections, id: \.id) { list in
                Button(list.title) { addToGroceries(list.id) }
                    .disabled(addedLists.contains(list.id))
            }
        }
        .alert("Couldn’t update the recipe photo", isPresented: $photoError) {
            Button("OK", role: .cancel) {}
        }
        .task(id: photoItem) {
            guard let photoItem else { return }
            await selectPhoto(photoItem)
        }
        .sheet(isPresented: $isSwapShown) {
            if let plannedMeal {
                SwapSheet(meal: plannedMeal)
            }
        }
        .sheet(isPresented: $isAddToPlanShown) {
            AddToPlanSheet(recipe: recipe, servings: servings)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isEditShown) {
            if let model = repository.userRecipeModel(id: recipe.id) {
                CreateRecipeView(editing: model)
            }
        }
        .onAppear {
            guard !didSetServings else { return }
            didSetServings = true
            personalPhoto = library.photo(for: recipe.id).flatMap { UIImage(data: $0) }
            servings = max(1, plannedServings)
            withAnimation(reduceMotion ? nil : Animation.open(0.7)) { appeared = true }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button { library.toggleFavorite(recipe.id) } label: {
                Glyph(name: library.favorites.contains(recipe.id) ? "glyph-favorite-fill" : "glyph-favorite", size: 20)
                    .foregroundStyle(library.favorites.contains(recipe.id) ? Theme.tomato : Theme.aubergine)
            }
            .accessibilityLabel(library.favorites.contains(recipe.id) ? Text("Remove favorite") : Text("Favorite recipe"))
            .sensoryFeedback(.selection, trigger: library.favorites.contains(recipe.id))
            if recipe.isUserRecipe {
                Button(String(localized: "Edit")) { isEditShown = true }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.card)
                    .foregroundStyle(Theme.aubergine)
            }
            Menu {
                if plannedMeal != nil {
                    Button("Swap this meal", systemImage: "arrow.triangle.2.circlepath") { isSwapShown = true }
                }
                if !library.collections.isEmpty {
                    Menu("Cookbooks", systemImage: "book.closed") {
                        ForEach(library.collections, id: \.id) { collection in
                            Button(collection.title, systemImage: collection.recipeIDs.contains(recipe.id) ? "checkmark" : "plus") {
                                library.toggleRecipe(recipe.id, in: collection)
                            }
                        }
                    }
                }
                if personalPhoto != nil {
                    Button(role: .destructive) { updatePhoto(nil) } label: {
                        Label("Remove my photo", systemImage: "trash")
                    }
                }
                ShareLink(item: shareText) { Label("Share recipe", systemImage: "square.and.arrow.up") }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(Theme.aubergine)
            }
            .accessibilityLabel(Text("More recipe actions"))
        }
    }

    /// Full-bleed photo. Pulling down stretches it (it stays pinned to the top); scrolling up moves it at
    /// 65% of the page speed (parallax) while the cream sheet slides over it. On open it eases from 106%.
    private var hero: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("detailScroll")).minY
            let stretch = max(0, minY)
            let parallax = reduceMotion ? 0 : -min(0, minY) * 0.35
            heroImage(width: proxy.size.width, height: heroHeight + stretch)
                .overlay(alignment: .top) {
                    // A soft scrim so the status bar and the glass buttons always read.
                    LinearGradient(colors: [Color.black.opacity(0.28), .clear], startPoint: .top, endPoint: .bottom)
                        .frame(height: 140)
                        .allowsHitTesting(false)
                }
                .clipped()
                .offset(y: -stretch + parallax)
        }
        .frame(height: heroHeight)
        .overlay(alignment: .bottom) { photoControls }
    }

    @ViewBuilder
    private func heroImage(width: CGFloat, height: CGFloat) -> some View {
        if let personalPhoto {
            Image(uiImage: personalPhoto)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .accessibilityLabel(Text("Your recipe photo"))
        } else if let name = DishTileView(recipe: recipe).photoName {
            // Every recipe photo fills the top edge to edge, scaled with the best filter.
            Image(name)
                .resizable()
                .interpolation(.high)
                .antialiased(true)
                .scaledToFill()
                .frame(width: width, height: height)
                .accessibilityHidden(true)
        } else {
            DishTileView(recipe: recipe, size: width, height: height, cornerRadius: 0)
        }
    }

    private var isIllustrative: Bool {
        personalPhoto == nil && DishTileView(recipe: recipe).photoName?.hasPrefix("illustrative-recipe-") == true
    }

    /// The camera, as a frosted button on the photo just above the sheet. Nothing else sits on the photo.
    private var photoControls: some View {
        HStack {
            Spacer()
            PhotosPicker(selection: $photoItem, matching: .images) {
                Group {
                    if loadingPhoto {
                        ProgressView()
                    } else {
                        Image(systemName: personalPhoto == nil ? "camera" : "camera.fill")
                            .font(.headline)
                            .foregroundStyle(Theme.aubergine)
                    }
                }
                .frame(width: Theme.Size.iconButton, height: Theme.Size.iconButton)
                .background(.ultraThinMaterial, in: Circle())
            }
            .buttonStyle(.plain)
            .disabled(loadingPhoto)
            .accessibilityLabel(Text("Choose a personal photo"))
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.bottom, sheetOverlap + Theme.Spacing.m)
    }

    /// The pinned call to action, with the running timer floating just above it.
    private var bottomBar: some View {
        VStack(spacing: Theme.Spacing.s) {
            if timer.isActive {
                TimerPill(timer: timer)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            PrimaryButton(String(localized: "Start cooking"), systemImage: "glyph-cook") { isCookModeShown = true }
                .disabled(recipe.steps.isEmpty)
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.vertical, Theme.Spacing.s)
        .background(Theme.cream.opacity(0.97).ignoresSafeArea())
    }

    private var shareText: String {
        RecipeShareText.make(recipe: recipe, servings: servings, catalog: repository.catalog, system: unitSystem)
    }

    /// Four equal actions in one row: a tomato icon on a soft disc, a label underneath.
    private var actionBar: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.s) {
            Button { library.toggleSaved(recipe.id) } label: {
                actionLabel(library.isSaved(recipe.id) ? "Saved" : "Save", glyph: "glyph-save")
            }
            .sensoryFeedback(.selection, trigger: library.isSaved(recipe.id))
            Button { isAddToPlanShown = true } label: { actionLabel("Meal Plan", glyph: "glyph-add-to-plan") }
            Button { showsListPicker = true } label: { actionLabel("Groceries", glyph: "glyph-add-to-groceries") }
            ShareLink(item: shareText) { actionLabel("Share", glyph: "glyph-share") }
        }
        .buttonStyle(.plain)
    }

    private func actionLabel(_ title: LocalizedStringKey, glyph: String) -> some View {
        VStack(spacing: Theme.Spacing.s) {
            Glyph(name: glyph, size: 24)
                .foregroundStyle(Theme.tomatoDeep)
                .frame(width: 52, height: 52)
                .background(Circle().fill(Theme.tomatoSoft))
                .accessibilityHidden(true)
            Text(title)
                .font(Theme.Typography.caption.weight(.semibold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    /// After cooking: the recipe's own note (if any), "Mark as cooked" and a star rating.
    private var cookedCard: some View {
        let cooked = plannedMeal?.isCooked ?? library.cookedIds.contains(recipe.id)
        return VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            Text("Cooked it?")
                .font(Theme.Typography.title3)
                .foregroundStyle(Theme.aubergine)
                .accessibilityAddTraits(.isHeader)
            if let note = recipe.notes, !note.isEmpty {
                Text(note)
                    .font(Theme.Typography.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Button { markCooked(stars: 0) } label: {
                Label(cooked ? "Cooked" : "Mark as cooked", systemImage: cooked ? "checkmark.circle.fill" : "checkmark.circle")
            }
            .buttonStyle(SecondaryButtonStyle(outlined: true))
            .disabled(cooked)
            HStack {
                Text("Your rating")
                    .font(Theme.Typography.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                Spacer()
                StarPicker(stars: Binding(
                    get: { library.stars[recipe.id] ?? 0 },
                    set: { library.setStars($0, for: recipe.id) }
                ))
            }
        }
        .cardStyle()
    }

    private func addToGroceries(_ id: String?) {
        planStore.addRecipeToExtras(recipe, servings: servings, to: id)
        addedLists.insert(id ?? "")
        Haptics.success()
    }

    private func selectPhoto(_ item: PhotosPickerItem) async {
        loadingPhoto = true
        defer { loadingPhoto = false }
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let source = CGImageSourceCreateWithData(data as CFData, nil),
                  let thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                      kCGImageSourceCreateThumbnailFromImageAlways: true,
                      kCGImageSourceCreateThumbnailWithTransform: true,
                      kCGImageSourceThumbnailMaxPixelSize: 1200
                  ] as CFDictionary),
                  let photo = UIImage(cgImage: thumbnail).jpegData(compressionQuality: 0.82) else {
                if !Task.isCancelled { photoError = true }
                return
            }
            guard !Task.isCancelled else { return }
            updatePhoto(photo)
        } catch {
            if !Task.isCancelled { photoError = true }
        }
    }

    private func updatePhoto(_ data: Data?) {
        do {
            try library.savePhoto(data, for: recipe.id)
            personalPhoto = data.flatMap { UIImage(data: $0) }
            if data == nil { photoItem = nil }
        } catch {
            photoError = true
        }
    }

    private func markCooked(stars: Int) {
        if stars > 0 {
            library.setStars(stars, for: recipe.id)
        }
        library.recordCooked(recipe.id)
        planStore.markCooked(recipeId: recipe.id, meal: plannedMeal)
        Haptics.success()
        askForReviewAfterFirstCook(stars: stars)
    }

    /// Ask for an App Store rating once, after the first meal they've cooked, and never right
    /// after a low rating. The pause lets cook mode close first so the prompt isn't swallowed.
    private func askForReviewAfterFirstCook(stars: Int) {
        guard !didAskForReview, stars == 0 || stars >= 4 else { return }
        didAskForReview = true
        Task {
            try? await Task.sleep(for: .milliseconds(1_200))
            requestReview()
        }
    }
}

/// Eyebrow (cuisine · meal), the title, then calm tags (diet and free-froms neutral, vibes in soft tomato).
private struct DetailHeader: View {
    let recipe: Recipe
    let profile: RecipeProfile

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text("\(recipe.cuisine.rawValue) · \(recipe.mealType.title)")
                .font(Theme.Typography.eyebrow)
                .textCase(.uppercase)
                .foregroundStyle(Theme.tomatoDeep)
            Text(recipe.title)
                .font(Theme.Typography.title)
                .foregroundStyle(Theme.aubergine)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            FlowLayout(spacing: Theme.Spacing.inline) {
                if profile.diet != .omnivore {
                    TagLabel(text: profile.diet.displayName)
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
            .padding(.top, Theme.Spacing.xxs)
        }
    }
}

/// Time, calories and cost in one card: three equal columns split by hairlines.
private struct FactsStrip: View {
    let recipe: Recipe
    let kcal: Double
    let costText: String

    var body: some View {
        HStack(spacing: 0) {
            fact(icon: "glyph-time", value: String(localized: "\(recipe.totalMinutes) min"),
                 label: String(localized: "\(recipe.prepMinutes) prep · \(recipe.cookMinutes) cook"))
            Rectangle().fill(Theme.line).frame(width: 1, height: 40)
            fact(icon: "glyph-calories", value: String(localized: "\(Int(kcal.rounded())) kcal"), label: String(localized: "per serving"))
            Rectangle().fill(Theme.line).frame(width: 1, height: 40)
            fact(icon: "glyph-cost", value: costText, label: String(localized: "per serving"))
        }
        .padding(.vertical, Theme.Spacing.m)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
        .elevation(Theme.Elevation.card)
    }

    private func fact(icon: String, value: String, label: String) -> some View {
        VStack(spacing: Theme.Spacing.xxs) {
            Glyph(name: icon, size: 16)
                .foregroundStyle(Theme.tomatoDeep)
            Text(value)
                .font(Theme.Typography.headline)
                .monospacedDigit()
                .foregroundStyle(Theme.aubergine)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(label)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.aubergineMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

/// A capsule segmented control: a white pill slides to the selected option (shared across the page's
/// controls through `matchedGeometryEffect`, each with its own id).
private struct CapsuleSegments<Option: Hashable>: View {
    let options: [Option]
    @Binding var selection: Option
    let title: (Option) -> String
    let namespace: Namespace.ID
    let id: String
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                let selected = option == selection
                Button {
                    withAnimation(Theme.motion(reduceMotion)) { selection = option }
                } label: {
                    Text(title(option))
                        .font(Theme.Typography.subheadline.weight(selected ? .bold : .semibold))
                        .foregroundStyle(selected ? Theme.aubergine : Theme.aubergineMuted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background {
                            if selected {
                                Capsule()
                                    .fill(Theme.card)
                                    .elevation(Theme.Elevation.subtle)
                                    .matchedGeometryEffect(id: id, in: namespace)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
        .padding(Theme.Spacing.xs)
        .background(Capsule().fill(Theme.creamDeep))
        .sensoryFeedback(.selection, trigger: selection)
    }
}

private struct IngredientsSection: View {
    let recipe: Recipe
    @Binding var servings: Double
    let maxServings: Double
    let system: UnitSystem
    let onChangeUnits: (UnitSystem) -> Void
    let addedToList: Bool
    let onAddToList: () -> Void

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    var body: some View {
        let lines: [IngredientLine] = IngredientLine.lines(for: recipe, servings: servings, catalog: repository.catalog, system: system)
        let main: [IngredientLine] = lines.filter { !$0.isPantryStaple }
        let staples: [IngredientLine] = lines.filter { $0.isPantryStaple }
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            HStack {
                Text("Servings")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                Spacer()
                HStack(spacing: Theme.Spacing.s) {
                    portionButton("minus", label: "Fewer servings", delta: -0.5, disabled: servings <= 1)
                    Text(servings == 1 ? String(localized: "1 person") : String(localized: "\(FractionFormatter.string(servings)) portions"))
                        .monospacedDigit()
                        .foregroundStyle(Theme.aubergine)
                        .fixedSize(horizontal: true, vertical: false)
                    portionButton("plus", label: "More servings", delta: 0.5, disabled: servings >= maxServings)
                }
                .sensoryFeedback(.selection, trigger: servings)
            }
            .cardStyle(padding: Theme.Spacing.m)
            Menu {
                Button {
                    onChangeUnits(.metric)
                } label: {
                    Label("Metric", systemImage: system == .metric ? "checkmark" : "scalemass")
                }
                Button {
                    onChangeUnits(.imperial)
                } label: {
                    Label("Imperial", systemImage: system == .imperial ? "checkmark" : "scalemass")
                }
            } label: {
                Label("Convert", systemImage: "arrow.left.arrow.right")
                    .accessibilityValue(system == .metric ? Text("Metric") : Text("Imperial"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.tomatoDeep)
                    .frame(minHeight: 44)
            }
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
            Button(action: onAddToList) {
                Label(addedToList ? String(localized: "Add to another list") : String(localized: "Add to groceries"), systemImage: "cart.badge.plus")
            }
            .buttonStyle(SecondaryButtonStyle(outlined: true))
        }
    }

    private func portionButton(_ icon: String, label: LocalizedStringKey, delta: Double, disabled: Bool) -> some View {
        Button {
            servings = min(max(servings + delta, 1), maxServings)
        } label: {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .frame(width: 44, height: 44)
                .foregroundStyle(Theme.tomatoDeep)
                .background(Theme.tomatoSoft, in: Circle())
                .opacity(disabled ? 0.45 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(label))
        .disabled(disabled)
    }

}

private struct IngredientRow: View {
    let line: IngredientLine

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            IngredientThumbnail(ingredientID: line.ingredientID, size: 44, showsBackground: false)
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
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
        .frame(minHeight: 46)
        .padding(.vertical, Theme.Spacing.s)
        .accessibilityElement(children: .combine)
    }
}

private struct MethodSection: View {
    let recipe: Recipe
    let servings: Double
    let system: UnitSystem
    let timer: CountdownTimer

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            if recipe.steps.isEmpty {
                Text("no steps yet").foregroundStyle(Theme.aubergineMuted)
            }
            if !recipe.steps.isEmpty {
                HStack {
                    Text("Method").font(.caption.weight(.bold)).textCase(.uppercase)
                    Spacer()
                    Text(recipe.steps.count == 1 ? String(localized: "1 step") : String(localized: "\(recipe.steps.count) steps"))
                        .font(.caption)
                }
                .foregroundStyle(Theme.aubergineMuted)
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        StepRow(number: index + 1, text: StepTextFormatter.string(step, system: system), recipe: recipe, servings: servings, system: system, timer: timer)
                    }
                }
                .background(alignment: .topLeading) {
                    Rectangle().fill(Theme.line).frame(width: 1)
                        .padding(.leading, 14)
                        .padding(.bottom, 24)
                        .accessibilityHidden(true)
                }
            }
        }
    }
}

private struct StepRow: View {
    let number: Int
    let text: String
    let recipe: Recipe
    let servings: Double
    let system: UnitSystem
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
                StepChips(text: text, recipe: recipe, servings: servings, system: system, timer: timer)
            }
        }
    }
}

/// Ingredient chips and tappable timer chips for one step.
struct StepChips: View {
    let text: String
    let recipe: Recipe
    let servings: Double
    let system: UnitSystem
    let timer: CountdownTimer

    @Environment(RecipeRepository.self) private var repository: RecipeRepository

    var body: some View {
        let used = StepIngredientMatcher.ingredients(in: text, recipe: recipe, catalog: repository.catalog)
        let timers = TimerDetector.timers(in: text)
        if !used.isEmpty || !timers.isEmpty {
            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                if !used.isEmpty {
                    Text("Amounts for the full recipe")
                        .font(.caption)
                        .foregroundStyle(Theme.aubergineMuted)
                    FlowLayout(spacing: Theme.Spacing.inline) {
                        ForEach(Array(used.enumerated()), id: \.offset) { _, item in
                            ingredientChip(item)
                        }
                    }
                }
                if !timers.isEmpty {
                    FlowLayout(spacing: Theme.Spacing.inline) {
                        ForEach(Array(timers.enumerated()), id: \.offset) { _, stepTimer in
                            let duration = TimerDetector.clock(stepTimer.seconds)
                            let label = stepTimer.usesUpperBound ? String(localized: "\(duration) timer (upper end)") : stepTimer.label
                            Button {
                                timer.start(label: label, seconds: stepTimer.seconds)
                            } label: {
                                Label { Text(label) } icon: { Glyph(name: "glyph-step-timer", size: 14) }
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.aubergine)
                                    .padding(.horizontal, 10)
                                    .frame(minHeight: 44)
                                    .background(Capsule().fill(Theme.saffronSoft))
                                    .overlay(Capsule().stroke(Theme.saffron, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(Text("Start timer: \(label)"))
                        }
                    }
                }
            }
        }
    }

    private func ingredientChip(_ item: RecipeIngredient) -> some View {
        let ingredient = item.ingredientId.flatMap { repository.catalog.ingredient(id: $0) }
        let amount = item.amount * servings / Double(max(1, recipe.baseServings))
        let quantity = QuantityFormatter.string(amount: amount, unit: item.unit, system: system, ingredient: ingredient)
        let name = ingredient?.displayName(for: system) ?? item.name ?? String(localized: "Ingredient")
        return HStack(spacing: Theme.Spacing.xs) {
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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
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
                    .contentTransition(reduceMotion ? .identity : .numericText(countsDown: true))
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
        .animation(reduceMotion ? nil : Theme.Motion.update, value: timer.remaining)
    }
}

private struct RecipeVote: View {
    let recipeID: String
    @Environment(LibraryStore.self) private var library

    var body: some View {
        let rating = library.rating(for: recipeID)
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text("Was this recipe good?")
                .font(.headline)
                .foregroundStyle(Theme.aubergine)
            HStack(spacing: Theme.Spacing.s) {
                PillToggle(title: String(localized: "Yes"), systemImage: "hand.thumbsup", isOn: rating == .like) {
                    library.setRating(.like, for: recipeID)
                }
                PillToggle(title: String(localized: "Not for me"), systemImage: "hand.thumbsdown", isOn: rating == .notForMe) {
                    library.setRating(.notForMe, for: recipeID)
                }
            }
        }
        .cardStyle()
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
