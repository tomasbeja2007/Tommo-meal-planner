import Foundation
import SwiftData
import Observation
import ForkcastCore

/// Owns the single `UserProfile` and derives everything the rest of the app
/// needs from it (country, store, currency, units, planner rules).
@MainActor
@Observable
final class ProfileStore {
    let context: ModelContext
    let catalog: FoodCatalog
    private(set) var profile: UserProfile?

    init(context: ModelContext, catalog: FoodCatalog) {
        self.context = context
        self.catalog = catalog
        reload()
    }

    func reload() {
        let descriptor = FetchDescriptor<UserProfile>(sortBy: [SortDescriptor(\UserProfile.createdAt, order: .forward)])
        let all: [UserProfile] = (try? context.fetch(descriptor)) ?? []
        profile = all.first
        // CloudKit can sync a second profile from another device; keep the oldest.
        if all.count > 1 {
            for extra in all.dropFirst() where extra.onboardingCompletedAt == nil {
                context.delete(extra)
            }
        }
    }

    var hasCompletedOnboarding: Bool {
        profile?.onboardingCompletedAt != nil
    }

    var name: String {
        let trimmed: String = profile?.name.trimmingCharacters(in: .whitespaces) ?? ""
        return trimmed
    }

    var country: Country {
        if let id = profile?.countryId, let country = catalog.country(id: id) {
            return country
        }
        return catalog.defaultCountry
    }

    var store: Store? {
        guard let id = profile?.storeId else { return nil }
        return catalog.store(id: id)
    }

    var storeName: String {
        store?.name ?? String(localized: "your local store")
    }

    var currencyCode: String { country.currencyCode }

    var unitSystem: UnitSystem {
        if let raw = profile?.unitSystemOverride, let system = UnitSystem(rawValue: raw) {
            return system
        }
        return country.unitSystem
    }

    var pricing: PriceContext {
        PriceContext(country: country, store: store)
    }

    var portionsPerMeal: Double {
        profile?.portionsPerMeal ?? 2
    }

    /// Servings per planned meal (portions rounded up, at least 1).
    var defaultServings: Double {
        max(1, portionsPerMeal.rounded(.up))
    }

    var cookingDays: Set<Int> {
        let days: Set<Int> = profile?.cookingDays ?? [1, 2, 3, 4, 5]
        return days.isEmpty ? [1, 2, 3, 4, 5] : days
    }

    var weeklyBudget: Double {
        profile?.weeklyBudget ?? 50
    }

    var plannerProfile: PlannerProfile {
        guard let profile else { return PlannerProfile() }
        return PlannerProfile(
            allergens: profile.allergens,
            diet: profile.diet,
            dislikes: profile.dislikedIngredientIds,
            appliances: profile.appliances.isEmpty ? Set(Appliance.allCases) : profile.appliances,
            maxCookMinutes: profile.maxCookMinutesOrNil,
            vibes: Set(profile.vibes),
            includeUserRecipes: profile.includeUserRecipesInPlans
        )
    }

    func formatMoney(_ amount: Double, fractionDigits: Int = 2) -> String {
        MoneyFormat.string(amount, currencyCode: currencyCode, fractionDigits: fractionDigits)
    }

    // MARK: Writing

    @discardableResult
    func createProfile(from state: OnboardingState) -> UserProfile {
        let target: UserProfile
        if let existing = profile {
            target = existing
        } else {
            target = UserProfile()
            context.insert(target)
        }
        state.apply(to: target)
        target.onboardingCompletedAt = Date()
        save()
        profile = target
        return target
    }

    func save() {
        do {
            try context.save()
        } catch {
            PersistenceController.logger.error("Profile save failed: \(String(describing: error), privacy: .public)")
        }
    }

    /// "Start over": re-run onboarding, keep everything else.
    func resetOnboarding() {
        profile?.onboardingCompletedAt = nil
        save()
    }

    func deleteProfile() {
        if let profile {
            context.delete(profile)
        }
        profile = nil
        save()
    }
}
