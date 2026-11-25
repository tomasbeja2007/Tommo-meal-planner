import SwiftUI
import ForkcastCore

/// Pick a day of this week to add the recipe to.
struct AddToPlanSheet: View {
    let recipe: Recipe
    let servings: Double

    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    private var days: [Date] {
        let planned: [Date] = planStore.weekDays
        return planned.isEmpty ? WeekMath.days(from: Date()) : planned
    }

    var body: some View {
        NavigationStack {
            List(days, id: \.self) { day in
                let existing: PlannedMeal? = planStore.meal(on: day, type: recipe.mealType)
                Button {
                    if let existing {
                        planStore.swap(existing, to: recipe.id, servings: servings)
                    } else {
                        planStore.addMeal(recipeId: recipe.id, on: day, servings: servings)
                    }
                    Haptics.success()
                    dismiss()
                } label: {
                    HStack {
                        Text(DateText.dayLabel(day))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Theme.aubergine)
                        Spacer()
                        if let existing, let current = planStore.recipe(for: existing) {
                            Text(String(localized: "replaces \(current.title)"))
                                .font(.caption)
                                .foregroundStyle(Theme.aubergineMuted)
                                .lineLimit(1)
                        } else {
                            Text("free").font(.caption).foregroundStyle(Theme.herb)
                        }
                    }
                    .frame(minHeight: 44)
                }
                .listRowBackground(Theme.card)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(recipe.mealType == .dinner ? String(localized: "add to which day?") : String(localized: "add as \(recipe.mealType.noun) on which day?"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
            }
        }
    }
}

struct StarPicker: View {
    @Binding var stars: Int

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            ForEach(1...5, id: \.self) { value in
                Button {
                    stars = stars == value ? 0 : value
                } label: {
                    Image(systemName: value <= stars ? "star.fill" : "star")
                        .font(.system(size: 30))
                        .foregroundStyle(value <= stars ? Theme.saffron : Theme.aubergineFaint)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("\(value) stars"))
            }
        }
        .sensoryFeedback(.selection, trigger: stars)
        .accessibilityElement(children: .contain)
        .accessibilityValue(Text("\(stars) of 5"))
    }
}
