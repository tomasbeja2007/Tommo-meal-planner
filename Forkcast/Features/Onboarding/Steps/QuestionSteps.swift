import SwiftUI
import ForkcastCore

// Thin wrappers that put each reusable preference editor inside the quiz scaffold.
// Bigger screens (mirror, your week, eating, pantry) have their own files.

/// "Continue · 4 selected" (just "Continue" when nothing is picked).
func continueTitle(selected count: Int) -> String {
    count == 0 ? String(localized: "Continue") : String(localized: "Continue · \(count) selected")
}

// MARK: 1. Goal

struct GoalsStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what would you like Tommo to help with?"),
            subtitle: String(localized: "pick as many as you like"),
            buttonTitle: continueTitle(selected: state.goals.count),
            isButtonEnabled: !state.goals.isEmpty,
            onContinue: onContinue
        ) {
            GoalsPicker(selection: $state.goals, layout: .grid)
        }
    }
}

// MARK: 2. What gets in the way?

struct ObstaclesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what gets in the way?"),
            subtitle: String(localized: "be honest, Chef Tommo has heard it all"),
            buttonTitle: continueTitle(selected: state.obstacles.count),
            isButtonEnabled: !state.obstacles.isEmpty,
            reaction: state.obstacles.isEmpty ? .idle : .thinking,
            onContinue: onContinue
        ) {
            VStack(spacing: Theme.Spacing.m) {
                ForEach(OnboardingObstacle.allCases) { obstacle in
                    OptionTile(title: obstacle.title, emoji: obstacle.emoji, isSelected: state.obstacles.contains(obstacle)) {
                        if state.obstacles.contains(obstacle) {
                            state.obstacles.remove(obstacle)
                        } else {
                            state.obstacles.insert(obstacle)
                        }
                    }
                }
            }
        }
    }
}

// MARK: 4. Who's eating?

struct HouseholdStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "who's eating?"),
            subtitle: String(localized: "so every recipe makes the right amount"),
            reaction: state.adults + state.kids > 2 ? .cheer : .idle,
            onContinue: onContinue
        ) {
            HouseholdEditor(adults: $state.adults, kids: $state.kids)
        }
    }
}

// MARK: 7. Dislikes

struct DislikesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "anything you won't eat?"),
            subtitle: String(localized: "we'll keep it off your plate"),
            buttonTitle: state.dislikes.isEmpty ? String(localized: "I eat everything") : continueTitle(selected: state.dislikes.count),
            onContinue: onContinue
        ) {
            DislikesPicker(selection: $state.dislikes, unitSystem: state.country(in: FoodCatalog.bundled).unitSystem)
        }
    }
}

// MARK: 8. Vibe

struct VibesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "What kind of vibe?"),
            subtitle: String(localized: "pick up to 3, we'll lean that way"),
            buttonTitle: continueTitle(selected: state.vibes.count),
            isButtonEnabled: !state.vibes.isEmpty,
            onContinue: onContinue
        ) {
            VibePicker(selection: $state.vibes)
        }
    }
}

// MARK: 9. Kitchen

struct AppliancesStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what's in your kitchen?"),
            subtitle: String(localized: "tap everything you've got"),
            buttonTitle: continueTitle(selected: state.appliances.count),
            isButtonEnabled: !state.appliances.isEmpty,
            onContinue: onContinue
        ) {
            VStack(spacing: Theme.Spacing.l) {
                AppliancePicker(selection: $state.appliances)
                Text("\(state.appliances.count) of \(Appliance.allCases.count) selected. We'll only suggest what you can make.")
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergineMuted)
                    .multilineTextAlignment(.center)
                    .contentTransition(.numericText())
                    .animation(Theme.spring, value: state.appliances.count)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: 10. Budget

struct BudgetStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    private var country: Country { state.country(in: FoodCatalog.bundled) }

    private var verdict: BudgetMath.Verdict {
        BudgetMath.verdict(budget: state.budget, portions: state.portions, days: state.dinnersPerWeek, region: country.regionPriceKey, multiplier: country.priceMultiplier, mealTypes: state.mealTypes)
    }

    /// Thinking when it's tight, cheering when there's plenty, idle in between.
    private var reaction: MascotView.Mood {
        switch verdict {
        case .tight: return .thinking
        case .comfortable: return .idle
        case .plenty: return .cheer
        }
    }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "what's your weekly budget?"),
            subtitle: state.mealTypes == [.dinner]
                ? String(localized: "for dinners only. We'll show the total before you shop.")
                : String(localized: "for every meal we plan. We'll show the total before you shop."),
            reaction: reaction,
            onContinue: onContinue
        ) {
            BudgetEditor(
                budget: $state.budget,
                country: country,
                portions: state.portions,
                days: state.dinnersPerWeek,
                mealTypes: state.mealTypes,
                onUserChange: { state.budgetTouched = true }
            )
        }
    }
}

// MARK: 12. Where do you shop?

struct StoreStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    @State private var isCountryPickerShown: Bool = false
    @State private var isRequestShown: Bool = false
    @State private var requestDraft: String = ""

    private var country: Country { state.country(in: FoodCatalog.bundled) }

    var body: some View {
        QuestionScaffold(
            title: String(localized: "where do you shop?"),
            subtitle: String(localized: "pick as many as you like. We'll price your week at the first one."),
            buttonTitle: continueTitle(selected: state.storeIds.count),
            isButtonEnabled: !state.storeIds.isEmpty,
            onContinue: onContinue
        ) {
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                Button {
                    isCountryPickerShown = true
                } label: {
                    HStack(spacing: Theme.Spacing.s) {
                        Text(country.flagEmoji)
                        Text("Shopping in \(country.name)")
                            .foregroundStyle(Theme.aubergine)
                        Text("· change")
                            .foregroundStyle(Theme.tomatoDeep)
                    }
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .frame(minHeight: 44)
                }
                .buttonStyle(.plain)
                StorePicker(countryId: state.countryId, selection: $state.storeIds)
                Button {
                    requestDraft = state.requestedStore
                    isRequestShown = true
                } label: {
                    Label(state.requestedStore.isEmpty ? String(localized: "Request your store") : String(localized: "Requested: \(state.requestedStore)"), systemImage: "plus.bubble")
                }
                .buttonStyle(QuietButtonStyle(color: Theme.tomatoDeep))
                .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $isCountryPickerShown) {
            NavigationStack {
                ScrollView {
                    CountryPicker(selection: countryBinding) { isCountryPickerShown = false }
                        .padding(Theme.Spacing.gutter)
                }
                .background(Theme.cream.ignoresSafeArea())
                .navigationTitle(String(localized: "Where do you shop?"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "Done")) { isCountryPickerShown = false }
                    }
                }
            }
        }
        .alert(String(localized: "Which store should we add?"), isPresented: $isRequestShown) {
            TextField(String(localized: "Store name"), text: $requestDraft)
            Button(String(localized: "Send request")) { state.requestedStore = requestDraft }
            Button(String(localized: "Cancel"), role: .cancel) {}
        } message: {
            Text("We'll keep it with your answers and look at adding it.")
        }
    }

    private var countryBinding: Binding<String> {
        Binding<String>(
            get: { state.countryId },
            set: { newValue in
                guard newValue != state.countryId else { return }
                state.countryId = newValue
                state.budgetTouched = false
                // Shops from another country no longer apply.
                state.keepOnlyStores(availableIn: newValue, catalog: FoodCatalog.bundled)
                state.refreshSuggestedBudget(catalog: FoodCatalog.bundled)
            }
        )
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
                    Text("Daily calories")
                        .font(.headline)
                        .fixedSize(horizontal: true, vertical: false)
                    Spacer(minLength: Theme.Spacing.s)
                    calorieStepper.fixedSize(horizontal: true, vertical: false)
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
            .lineLimit(1)
            .minimumScaleFactor(0.65)
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
        HStack(spacing: Theme.Spacing.xs) {
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
