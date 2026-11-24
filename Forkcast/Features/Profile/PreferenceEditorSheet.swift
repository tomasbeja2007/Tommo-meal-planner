import SwiftUI
import ForkcastCore

/// Edits one preference with the onboarding component, then offers to update the plan.
struct PreferenceEditorSheet: View {
    let kind: PreferenceKind

    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(\.dismiss) private var dismiss: DismissAction

    @State private var state: OnboardingState = OnboardingState()
    @State private var unitChoice: String = "auto"
    @State private var didLoad: Bool = false
    @State private var isUpdatePromptShown: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    editor
                }
                .padding(Theme.Spacing.gutter)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(kind.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save"), action: save)
                        .fontWeight(.bold)
                        .disabled(!isValid)
                }
            }
            .alert(String(localized: "update this week's plan?"), isPresented: $isUpdatePromptShown) {
                Button(String(localized: "Regenerate unlocked meals")) {
                    Task { await planStore.regenerate(keepCookedAndLiked: true) }
                    dismiss()
                }
                Button(String(localized: "Keep as is"), role: .cancel) { dismiss() }
            } message: {
                Text("Cooked and liked dinners stay put.")
            }
        }
        .onAppear(perform: load)
    }

    @ViewBuilder
    private var editor: some View {
        switch kind {
        case .country:
            CountryPicker(selection: $state.countryId)
        case .store:
            StorePicker(countryId: state.countryId, selection: $state.storeIds)
        case .household:
            HouseholdEditor(adults: $state.adults, kids: $state.kids)
        case .cookingDays:
            CookingDaysEditor(days: $state.cookingDays)
        case .budget:
            BudgetEditor(budget: $state.budget, country: state.country(in: FoodCatalog.bundled), portions: state.portions, days: state.cookingDays.count)
        case .vibes:
            VibePicker(selection: $state.vibes)
        case .diet:
            DietPicker(selection: $state.diet)
        case .allergies:
            QuestionHeader(title: String(localized: "any allergies?"), subtitle: String(localized: "we'll never include these, and that includes hidden sources."))
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
        switch kind {
        case .cookingDays: return !state.cookingDays.isEmpty
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
        if kind == .units {
            profile.unitSystemOverride = unitChoice == "auto" ? nil : unitChoice
        } else {
            if kind == .country {
                // Shops from another country no longer apply; `apply` falls back to "My local store".
                state.keepOnlyStores(availableIn: state.countryId, catalog: FoodCatalog.bundled)
            }
            state.apply(to: profile)
        }
        profileStore.save()
        planStore.recompute()
        if kind.affectsPlan && planStore.hasPlan {
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
