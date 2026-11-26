import SwiftUI
import UIKit
import ForkcastCore

/// Plan · Groceries · Recipes · You. Groceries and Recipes are Pro-only:
/// tapping them in preview mode presents the paywall instead.
struct MainTabView: View {
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(PlanStore.self) private var planStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AccessibilityFocusState private var quickActionFocused: Bool
    @State private var showsActions = false
    @State private var showsPantry = false

    var body: some View {
        @Bindable var router = router
        TabView(selection: tabSelection) {
            PlanView()
                .tabItem {
                    Label { Text(String(localized: "Meal Plan")) } icon: {
                        TabIcon.image("tab-plan", selected: router.selectedTab == .plan, fallback: "calendar")
                    }
                }
                .tag(AppRouter.Tab.plan)
            GroceriesView()
                .tabItem {
                    Label { Text(String(localized: "Groceries")) } icon: {
                        TabIcon.image("tab-groceries", selected: router.selectedTab == .groceries, fallback: "cart")
                    }
                }
                .tag(AppRouter.Tab.groceries)
            RecipesView()
                .tabItem {
                    Label { Text(String(localized: "Cookbook")) } icon: {
                        TabIcon.image("tab-cookbook", selected: router.selectedTab == .recipes, fallback: "book")
                    }
                }
                .tag(AppRouter.Tab.recipes)
            ProfileView()
                .tabItem {
                    Label { Text(String(localized: "Profile")) } icon: {
                        TabIcon.image("tab-profile", selected: router.selectedTab == .you, fallback: "person.crop.circle")
                    }
                }
                .tag(AppRouter.Tab.you)
        }
        .accessibilityHidden(showsActions)
        .overlay(alignment: .bottomTrailing) {
            if router.isAtTabRoot { quickActions }
        }
        .onChange(of: router.selectedTab) { _, _ in showsActions = false }
        .onChange(of: router.isAtTabRoot) { _, atRoot in
            if !atRoot { showsActions = false }
        }
        .tint(Theme.tomato)
        .toolbarBackground(Theme.card, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .fullScreenCover(isPresented: $router.isPaywallPresented) {
            PaywallFlow()
        }
        .sheet(isPresented: $showsPantry) { PantryEditorSheet(initial: planStore.currentOnHand) }
    }

    private var quickActions: some View {
        ZStack(alignment: .bottomTrailing) {
            if showsActions {
                Theme.scrim
                    .ignoresSafeArea()
                    .onTapGesture { setActions(false) }
                    .accessibilityHidden(true)
                    .transition(.opacity)
            }
            VStack(alignment: .trailing, spacing: Theme.Spacing.s) {
                if showsActions {
                    VStack(spacing: 0) {
                        actionRow("Select ingredients", detail: "Cook with what you have", icon: "glyph-pantry") {
                            showsPantry = true
                        }
                        Divider()
                        actionRow("Plan my week", detail: "Days, budget & servings", icon: "calendar") {
                            if planStore.hasPlan {
                                router.gate(isPro: subscriptions.hasProAccess) {
                                    router.selectedTab = .plan
                                    router.isWeekEditorPresented = true
                                }
                            } else if !planStore.isGenerating {
                                router.selectedTab = .plan
                                Task { await planStore.generatePlan() }
                            }
                        }
                    }
                    .cardStyle()
                    .frame(maxWidth: 320)
                    .transition(reduceMotion ? .opacity : .scale(scale: 0.92, anchor: .bottomTrailing)
                        .combined(with: .offset(y: 8)).combined(with: .opacity))
                }
                Button { setActions(!showsActions) } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 21, weight: .bold))
                        .rotationEffect(.degrees(showsActions ? 45 : 0))
                        .foregroundStyle(.white)
                        .frame(width: 51, height: 51)
                        .background(Theme.tomatoDeep, in: Circle())
                        .elevation(Theme.Elevation.lifted)
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: showsActions)
                .accessibilityLabel(showsActions ? Text("Close quick actions") : Text("Quick actions"))
                .accessibilityFocused($quickActionFocused)
            }
            .padding(.trailing, Theme.Spacing.m)
            .padding(.leading, Theme.Spacing.m)
            .padding(.bottom, Theme.Size.tabBarHeight)
        }
        .accessibilityAction(.escape) { setActions(false) }
    }

    private func actionRow(_ title: LocalizedStringKey, detail: LocalizedStringKey, icon: String, action: @escaping () -> Void) -> some View {
        Button {
            setActions(false)
            action()
        } label: {
            HStack(spacing: Theme.Spacing.m) {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(title).font(.headline).foregroundStyle(Theme.aubergine)
                    Text(detail).font(.subheadline).foregroundStyle(Theme.aubergineMuted)
                }
                Spacer(minLength: 0)
                Group {
                    if icon.hasPrefix("glyph-") { Glyph(name: icon, size: 22) } else { Image(systemName: icon) }
                }
                .foregroundStyle(Theme.tomatoDeep)
                .accessibilityHidden(true)
            }
            .padding(.vertical, Theme.Spacing.s)
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }

    private func setActions(_ open: Bool) {
        withAnimation(.easeOut(duration: reduceMotion ? 0.12 : 0.21)) { showsActions = open }
        if !open { quickActionFocused = true }
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

/// Custom tab bar icons (`tab-<name>` outline, `tab-<name>-fill` when selected), drawn as template images
/// at the tab bar's 26 pt so they take the tab tint like system symbols. Falls back to the SF Symbol until
/// the art exists. Rendered once per name and cached.
enum TabIcon {
    @MainActor private static var cache: [String: UIImage] = [:]

    @MainActor
    static func image(_ name: String, selected: Bool, fallback: String) -> Image {
        // Outline when not selected, filled when selected; either one stands in for the other if missing.
        let candidates = selected ? [name + "-fill", name] : [name, name + "-fill"]
        for candidate in candidates {
            if let icon = rendered(candidate) { return Image(uiImage: icon) }
        }
        return Image(systemName: fallback)
    }

    @MainActor
    private static func rendered(_ name: String) -> UIImage? {
        if let cached = cache[name] { return cached }
        guard let source = UIImage(named: name) else { return nil }
        let side: CGFloat = 26
        let aspect = source.size.height > 0 ? source.size.width / source.size.height : 1
        let size = aspect >= 1 ? CGSize(width: side, height: side / aspect) : CGSize(width: side * aspect, height: side)
        let icon = UIGraphicsImageRenderer(size: size).image { _ in
            source.draw(in: CGRect(origin: .zero, size: size))
        }.withRenderingMode(.alwaysTemplate)
        cache[name] = icon
        return icon
    }
}
