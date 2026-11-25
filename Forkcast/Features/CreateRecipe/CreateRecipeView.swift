import SwiftUI
import SwiftData
import ForkcastCore

/// Create / edit a user recipe. Linked ingredients give automatic macros and price.
struct CreateRecipeView: View {
    @Environment(\.modelContext) private var context: ModelContext
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    @State private var draft: RecipeDraft
    private let existing: UserRecipe?
    var onSaved: ((String) -> Void)? = nil

    @State private var showErrors: Bool = false
    @State private var isEmojiPickerShown: Bool = false
    @State private var isDeleteConfirmShown: Bool = false

    init(draft: RecipeDraft, onSaved: ((String) -> Void)? = nil) {
        _draft = State(initialValue: draft)
        self.existing = nil
        self.onSaved = onSaved
    }

    init(editing model: UserRecipe) {
        _draft = State(initialValue: RecipeDraft(model: model))
        self.existing = model
        self.onSaved = nil
    }

    var body: some View {
        NavigationStack {
            Form {
                BasicsSection(draft: $draft, showErrors: showErrors) { isEmojiPickerShown = true }
                TagsSection(tags: $draft.tags)
                IngredientsEditorSection(draft: $draft, showErrors: showErrors, unitSystem: profileStore.unitSystem)
                StepsEditorSection(steps: $draft.steps)
                NutritionSection(draft: $draft)
                Section {
                    TextField(String(localized: "Notes"), text: $draft.notes, axis: .vertical)
                        .lineLimit(2...6)
                    TextField(String(localized: "Source link (optional)"), text: $draft.sourceURL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text("Notes & source")
                }
                .listRowBackground(Theme.card)
                if existing != nil {
                    Section {
                        Button(String(localized: "Delete recipe"), role: .destructive) { isDeleteConfirmShown = true }
                    }
                    .listRowBackground(Theme.card)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream.ignoresSafeArea())
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(existing == nil ? String(localized: "New recipe") : String(localized: "Edit recipe"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(existing == nil ? String(localized: "Save to My recipes") : String(localized: "Save changes"), action: save)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .padding(.vertical, Theme.Spacing.s)
                    .background(Theme.cream.opacity(0.97).ignoresSafeArea())
            }
            .sheet(isPresented: $isEmojiPickerShown) {
                EmojiPickerGrid(selection: $draft.emoji)
                    .presentationDetents([.medium])
            }
            .confirmationDialog(String(localized: "Delete this recipe?"), isPresented: $isDeleteConfirmShown, titleVisibility: .visible) {
                Button(String(localized: "Delete"), role: .destructive) {
                    if let existing {
                        repository.delete(userRecipeId: existing.recipeId)
                        planStore.recompute()
                    }
                    dismiss()
                }
            }
        }
    }

    private func save() {
        guard draft.isValid else {
            withAnimation(Theme.spring) { showErrors = true }
            Haptics.warning()
            return
        }
        let model: UserRecipe = draft.save(in: context, existing: existing)
        repository.refresh()
        planStore.recompute()
        Haptics.success()
        onSaved?(model.recipeId)
        dismiss()
    }
}

private struct BasicsSection: View {
    @Binding var draft: RecipeDraft
    let showErrors: Bool
    let onEmoji: () -> Void

    var body: some View {
        Section {
            HStack(spacing: Theme.Spacing.m) {
                Button(action: onEmoji) {
                    Text(draft.emoji)
                        .font(.system(size: 34))
                        .frame(width: 60, height: 60)
                        .background(RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous).fill(Theme.creamDeep))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Choose an emoji"))
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    TextField(String(localized: "Recipe name"), text: $draft.title)
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                    if showErrors, let error = draft.titleError {
                        Text(error).font(.caption).foregroundStyle(Theme.tomatoDeep)
                    }
                }
            }
            Picker(selection: $draft.mealType) {
                ForEach(MealType.allCases) { type in
                    Text(type.title).tag(type)
                }
            } label: {
                Label(String(localized: "Meal"), systemImage: "fork.knife")
            }
            HStack {
                Label(String(localized: "Servings"), systemImage: "person.2")
                Spacer()
                RoundStepper(value: $draft.servings, range: 1...12)
            }
            HStack {
                Label(String(localized: "Total time"), systemImage: "clock")
                Spacer()
                Stepper(value: $draft.totalMinutes, in: 5...480, step: 5) {
                    Text("\(draft.totalMinutes) min")
                        .monospacedDigit()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .fixedSize()
            }
        }
        .listRowBackground(Theme.card)
    }
}

private struct TagsSection: View {
    @Binding var tags: Set<String>

    private var allTags: [String] { Vibe.allCases.map { $0.rawValue } + RecipeDraft.extraTags }

    var body: some View {
        Section {
            FlowLayout(spacing: Theme.Spacing.s) {
                ForEach(allTags, id: \.self) { tag in
                    Chip(title: RecipeDraft.tagTitle(tag), isSelected: tags.contains(tag)) {
                        if tags.contains(tag) { tags.remove(tag) } else { tags.insert(tag) }
                    }
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("Tags")
        }
        .listRowBackground(Theme.card)
    }
}

private struct IngredientsEditorSection: View {
    @Binding var draft: RecipeDraft
    let showErrors: Bool
    let unitSystem: UnitSystem

    var body: some View {
        Section {
            ForEach($draft.ingredients) { $item in
                IngredientEditorRow(item: $item, unitSystem: unitSystem)
            }
            .onDelete { offsets in
                draft.ingredients.remove(atOffsets: offsets)
                if draft.ingredients.isEmpty { draft.ingredients = [RecipeDraft.DraftIngredient()] }
            }
            Button {
                draft.ingredients.append(RecipeDraft.DraftIngredient())
            } label: {
                Label(String(localized: "Add ingredient"), systemImage: "plus.circle.fill")
                    .foregroundStyle(Theme.tomato)
            }
            if showErrors, let error = draft.ingredientsError {
                Text(error).font(.caption).foregroundStyle(Theme.tomatoDeep)
            }
        } header: {
            Text("Ingredients")
        } footer: {
            Text("Pick a suggestion to link an ingredient. Linked ingredients get automatic nutrition and prices. Swipe left to delete.")
        }
        .listRowBackground(Theme.card)
    }
}

private struct IngredientEditorRow: View {
    @Binding var item: RecipeDraft.DraftIngredient
    let unitSystem: UnitSystem
    @FocusState private var nameFocused: Bool

    private var suggestions: [Ingredient] {
        guard nameFocused, item.ingredientId == nil else { return [] }
        return IngredientMatcher.suggestions(for: item.name, in: FoodCatalog.bundled, limit: 4)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.inline) {
            HStack(spacing: Theme.Spacing.s) {
                TextField(String(localized: "1"), text: $item.amountText)
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.center)
                    .frame(width: 52)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: Theme.Radius.small, style: .continuous).fill(Theme.creamDeep))
                    .accessibilityLabel(Text("Amount"))
                Menu {
                    ForEach(MeasureUnit.allCases, id: \.self) { unit in
                        Button(unitTitle(unit)) { item.unit = unit }
                    }
                } label: {
                    Text(unitTitle(item.unit))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                        .frame(minWidth: 56)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 6)
                        .background(RoundedRectangle(cornerRadius: Theme.Radius.small, style: .continuous).fill(Theme.creamDeep))
                }
                .accessibilityLabel(Text("Unit"))
                TextField(String(localized: "Ingredient"), text: nameBinding)
                    .focused($nameFocused)
                    .textInputAutocapitalization(.never)
                if item.ingredientId != nil {
                    Image(systemName: "link")
                        .font(.caption)
                        .foregroundStyle(Theme.herb)
                        .accessibilityLabel(Text("Linked to nutrition data"))
                }
            }
            if item.ingredientId == nil && !item.isEmpty && !nameFocused {
                Text("no nutrition data")
                    .font(.caption2)
                    .foregroundStyle(Theme.aubergineFaint)
            }
            if !suggestions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.inline) {
                        ForEach(suggestions) { ingredient in
                            Button {
                                item.name = ingredient.displayName(for: unitSystem)
                                item.ingredientId = ingredient.id
                                nameFocused = false
                            } label: {
                                HStack(spacing: Theme.Spacing.s) {
                                    IngredientThumbnail(ingredientID: ingredient.id, size: 26)
                                    Text(ingredient.displayName(for: unitSystem))
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(Theme.aubergine)
                                }
                                .padding(.horizontal, Theme.Spacing.s)
                                .frame(minHeight: 44)
                                .background(Theme.creamDeep, in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    /// Editing the name unlinks the ingredient.
    private var nameBinding: Binding<String> {
        Binding<String>(
            get: { item.name },
            set: { newValue in
                if newValue != item.name { item.ingredientId = nil }
                item.name = newValue
            }
        )
    }

    private func unitTitle(_ unit: MeasureUnit) -> String {
        unit == .piece ? String(localized: "piece") : unit.rawValue
    }
}

private struct StepsEditorSection: View {
    @Binding var steps: [RecipeDraft.DraftStep]

    var body: some View {
        Section {
            ForEach(steps) { step in
                HStack(alignment: .top, spacing: Theme.Spacing.m) {
                    Text("\(number(for: step.id))")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.white)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(Theme.tomato))
                        .padding(.top, 2)
                    TextField(String(localized: "Describe this step…"), text: textBinding(for: step.id), axis: .vertical)
                        .lineLimit(1...6)
                }
            }
            .onDelete { offsets in
                steps.remove(atOffsets: offsets)
                if steps.isEmpty { steps = [RecipeDraft.DraftStep()] }
            }
            .onMove { from, to in steps.move(fromOffsets: from, toOffset: to) }
            Button {
                steps.append(RecipeDraft.DraftStep())
            } label: {
                Label(String(localized: "Add step"), systemImage: "plus.circle.fill")
                    .foregroundStyle(Theme.tomato)
            }
        } header: {
            Text("Method")
        } footer: {
            Text("Hold a step to reorder it. Swipe left to delete.")
        }
        .listRowBackground(Theme.card)
    }

    private func number(for id: UUID) -> Int {
        (steps.firstIndex { $0.id == id } ?? 0) + 1
    }

    private func textBinding(for id: UUID) -> Binding<String> {
        Binding<String>(
            get: { steps.first { $0.id == id }?.text ?? "" },
            set: { newValue in
                if let index = steps.firstIndex(where: { $0.id == id }) {
                    steps[index].text = newValue
                }
            }
        )
    }
}

private struct NutritionSection: View {
    @Binding var draft: RecipeDraft

    var body: some View {
        let computed: NutritionResult = NutritionCalculator.perServing(draft.previewRecipe(), catalog: FoodCatalog.bundled)
        Section {
            if draft.useManualMacros {
                MacroField(label: String(localized: "Calories (kcal)"), text: $draft.kcalText)
                MacroField(label: String(localized: "Protein (g)"), text: $draft.proteinText)
                MacroField(label: String(localized: "Carbs (g)"), text: $draft.carbsText)
                MacroField(label: String(localized: "Fat (g)"), text: $draft.fatText)
            } else {
                MacrosCard(
                    macros: computed.macros,
                    caption: String(localized: "estimated from ingredients"),
                    note: computed.hasIncompleteData ? String(localized: "unlinked ingredients aren't counted") : nil
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            Toggle(String(localized: "Edit manually"), isOn: $draft.useManualMacros.animation(Theme.spring))
                .tint(Theme.tomato)
                .listRowBackground(Theme.card)
        } header: {
            Text("Nutrition (per serving)")
        }
        .listRowBackground(Theme.card)
        .onChange(of: draft.useManualMacros) { _, manual in
            guard manual, draft.kcalText.isEmpty else { return }
            draft.kcalText = String(Int(computed.macros.kcal.rounded()))
            draft.proteinText = String(Int(computed.macros.protein.rounded()))
            draft.carbsText = String(Int(computed.macros.carbs.rounded()))
            draft.fatText = String(Int(computed.macros.fat.rounded()))
        }
    }
}

private struct MacroField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
                .frame(width: 90)
        }
    }
}

/// About 40 curated food emoji.
struct EmojiPickerGrid: View {
    @Binding var selection: String
    @Environment(\.dismiss) private var dismiss: DismissAction

    static let emojis: [String] = [
        "🍝", "🍜", "🍛", "🍲", "🥘", "🥗", "🌮", "🌯", "🥙", "🍕", "🍔", "🌭",
        "🍗", "🥩", "🍖", "🐟", "🍣", "🍤", "🍳", "🥚", "🧀", "🥞", "🍚", "🍙",
        "🥟", "🍱", "🥡", "🫕", "🥪", "🥧", "🍠", "🥦", "🍆", "🥕", "🌽", "🫑",
        "🍄", "🥑", "🍅", "🧆", "🫘", "🍋"
    ]

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: Theme.Spacing.s), count: 6)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Theme.Spacing.s) {
                ForEach(EmojiPickerGrid.emojis, id: \.self) { emoji in
                    Button {
                        selection = emoji
                        dismiss()
                    } label: {
                        Text(emoji)
                            .font(.system(size: 30))
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous).fill(selection == emoji ? Theme.tomatoSoft : Theme.card))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Theme.Spacing.gutter)
        }
        .background(Theme.cream.ignoresSafeArea())
    }
}

#Preview { CreateRecipeView(draft: RecipeDraft()).previewEnvironment() }
