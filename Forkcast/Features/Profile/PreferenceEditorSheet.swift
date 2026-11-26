import SwiftUI
import ForkcastCore

/// Edits one preference with the onboarding component, then offers to update the plan.
struct PreferenceEditorSheet: View {
    let kind: PreferenceKind

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(\.dismiss) private var dismiss: DismissAction
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var state: OnboardingState = OnboardingState()
    @State private var unitChoice: String = "auto"
    @State private var didLoad: Bool = false
    @State private var isUpdatePromptShown: Bool = false
    @State private var switchedKind: PreferenceKind? = nil

    /// The editor showing now: starts as `kind`; "Change country" on the shop list swaps to the country list.
    private var active: PreferenceKind { switchedKind ?? kind }

    /// A compact sheet: title on the left, Done on the right, the editor below. Swipe down to cancel.
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.m) {
                Text(active.title)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: Theme.Spacing.s)
                Button(String(localized: "Done"), action: save)
                    .font(.system(.headline, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.tomatoDeep)
                    .frame(minHeight: Theme.Size.tapTarget)
                    .disabled(!isValid)
                    .opacity(isValid ? 1 : 0.4)
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.top, Theme.Spacing.xl)
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    if active == .store {
                        storeIntro
                    }
                    editor
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.s)
                .padding(.bottom, Theme.Spacing.xl)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .background(Theme.cream.ignoresSafeArea())
        .animation(Theme.motion(reduceMotion), value: active)
        .alert(String(localized: "update this week's plan?"), isPresented: $isUpdatePromptShown) {
            Button(String(localized: "Regenerate unlocked meals")) {
                Task { await planStore.regenerate(keepCookedAndLiked: true) }
                dismiss()
            }
            Button(String(localized: "Keep as is"), role: .cancel) { dismiss() }
        } message: {
            Text("Cooked and liked meals stay put.")
        }
        .onAppear(perform: load)
    }

    /// "Pick the shops you use…" and a link to change the country, above the shop grid.
    private var storeIntro: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            Text("Pick the shops you use. The first one you pick sets the prices.")
                .font(.subheadline)
                .foregroundStyle(Theme.aubergineMuted)
                .fixedSize(horizontal: false, vertical: true)
            Button {
                switchedKind = .country
            } label: {
                HStack(spacing: Theme.Spacing.xs) {
                    let country = state.country(in: FoodCatalog.bundled)
                    Text("\(country.flagEmoji) \(country.name) ·")
                        .foregroundStyle(Theme.aubergineMuted)
                    Text("Change country")
                        .foregroundStyle(Theme.tomatoDeep)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .frame(minHeight: Theme.Size.tapTarget)
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var editor: some View {
        switch active {
        case .country:
            CountryPicker(selection: $state.countryId)
        case .store:
            StorePicker(countryId: state.countryId, selection: $state.storeIds)
        case .household:
            HouseholdEditor(adults: $state.adults, kids: $state.kids)
        case .meals:
            QuestionHeader(title: String(localized: "which meals should we plan?"), subtitle: String(localized: "on every cooking day. Your budget covers them all."))
            MealTypePicker(selection: $state.mealTypes)
        case .cookingDays:
            VStack(spacing: Theme.Spacing.l) {
                CookingDaysEditor(days: $state.cookingDays, showsSummary: false, showsConnectors: state.mealPrepMode, prepEdges: $state.mealPrepEdges)
                MealPrepToggle(isOn: $state.mealPrepMode)
            }
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: state.mealPrepMode)
        case .budget:
            BudgetEditor(budget: $state.budget, country: state.country(in: FoodCatalog.bundled), portions: state.portions, days: state.cookingDays.count, mealTypes: state.mealTypes, storeName: profileStore.storeName)
        case .vibes:
            VibePicker(selection: $state.vibes)
        case .diet:
            DietPicker(selection: $state.diet)
        case .nutrition:
            NutritionTargetEditor(target: $state.nutritionTarget)
        case .allergies:
            QuestionHeader(title: String(localized: "any allergies?"), subtitle: String(localized: "Exclude recipes tagged with the allergens you select."))
            AllergyPicker(selection: $state.allergens, noAllergies: $state.noAllergies)
        case .dislikes:
            DislikesPicker(selection: $state.dislikes, unitSystem: profileStore.unitSystem)
        case .appliances:
            AppliancePicker(selection: $state.appliances)
        case .cookTime:
            CookTimePicker(maxMinutes: $state.maxCookMinutes)
        case .units:
            UnitsPicker(choice: $unitChoice, countryDefault: profileStore.country.unitSystem)
        }
    }

    private var isValid: Bool {
        switch active {
        case .cookingDays: return !state.cookingDays.isEmpty
        case .meals: return !state.mealTypes.isEmpty
        case .appliances: return !state.appliances.isEmpty
        case .store: return !state.storeIds.isEmpty
        default: return true
        }
    }

    private func load() {
        guard !didLoad, let profile = profileStore.profile else { return }
        didLoad = true
        state = OnboardingState(profile: profile)
        unitChoice = profile.unitSystemOverride ?? "auto"
    }

    private func save() {
        guard let profile = profileStore.profile else { return }
        if active == .units {
            profile.unitSystemOverride = unitChoice == "auto" ? nil : unitChoice
        } else if active == .nutrition {
            profile.nutritionTarget = state.nutritionTarget
        } else {
            if active == .country {
                // Shops from another country no longer apply; `apply` falls back to "My local store".
                state.keepOnlyStores(availableIn: state.countryId, catalog: FoodCatalog.bundled)
            }
            state.apply(to: profile, updateMealPrep: active == .cookingDays)
        }
        profileStore.save()
        planStore.recompute()
        if active.affectsPlan && planStore.hasPlan {
            isUpdatePromptShown = true
        } else {
            dismiss()
        }
    }
}

private struct UnitsPicker: View {
    @Binding var choice: String
    let countryDefault: UnitSystem

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            OptionTile(title: String(localized: "Automatic"), subtitle: String(localized: "follow my country (\(countryDefault == .imperial ? "imperial" : "metric"))"), systemImage: "globe", isSelected: choice == "auto") { choice = "auto" }
            OptionTile(title: String(localized: "Imperial"), subtitle: String(localized: "oz, lb, cups"), systemImage: "ruler", isSelected: choice == UnitSystem.imperial.rawValue) { choice = UnitSystem.imperial.rawValue }
            OptionTile(title: String(localized: "Metric"), subtitle: String(localized: "g, kg, ml"), systemImage: "ruler.fill", isSelected: choice == UnitSystem.metric.rawValue) { choice = UnitSystem.metric.rawValue }
        }
    }
}

#Preview { PreferenceEditorSheet(kind: .budget).previewEnvironment() }
