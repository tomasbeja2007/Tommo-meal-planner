import SwiftUI
import ForkcastCore

/// "how was this week?" Like / not for me per dinner, then plan next week.
struct WeeklyFeedbackSheet: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(LibraryStore.self) private var library: LibraryStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    @State private var choices: [String: FeedbackRating] = [:]
    @State private var isSaving: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    HStack(spacing: Theme.Spacing.m) {
                        MascotView(size: 72, mood: .idle)
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("how was this week?")
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .foregroundStyle(Theme.aubergine)
                            Text("quick ratings make next week better")
                                .font(.subheadline)
                                .foregroundStyle(Theme.aubergineMuted)
                        }
                    }
                    VStack(spacing: Theme.Spacing.s) {
                        ForEach(planStore.meals) { meal in
                            if let recipe = planStore.recipe(for: meal) {
                                FeedbackRow(
                                    day: meal.date,
                                    recipe: recipe,
                                    choice: choices[recipe.id],
                                    onChoose: { rating in
                                        choices[recipe.id] = choices[recipe.id] == rating ? nil : rating
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(Theme.Spacing.gutter)
            }
            VStack(spacing: Theme.Spacing.xs) {
                PrimaryButton(String(localized: "Save & plan next week"), action: saveAndPlan)
                    .disabled(isSaving)
                Button(String(localized: "Skip")) {
                    planStore.markFeedbackGiven()
                    dismiss()
                }
                .buttonStyle(QuietButtonStyle())
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.bottom, Theme.Spacing.s)
        }
        .background(Theme.cream.ignoresSafeArea())
        .onAppear {
            for meal in planStore.meals {
                if let existing = library.rating(for: meal.recipeId) {
                    choices[meal.recipeId] = existing
                }
            }
        }
    }

    private func saveAndPlan() {
        isSaving = true
        for (recipeId, rating) in choices where library.rating(for: recipeId) != rating {
            library.setRating(rating, for: recipeId)
        }
        planStore.markFeedbackGiven()
        Task {
            await planStore.generateNextWeek()
            Haptics.success()
            isSaving = false
            dismiss()
        }
    }
}

private struct FeedbackRow: View {
    let day: Date
    let recipe: Recipe
    let choice: FeedbackRating?
    let onChoose: (FeedbackRating) -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Text(DateText.shortWeekday(day))
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 32)
                .background(RoundedRectangle(cornerRadius: Theme.Radius.small, style: .continuous).fill(Theme.tomato))
            Text(recipe.emoji)
            Text(recipe.title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(2)
            Spacer(minLength: Theme.Spacing.xs)
            RatingButton(systemImage: choice == .like ? "heart.fill" : "heart", isOn: choice == .like, onTint: Theme.tomato, label: String(localized: "Like")) {
                onChoose(.like)
            }
            RatingButton(systemImage: choice == .notForMe ? "hand.thumbsdown.fill" : "hand.thumbsdown", isOn: choice == .notForMe, onTint: Theme.aubergineMuted, label: String(localized: "Not for me")) {
                onChoose(.notForMe)
            }
        }
        .padding(Theme.Spacing.m)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(Theme.card))
    }
}

struct RatingButton: View {
    let systemImage: String
    let isOn: Bool
    let onTint: Color
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isOn ? Color.white : onTint)
                .frame(width: 44, height: 44)
                .background(Circle().fill(isOn ? onTint : Theme.creamDeep))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isOn)
        .accessibilityLabel(Text(label))
        .accessibilityAddTraits(isOn ? [.isSelected] : [])
    }
}

#Preview { WeeklyFeedbackSheet().previewEnvironment() }
