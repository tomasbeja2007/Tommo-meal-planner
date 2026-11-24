import SwiftUI
import ForkcastCore

/// Reorder meals between days, remove/add meals, set servings, one meal type at a time
/// (a segmented picker appears when more than dinners are planned). Saving only rewrites the
/// meal types that were opened here; everything else in the plan is left alone.
struct EditWeekSheet: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    private struct Row: Identifiable, Hashable {
        let id: UUID
        var meal: EditableMeal?
    }

    @State private var mealType: MealType = .dinner
    @State private var rowsByType: [MealType: [Row]] = [:]
    @State private var pickerIndex: Int? = nil

    private var rows: [Row] { rowsByType[mealType] ?? [] }

    var body: some View {
        NavigationStack {
            List {
                if planStore.plannedMealTypes.count > 1 {
                    Section {
                        Picker(String(localized: "Meal"), selection: $mealType) {
                            ForEach(planStore.plannedMealTypes) { type in
                                Text(type.title).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
                Section {
                    ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                        EditRowView(
                            day: day(at: index),
                            meal: row.meal,
                            onServingsChange: { newValue in rowsByType[mealType]?[index].meal?.servings = newValue },
                            onRemove: { withAnimation(Theme.spring) { rowsByType[mealType]?[index].meal = nil } },
                            onAdd: { pickerIndex = index }
                        )
                        .listRowBackground(Theme.card)
                        .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    }
                    .onMove { from, to in
                        rowsByType[mealType]?.move(fromOffsets: from, toOffset: to)
                    }
                } header: {
                    Label(String(localized: "hold a \(mealType.noun) to move it to another day"), systemImage: "line.3.horizontal")
                        .font(.caption)
                        .textCase(nil)
                        .foregroundStyle(Theme.aubergineMuted)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "Edit your week"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel(Text("Close without saving"))
                }
            }
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(String(localized: "Save changes")) {
                    for (type, typeRows) in rowsByType {
                        planStore.applyEdit(rows: typeRows.map { $0.meal }, for: type)
                    }
                    dismiss()
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.vertical, Theme.Spacing.s)
                .background(Theme.cream.opacity(0.97).ignoresSafeArea())
            }
            .sheet(isPresented: Binding<Bool>(get: { pickerIndex != nil }, set: { if !$0 { pickerIndex = nil } })) {
                RecipePickerSheet(title: String(localized: "add a \(mealType.noun)"), mealType: mealType) { recipeId in
                    if let index = pickerIndex, index < rows.count {
                        rowsByType[mealType]?[index].meal = EditableMeal(recipeId: recipeId, servings: planStore.profileStore.defaultServings)
                    }
                    pickerIndex = nil
                }
            }
        }
        .onAppear {
            mealType = planStore.plannedMealTypes.contains(.dinner) ? .dinner : (planStore.plannedMealTypes.first ?? .dinner)
            loadRows(for: mealType)
        }
        .onChange(of: mealType) { _, type in loadRows(for: type) }
    }

    /// Loads a meal type's rows the first time it's opened (later edits are kept while switching).
    private func loadRows(for type: MealType) {
        guard rowsByType[type] == nil else { return }
        rowsByType[type] = planStore.editRows(for: type).map { Row(id: UUID(), meal: $0) }
    }

    private func day(at index: Int) -> Date? {
        let days: [Date] = planStore.weekDays
        return index < days.count ? days[index] : nil
    }
}

private struct EditRowView: View {
    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    let day: Date?
    let meal: EditableMeal?
    let onServingsChange: (Double) -> Void
    let onRemove: () -> Void
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Text(day.map { DateText.shortWeekday($0) } ?? "")
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(Color.white)
                .frame(width: 48, height: 36)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(meal == nil ? Theme.aubergineFaint : Theme.tomato))
            if let meal, let recipe = repository.recipe(id: meal.recipeId) {
                DishTileView(recipe: recipe, size: 52)
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.title)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                        .lineLimit(2)
                    RoundStepper(value: servingsBinding(meal), range: 1...12, suffix: "")
                        .scaleEffect(0.85, anchor: .leading)
                        .accessibilityLabel(Text("Servings"))
                }
                Spacer(minLength: 0)
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.aubergineFaint)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel(Text("Remove \(recipe.title)"))
            } else {
                Button(action: onAdd) {
                    Label(String(localized: "add a meal"), systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.tomato)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
                .buttonStyle(.borderless)
            }
        }
    }

    private func servingsBinding(_ meal: EditableMeal) -> Binding<Int> {
        Binding<Int>(
            get: { Int(meal.servings.rounded()) },
            set: { onServingsChange(Double($0)) }
        )
    }
}

#Preview { EditWeekSheet().previewEnvironment() }
