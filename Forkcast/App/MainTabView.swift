import SwiftUI
import ForkcastCore

/// Plan · Groceries · Recipes · You. Groceries and Recipes are Pro-only:
/// tapping them in preview mode presents the paywall instead.
struct MainTabView: View {
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager

    var body: some View {
        @Bindable var router = router
        TabView(selection: tabSelection) {
            PlanView()
                .tabItem { Label(String(localized: "Plan"), systemImage: "calendar") }
                .tag(AppRouter.Tab.plan)
            GroceriesView()
                .tabItem { Label(String(localized: "Groceries"), systemImage: "cart") }
                .tag(AppRouter.Tab.groceries)
            RecipesView()
                .tabItem { Label(String(localized: "Recipes"), systemImage: "book") }
                .tag(AppRouter.Tab.recipes)
            ProfileView()
                .tabItem { Label(String(localized: "You"), systemImage: "person.crop.circle") }
                .tag(AppRouter.Tab.you)
        }
        .tint(Theme.tomato)
        .toolbarBackground(Theme.card, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .fullScreenCover(isPresented: $router.isPaywallPresented) {
            PaywallFlow()
        }
        .sheet(isPresented: $router.isImportPresented) {
            ImportRecipeView(initialText: router.pendingImportText)
        }
    }

    private var tabSelection: Binding<AppRouter.Tab> {
        Binding<AppRouter.Tab>(
            get: { router.selectedTab },
            set: { newValue in router.select(newValue, isPro: subscriptions.hasProAccess) }
        )
    }
}

/// Route for pushing a recipe detail onto any NavigationStack.
struct RecipeRoute: Hashable {
    let recipeId: String
    var plannedMealID: UUID? = nil
}

/// Shared date strings.
enum DateText {
    /// "MON · 24 Nov"
    static func dayLabel(_ date: Date) -> String {
        let weekday: String = date.formatted(.dateTime.weekday(.abbreviated)).uppercased()
        let day: String = date.formatted(.dateTime.day().month(.abbreviated))
        return "\(weekday) · \(day)"
    }

    /// "Tuesday"
    static func weekdayName(_ date: Date) -> String {
        date.formatted(.dateTime.weekday(.wide))
    }

    /// "Tue"
    static func shortWeekday(_ date: Date) -> String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }

    /// "21–27 Nov"
    static func range(from start: Date, to end: Date) -> String {
        let calendar: Calendar = Calendar.current
        let sameMonth: Bool = calendar.component(.month, from: start) == calendar.component(.month, from: end)
        let endText: String = end.formatted(.dateTime.day().month(.abbreviated))
        let startText: String = sameMonth ? start.formatted(.dateTime.day()) : start.formatted(.dateTime.day().month(.abbreviated))
        return "\(startText)–\(endText)"
    }

    /// Localised short weekday names, ISO order (Mon first).
    static var isoShortWeekdays: [String] {
        let symbols: [String] = Calendar.current.shortWeekdaySymbols // Sunday first
        guard symbols.count == 7 else { return WeekMath.englishShortWeekdays }
        return Array(symbols[1...6]) + [symbols[0]]
    }

    static func usedOn(_ weekdays: [Int]) -> String {
        GroceryAggregator.usedOnText(weekdays, shortNames: isoShortWeekdays)
    }
}

#Preview { MainTabView().previewEnvironment() }
