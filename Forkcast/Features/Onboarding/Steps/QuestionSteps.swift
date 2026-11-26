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
                    OptionTile(title: obstacle.title, emoji: obstacle.emoji, illustration: "obstacle-\(obstacle.rawValue)", isSelected: state.obstacles.contains(obstacle)) {
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
            DislikesPicker(selection: $state.dislikes, unitSystem: state.units(in: FoodCatalog.bundled))
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

/// "Plan around my macros" switch, then (when on) a calorie ring with − / +, the macro split presets
/// with a row per macro, and the guidance notes. Used in onboarding and on Profile → Nutrition goals.
struct NutritionTargetEditor: View {
    @Binding var target: NutritionTarget?
    /// Profile only: the plan already exists, so say when changes take effect.
    var showsNextPlanNote: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var lastTarget = NutritionTarget()

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
            ProfileToggleRow(
                glyph: "glyph-calories",
                title: String(localized: "Plan around my macros"),
                subtitle: String(localized: "We fit your meals to these numbers"),
                isOn: Binding(
                    get: { target != nil },
                    set: { isOn in
                        if isOn {
                            if target == nil { target = lastTarget }
                        } else {
                            if let target { lastTarget = target }
                            target = nil
                        }
                    }
                )
            )
            .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(Theme.card))
            .elevation(Theme.Elevation.card)

            if let current = target {
                NutritionTargetControls(target: Binding(
                    get: { target ?? current },
                    set: { target = $0 }
                ))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                if showsNextPlanNote {
                    Text("Changes apply to your next plan.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                }
                Text("The 2,000 kcal starting point is based on average adult needs. Targets here are general guidance, not medical advice. Talk to a doctor or registered dietitian about what's right for you.")
                    .font(.footnote)
                    .foregroundStyle(Theme.aubergineFaint)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Theme.Spacing.xs)
        }
        .animation(Theme.motion(reduceMotion), value: target != nil)
    }
}

private struct NutritionTargetControls: View {
    @Binding var target: NutritionTarget
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let presetColumns: [GridItem] = [
        GridItem(.flexible(), spacing: Theme.Spacing.s),
        GridItem(.flexible(), spacing: Theme.Spacing.s)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
            ProfileGroup(title: String(localized: "Daily calories")) {
                HStack(spacing: Theme.Spacing.l) {
                    calorieButton(systemImage: "minus", delta: -NutritionTarget.calorieStep)
                    CalorieRing(calories: target.calories, split: target.percentages)
                        .frame(width: 150, height: 150)
                        .animation(reduceMotion ? nil : Theme.Motion.update, value: target)
                    calorieButton(systemImage: "plus", delta: NutritionTarget.calorieStep)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.l)
                .sensoryFeedback(.selection, trigger: target.calories)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Daily calorie target"))
                .accessibilityValue(Text("\(target.calories.formatted()) kilocalories"))
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment: change(by: NutritionTarget.calorieStep)
                    case .decrement: change(by: -NutritionTarget.calorieStep)
                    @unknown default: break
                    }
                }
            }

            ProfileGroup(title: String(localized: "Macro split")) {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    LazyVGrid(columns: presetColumns, spacing: Theme.Spacing.s) {
                        ForEach(NutritionTarget.Preset.allCases) { preset in
                            presetButton(preset)
                        }
                    }
                    .sensoryFeedback(.selection, trigger: target.preset)
                    let split = target.percentages
                    let grams = target.grams
                    macroRow(String(localized: "Protein"), grams: grams.protein, percent: split.protein, tint: Theme.macroProtein)
                    macroRow(String(localized: "Carbs"), grams: grams.carbs, percent: split.carbs, tint: Theme.macroCarbs)
                    macroRow(String(localized: "Fat"), grams: grams.fat, percent: split.fat, tint: Theme.macroFat)
                    if target.preset == .custom {
                        VStack(spacing: Theme.Spacing.s) {
                            customRow(String(localized: "Protein %"), value: $target.customProteinPercent, range: 0...(100 - split.carbs))
                            customRow(String(localized: "Carbs %"), value: $target.customCarbPercent, range: 0...(100 - split.protein))
                            Text("Fat takes the remaining share.")
                                .font(.footnote)
                                .foregroundStyle(Theme.aubergineMuted)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .transition(.opacity)
                    }
                }
                .padding(Theme.Spacing.l)
                .animation(reduceMotion ? nil : Theme.Motion.update, value: target)
            }

            Label {
                Text("Your target is for one adult. Tommo sizes each day's portions so one adult's day lands near it.")
                    .fixedSize(horizontal: false, vertical: true)
            } icon: {
                Image(systemName: "info.circle")
            }
            .font(.footnote)
            .foregroundStyle(Theme.aubergineMuted)
            .padding(Theme.Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous).fill(Theme.creamDeep))
        }
    }

    private func change(by delta: Int) {
        let range = NutritionTarget.calorieRange
        target.calories = min(range.upperBound, max(range.lowerBound, target.calories + delta))
    }

    private func calorieButton(systemImage: String, delta: Int) -> some View {
        let range = NutritionTarget.calorieRange
        let enabled = delta > 0 ? target.calories < range.upperBound : target.calories > range.lowerBound
        let isPlus = delta > 0
        return Button { change(by: delta) } label: {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(isPlus ? Color.white : Theme.aubergine)
                .frame(width: Theme.Size.tapTarget, height: Theme.Size.tapTarget)
                .background(Circle().fill(isPlus ? Theme.aubergine : Theme.card))
                .overlay(Circle().stroke(isPlus ? Color.clear : Theme.line, lineWidth: 1))
                .opacity(enabled ? 1 : 0.4)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }

    private func presetButton(_ preset: NutritionTarget.Preset) -> some View {
        let isSelected = target.preset == preset
        return Button {
            target.preset = preset
        } label: {
            HStack(spacing: Theme.Spacing.inline) {
                Image(systemName: isSelected ? "checkmark" : preset.symbol)
                    .font(.caption.weight(.bold))
                Text(preset.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
            .foregroundStyle(isSelected ? Color.white : Theme.aubergine)
            .frame(maxWidth: .infinity, minHeight: Theme.Size.tapTarget)
            .background(Capsule().fill(isSelected ? Theme.aubergine : Theme.card))
            .overlay(Capsule().stroke(isSelected ? Color.clear : Theme.line, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    /// "● Protein      225 g   30%" with a bar filled to the percentage.
    private func macroRow(_ name: String, grams: Int, percent: Int, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            HStack(spacing: Theme.Spacing.s) {
                Circle().fill(tint).frame(width: 8, height: 8).accessibilityHidden(true)
                Text(name)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                Spacer(minLength: Theme.Spacing.s)
                Text("\(grams) g")
                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(grams)))
                Text("\(percent)%")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                    .monospacedDigit()
                    .frame(minWidth: 40, alignment: .trailing)
            }
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.creamDeep)
                    Capsule().fill(tint).frame(width: proxy.size.width * CGFloat(percent) / 100)
                }
            }
            .frame(height: 6)
            .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
    }

    private func customRow(_ title: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        HStack {
            Text(title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
            Spacer(minLength: Theme.Spacing.s)
            RoundStepper(value: value, range: range, suffix: "%", step: 5)
        }
    }
}

/// The day's calories as a ring split into protein, carbs and fat.
private struct CalorieRing: View {
    let calories: Int
    let split: (protein: Int, carbs: Int, fat: Int)

    private let lineWidth: CGFloat = 16
    /// Room for the round caps between segments, as a fraction of the ring.
    private let gap: Double = 0.03

    var body: some View {
        let protein = Double(split.protein) / 100
        let carbs = Double(split.carbs) / 100
        ZStack {
            Circle().stroke(Theme.creamDeep, lineWidth: lineWidth)
            segment(from: 0, to: protein, color: Theme.macroProtein)
            segment(from: protein, to: protein + carbs, color: Theme.macroCarbs)
            segment(from: protein + carbs, to: 1, color: Theme.macroFat)
            VStack(spacing: Theme.Spacing.xxs) {
                Text(calories.formatted())
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(calories)))
                Text("kcal a day")
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineMuted)
            }
        }
        .padding(lineWidth / 2)
    }

    @ViewBuilder
    private func segment(from start: Double, to end: Double, color: Color) -> some View {
        if end - start > gap * 2 {
            Circle()
                .trim(from: start + gap, to: end - gap)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

private extension NutritionTarget.Preset {
    var symbol: String {
        switch self {
        case .balanced: return "chart.bar.fill"
        case .highProtein: return "bolt.fill"
        case .lowCarb: return "leaf.fill"
        case .custom: return "slider.horizontal.3"
        }
    }

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
