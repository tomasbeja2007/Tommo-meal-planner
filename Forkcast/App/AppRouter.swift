import SwiftUI
import Observation
import ForkcastCore

/// Navigation state: tabs, paths, sheets, the paywall and deep links.
@MainActor
@Observable
final class AppRouter {
    enum Tab: Hashable {
        case plan
        case groceries
        case recipes
        case you
    }

    var selectedTab: Tab = .plan
    var planPath = NavigationPath()
    var groceriesPath = NavigationPath()
    var recipesPath = NavigationPath()
    var youPath = NavigationPath()

    var isPaywallPresented: Bool = false
    var isWeekEditorPresented = false

    var isAtTabRoot: Bool {
        switch selectedTab {
        case .plan: return planPath.isEmpty
        case .groceries: return groceriesPath.isEmpty
        case .recipes: return recipesPath.isEmpty
        case .you: return youPath.isEmpty
        }
    }

    /// Shown once, when the user lands on their first plan.
    var showPlanReveal: Bool = false
    /// Recipe opened from a deep link (widget tap).
    var deepLinkRecipeId: String? = nil
    /// Pre-filled create screen from an import.
    var importDraft: RecipeDraft? = nil
    /// Opens the import screen (from the share extension or "Import" buttons).
    var isImportPresented: Bool = false
    var pendingImportText: String? = nil

    /// Runs `action` if the user has Pro, otherwise shows the paywall.
    func gate(isPro: Bool, _ action: () -> Void) {
        if isPro {
            action()
        } else {
            isPaywallPresented = true
        }
    }

    func select(_ tab: Tab, isPro: Bool) {
        if tab == .plan || tab == .you || isPro {
            selectedTab = tab
        } else {
            isPaywallPresented = true
        }
    }

    func handle(url: URL) {
        guard let link = DeepLink(url: url) else { return }
        switch link {
        case .recipe(let id):
            selectedTab = .plan
            deepLinkRecipeId = id
        case .importRecipe:
            selectedTab = .recipes
            isImportPresented = true
        case .plan:
            selectedTab = .plan
        case .groceries:
            selectedTab = .groceries
        }
    }

    func popToRoot() {
        planPath = NavigationPath()
        groceriesPath = NavigationPath()
        recipesPath = NavigationPath()
        youPath = NavigationPath()
    }
}
