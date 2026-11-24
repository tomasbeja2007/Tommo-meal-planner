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
                // Shops from another country no longer apply.
                state.keepOnlyStores(availableIn: newValue, catalog: FoodCatalog.bundled)
                state.refreshSuggestedBudget(catalog: FoodCatalog.bundled)
            }
        )
    }
}

struct StoreStepView: View {
    @Bindable var state: OnboardingState
    let onContinue: () -> Void

    var body: some View {
        QuestionScaffold(
            title: String(localized: "which shops do you use?"),
            subtitle: String(localized: "pick as many as you like. we'll price your week at the first one"),
            isButtonEnabled: !state.storeIds.isEmpty,
            onContinue: onContinue
        ) {
            StorePicker(countryId: state.countryId, selection: $state.storeIds)
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
