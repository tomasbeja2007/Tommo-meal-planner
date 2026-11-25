import SwiftUI
import ForkcastCore

// Thin wrappers that put each reusable preference editor inside the quiz scaffold.

struct GoalsStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what would you like Forkcast to help with?"),
            subtitle: String(localized: "pick as many as you like"),
            isButtonEnabled: !state.goals.isEmpty,
            onContinue: onContinue
        ) {
            GoalsPicker(selection: $state.goals)
        }
    }
}

struct TimeStepView: View {
    @Bindable var state: OnboardingState
    let onPick: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "how long do you want to spend cooking on a weeknight?"),
            subtitle: String(localized: "we'll keep most dinners inside this"),
            onContinue: onPick
        ) {
            CookTimePicker(maxMinutes: $state.maxCookMinutes, onPick: onPick)
        }
    }
}

struct CountryStepView: View {
    @Bindable var state: OnboardingState
    let onPick: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "where do you shop?"),
            subtitle: String(localized: "for prices, currency and units"),
            onContinue: onPick
        ) {
            CountryPicker(selection: countryBinding, onPick: onPick)
        }
    }

    private var countryBinding: Binding<String> {
        Binding<String>(
            get: { state.countryId },
            set: { newValue in
                guard newValue != state.countryId else { return }
                state.countryId = newValue
                // A store from another country no longer applies.
                let stores: [Store] = FoodCatalog.bundled.stores(forCountry: newValue)
                if !stores.contains(where: { $0.id == state.storeId }) {
                    state.storeId = ""
                }
                state.refreshSuggestedBudget(catalog: FoodCatalog.bundled)
            }
        )
    }
}

struct StoreStepView: View {
    @Bindable var state: OnboardingState
    let onPick: () -> Void
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "which shop do you use most?"),
            subtitle: String(localized: "we'll price your week for this shop"),
            isButtonEnabled: !state.storeId.isEmpty,
            onContinue: onContinue
        ) {
            StorePicker(countryId: state.countryId, selection: $state.storeId, onPick: onPick)
        }
    }
}

struct HouseholdStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "who's eating?"),
            subtitle: String(localized: "so every recipe makes the right amount"),
            onContinue: onContinue
        ) {
            HouseholdEditor(adults: $state.adults, kids: $state.kids)
        }
    }
}

struct CookingDaysStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "which nights are you cooking?"),
            subtitle: String(localized: "leave off the nights you eat out or have leftovers"),
            isButtonEnabled: !state.cookingDays.isEmpty,
            onContinue: onContinue
        ) {
            CookingDaysEditor(days: $state.cookingDays)
        }
    }
}

struct BudgetStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what's your weekly budget?"),
            subtitle: String(localized: "for dinners only. We'll show the total before you shop."),
            onContinue: onContinue
        ) {
            BudgetEditor(
                budget: $state.budget,
                country: state.country(in: FoodCatalog.bundled),
                portions: state.portions,
                days: state.cookingDays.count,
                onUserChange: { state.budgetTouched = true }
            )
        }
    }
}

struct VibesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what's the vibe?"),
            subtitle: String(localized: "pick up to 3, we'll lean that way"),
            isButtonEnabled: !state.vibes.isEmpty,
            onContinue: onContinue
        ) {
            VibePicker(selection: $state.vibes)
        }
    }
}

struct DietStepView: View {
    @Bindable var state: OnboardingState
    let onPick: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "do you follow a diet?"),
            onContinue: onPick
        ) {
            DietPicker(selection: $state.diet, onPick: onPick)
        }
    }
}

struct AllergiesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "any allergies?"),
            subtitle: String(localized: "we'll never include these, and that includes hidden sources."),
            isButtonEnabled: state.noAllergies || !state.allergens.isEmpty,
            onContinue: onContinue
        ) {
            AllergyPicker(selection: $state.allergens, noAllergies: $state.noAllergies)
        }
    }
}

struct DislikesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "anything you won't eat?"),
            subtitle: String(localized: "we'll keep it off your plate"),
            buttonTitle: state.dislikes.isEmpty ? String(localized: "I eat everything") : String(localized: "Continue"),
            onContinue: onContinue
        ) {
            DislikesPicker(selection: $state.dislikes, unitSystem: state.country(in: FoodCatalog.bundled).unitSystem)
        }
    }
}

struct AppliancesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what's in your kitchen?"),
            subtitle: String(localized: "we'll only pick recipes you can make"),
            isButtonEnabled: !state.appliances.isEmpty,
            onContinue: onContinue
        ) {
            AppliancePicker(selection: $state.appliances)
        }
    }
}

struct NutritionTargetStep: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(title: String(localized: "Do you have a calorie target?"), onContinue: onContinue) {
            NutritionTargetEditor(target: $state.nutritionTarget)
        }
    }
}

struct NutritionTargetEditor: View {
    @Binding var target: NutritionTarget?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var lastTarget = NutritionTarget()

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            OptionTile(
                title: String(localized: "No, keep it simple"),
                subtitle: String(localized: "Plan meals without a daily target."),
                systemImage: "fork.knife",
                isSelected: target == nil
            ) {
                if let target { lastTarget = target }
                self.target = nil
            }

            OptionTile(
                title: String(localized: "Yes, set a target"),
                subtitle: String(localized: "Choose daily calories and a macro split."),
                systemImage: "target",
                isSelected: target != nil
            ) {
                if target == nil { target = lastTarget }
            }

            if let current = target {
                NutritionTargetControls(target: Binding(
                    get: { target ?? current },
                    set: { target = $0 }
                ))
                .transition(.opacity)
                Text("The 2,000 kcal starting value is a reference. Your needs may differ.")
                    .font(.footnote)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .animation(Theme.motion(reduceMotion), value: target != nil)
    }
}

private struct NutritionTargetControls: View {
    @Binding var target: NutritionTarget
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    Text("Daily calories").font(.headline)
                    Spacer(minLength: Theme.Spacing.s)
                    calorieStepper
                }
                VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                    Text("Daily calories").font(.headline)
                    calorieStepper
                }
            }

            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                Text("Macro split")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.aubergineMuted)
                    .accessibilityAddTraits(.isHeader)
                FlowLayout(spacing: Theme.Spacing.s) {
                    ForEach(NutritionTarget.Preset.allCases) { preset in
                        presetButton(preset)
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: target.preset)

            if target.preset == .custom {
                VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                    Stepper(value: $target.customProteinPercent, in: 0...(100 - target.percentages.carbs)) {
                        Text("Protein: \(target.percentages.protein)%")
                    }
                    Stepper(value: $target.customCarbPercent, in: 0...(100 - target.percentages.protein)) {
                        Text("Carbs: \(target.percentages.carbs)%")
                    }
                    Text("Fat: \(target.percentages.fat)% · remaining share")
                        .foregroundStyle(Theme.aubergineMuted)
                }
                .font(.subheadline)
            }

            macroSummary

            Label("You can change your target anytime in Profile.", systemImage: "info.circle")
                .font(.footnote)
                .foregroundStyle(Theme.aubergineMuted)
        }
        .foregroundStyle(Theme.aubergine)
        .cardStyle()
    }

    private var calorieStepper: some View {
        RoundStepper(value: $target.calories, range: NutritionTarget.calorieRange, suffix: " kcal", step: NutritionTarget.calorieStep)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Daily calorie target"))
            .accessibilityValue(Text("\(target.calories.formatted()) kilocalories"))
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    target.calories = min(NutritionTarget.calorieRange.upperBound, target.calories + NutritionTarget.calorieStep)
                case .decrement:
                    target.calories = max(NutritionTarget.calorieRange.lowerBound, target.calories - NutritionTarget.calorieStep)
                @unknown default: break
                }
            }
    }

    private func presetButton(_ preset: NutritionTarget.Preset) -> some View {
        let isSelected = target.preset == preset
        return Button {
            target.preset = preset
        } label: {
            Label(preset.title, systemImage: isSelected ? "checkmark" : "chart.bar.xaxis")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, Theme.Spacing.m)
                .frame(minHeight: 44)
                .foregroundStyle(isSelected ? Theme.tomatoDeep : Theme.aubergine)
                .background(isSelected ? Theme.tomatoSoft : Theme.cream, in: Capsule())
                .overlay(Capsule().strokeBorder(isSelected ? Theme.tomato : Theme.line, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var macroSummary: some View {
        let split = target.percentages
        let grams = target.grams
        return VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Theme.macroProtein.frame(width: geometry.size.width * CGFloat(split.protein) / 100)
                    Theme.macroCarbs.frame(width: geometry.size.width * CGFloat(split.carbs) / 100)
                    Theme.macroFat.frame(width: geometry.size.width * CGFloat(split.fat) / 100)
                }
                .clipShape(Capsule())
            }
            .frame(height: 8)
            .animation(reduceMotion ? nil : Theme.Motion.update, value: target)
            .accessibilityHidden(true)
            FlowLayout(spacing: Theme.Spacing.m) {
                macroAmount(String(localized: "Protein"), grams: grams.protein, tint: Theme.macroProtein)
                macroAmount(String(localized: "Carbs"), grams: grams.carbs, tint: Theme.macroCarbs)
                macroAmount(String(localized: "Fat"), grams: grams.fat, tint: Theme.macroFat)
            }
        }
    }

    private func macroAmount(_ name: String, grams: Int, tint: Color) -> some View {
        HStack(spacing: 4) {
            Circle().fill(tint).frame(width: 7, height: 7).accessibilityHidden(true)
            Text("\(grams) g").fontWeight(.bold).monospacedDigit()
            Text(name).foregroundStyle(Theme.aubergineMuted)
        }
        .font(.caption)
        .accessibilityElement(children: .combine)
    }
}

private extension NutritionTarget.Preset {
    var title: String {
        switch self {
        case .balanced: return String(localized: "Balanced")
        case .highProtein: return String(localized: "High protein")
        case .lowCarb: return String(localized: "Low carb")
        case .custom: return String(localized: "Custom")
        }
    }
}

#Preview("Calorie target") {
    NutritionTargetStep(state: OnboardingState()) {}
        .creamBackground()
}
