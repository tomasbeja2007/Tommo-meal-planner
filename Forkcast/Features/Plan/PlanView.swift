import SwiftUI
import ForkcastCore

struct PlanView: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var swapTarget: PlannedMeal? = nil
    @State private var addTarget: AddMealTarget? = nil
    @State private var isEditingWeek: Bool = false
    @State private var isWhyCheaperShown: Bool = false
    @State private var isFeedbackShown: Bool = false
    @State private var isRegenerateConfirmShown: Bool = false
    @State private var showsQuickActions = false
    @State private var pendingQuickAction: QuickAction?
    @AccessibilityFocusState private var quickActionsFocused: Bool

    private enum QuickAction {
        case importRecipe
        case planWeek
    }

    @State private var didAutoShowFeedback: Bool = false

    private var isPro: Bool { subscriptions.hasProAccess }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.planPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    HStack(alignment: .top, spacing: Theme.Spacing.m) {
                        PlanHeader(name: profileStore.name, storeName: profileStore.storeName, store: profileStore.store)
                        quickActions.padding(.top, Theme.Spacing.l)
                    }
                    if planStore.hasPlan {
                        planContent
                    } else {
                        EmptyState(
                            title: String(localized: "no plan this week yet"),
                            message: profileStore.mealTypes == [.dinner] ? String(localized: "we'll build a costed week of dinners for your shop.") : String(localized: "we'll build a costed week of meals for your shop."),
                            actionTitle: String(localized: "Build my week")
                        ) {
                            Task { await planStore.generatePlan() }
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.bottom, Theme.Spacing.xxl)
            }
            .background(Theme.cream.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: RecipeRoute.self) { route in
                RecipeDetailView(recipeId: route.recipeId)
            }
            .overlay(alignment: .top) {
                if router.showPlanReveal {
                    PlanRevealToast(name: profileStore.name) {
                        withAnimation(reduceMotion ? nil : Theme.Motion.fadeOut) { router.showPlanReveal = false }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .overlay {
                if planStore.isGenerating {
                    GeneratingOverlay()
                }
            }
            .animation(reduceMotion ? nil : Theme.Motion.fadeIn, value: planStore.isGenerating)
        }
        .sheet(isPresented: $showsQuickActions, onDismiss: openQuickAction) {
            NavigationStack {
                List {
                    quickActionRow("Import recipe", detail: "Bring a recipe into Tommo.", icon: "square.and.arrow.down", action: .importRecipe)
                    quickActionRow(planStore.hasPlan ? "Edit week" : "Build my week", detail: "Choose dinners and servings.", icon: "calendar", action: .planWeek)
                }
                .scrollContentBackground(.hidden)
                .background(Theme.cream.ignoresSafeArea())
                .navigationTitle("Quick actions")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { showsQuickActions = false }
                    }
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $swapTarget) { meal in
            SwapSheet(meal: meal)
                .presentationDetents([.large, .medium])
        }
        .sheet(item: $addTarget) { target in
            RecipePickerSheet(title: String(localized: "add a \(target.mealType.noun)"), mealType: target.mealType) { recipeId in
                planStore.addMeal(recipeId: recipeId, on: target.date, mealType: target.mealType)
                addTarget = nil
            }
        }
        .fullScreenCover(isPresented: $isEditingWeek) {
            EditWeekSheet()
        }
        .sheet(isPresented: $isWhyCheaperShown) {
            WhyCheaperSheet()
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $isFeedbackShown) {
            WeeklyFeedbackSheet()
                .presentationDetents([.large])
        }
        .confirmationDialog(String(localized: "keep the meals you've cooked or liked?"), isPresented: $isRegenerateConfirmShown, titleVisibility: .visible) {
            Button(String(localized: "Keep them, regenerate the rest")) {
                Task { await planStore.regenerate(keepCookedAndLiked: true) }
            }
            Button(String(localized: "Regenerate everything"), role: .destructive) {
                Task { await planStore.regenerate(keepCookedAndLiked: false) }
            }
            Button(String(localized: "Cancel"), role: .cancel) {}
        }
        .onChange(of: router.deepLinkRecipeId) { _, newValue in
            openDeepLink(newValue)
        }
        .onAppear {
            openDeepLink(router.deepLinkRecipeId)
            autoShowFeedbackIfNeeded()
        }
        .task(id: router.showPlanReveal) {
            guard router.showPlanReveal else { return }
            Haptics.success()
            try? await Task.sleep(nanoseconds: 3_500_000_000)
            guard !Task.isCancelled else { return }
            withAnimation(reduceMotion ? nil : Theme.Motion.fadeOut) { router.showPlanReveal = false }
        }
    }

    private var quickActions: some View {
        Button { showsQuickActions = true } label: {
            Image(systemName: "plus")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Theme.tomatoDeep)
                .frame(width: 44, height: 44)
                .background(Theme.tomatoSoft, in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Quick actions"))
        .accessibilityFocused($quickActionsFocused)
    }

    private func quickActionRow(_ title: LocalizedStringKey, detail: LocalizedStringKey, icon: String, action: QuickAction) -> some View {
        Button {
            pendingQuickAction = action
            showsQuickActions = false
        } label: {
            Label {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline)
                    Text(detail).font(.subheadline).foregroundStyle(Theme.aubergineMuted)
                }
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(Theme.tomatoDeep)
            }
            .frame(minHeight: 52)
        }
        .foregroundStyle(Theme.aubergine)
    }

    private func openQuickAction() {
        let action = pendingQuickAction
        pendingQuickAction = nil
        switch action {
        case .importRecipe:
            router.gate(isPro: isPro) {
                router.pendingImportText = nil
                router.isImportPresented = true
            }
        case .planWeek:
            if planStore.hasPlan {
                router.gate(isPro: isPro) { isEditingWeek = true }
            } else if !planStore.isGenerating {
                Task { await planStore.generatePlan() }
            }
        case nil:
            quickActionsFocused = true
        }
    }

    @ViewBuilder
    private var planContent: some View {
        if planStore.needsWeeklyFeedback {
            FeedbackPromptCard { isFeedbackShown = true }
        }
        BudgetCard(
            total: planStore.total,
            budget: planStore.budget,
            currencyCode: profileStore.currencyCode,
            onInfo: { isWhyCheaperShown = true }
        )
        GroceryShortcutCard(itemCount: planStore.groceryList.itemCount, checkedCount: planStore.checkedCount) {
            router.gate(isPro: isPro) { router.selectedTab = .groceries }
        }
        SectionHeader(title: planStore.isDinnersOnly ? String(localized: "dinners") : String(localized: "meals"), subtitle: dinnersSubtitle)
            .padding(.top, Theme.Spacing.s)
        DayList(
            onOpen: { meal in
                router.gate(isPro: isPro) { router.planPath.append(RecipeRoute(recipeId: meal.recipeId)) }
            },
            onSwap: { meal in
                router.gate(isPro: isPro) { swapTarget = meal }
            },
            onAdd: { date, type in
                router.gate(isPro: isPro) { addTarget = AddMealTarget(date: date, mealType: type) }
            }
        )
        PlanActions(
            onEdit: { router.gate(isPro: isPro) { isEditingWeek = true } },
            onRegenerate: { router.gate(isPro: isPro) { isRegenerateConfirmShown = true } }
        )
        .padding(.top, Theme.Spacing.s)
    }

    private var dinnersSubtitle: String? {
        guard let plan = planStore.currentPlan else { return nil }
        return DateText.range(from: plan.weekStartDate, to: plan.weekEndDate)
    }

    private func openDeepLink(_ id: String?) {
        guard let id else { return }
        router.deepLinkRecipeId = nil
        router.gate(isPro: isPro) {
            router.planPath = NavigationPath()
            router.planPath.append(RecipeRoute(recipeId: id))
        }
    }

    private func autoShowFeedbackIfNeeded() {
        guard !didAutoShowFeedback, isPro, planStore.needsWeeklyFeedback, !router.showPlanReveal else { return }
        didAutoShowFeedback = true
        isFeedbackShown = true
    }
}

/// A day and meal type to add a recipe to (drives the add-a-meal sheet).
struct AddMealTarget: Identifiable, Hashable {
    let date: Date
    let mealType: MealType
    var id: String { "\(date.timeIntervalSince1970)-\(mealType.rawValue)" }
}

/// "Hi Sam" + "this week" + store pill.
struct PlanHeader: View {
    let name: String
    let storeName: String
    let store: Store?

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(name.isEmpty ? String(localized: "Hi there") : String(localized: "Hi \(name)"))
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergineMuted)
            Text("this week")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
                .accessibilityAddTraits(.isHeader)
            HStack(spacing: 6) {
                if let store {
                    StoreMonogram(store: store, size: 20)
                }
                Text("planned for \(storeName)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.tomatoDeep)
            }
            .padding(.leading, 4)
            .padding(.trailing, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(Theme.tomatoSoft))
        }
        .padding(.top, Theme.Spacing.l)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct GeneratingOverlay: View {
    var body: some View {
        ZStack {
            Theme.cream.opacity(0.85).ignoresSafeArea()
            VStack(spacing: Theme.Spacing.m) {
                MascotView(size: 110, mood: .thinking)
                Text("cooking up a new week…")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
            }
        }
        .transition(.opacity)
    }
}

/// Edit week + Regenerate.
private struct PlanActions: View {
    let onEdit: () -> Void
    let onRegenerate: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Button(action: onEdit) {
                Label(String(localized: "Edit week"), systemImage: "slider.horizontal.3")
            }
            .buttonStyle(SecondaryButtonStyle(outlined: false))
            Button(action: onRegenerate) {
                Label(String(localized: "Regenerate"), systemImage: "arrow.clockwise")
            }
            .buttonStyle(SecondaryButtonStyle(outlined: true))
        }
    }
}

#Preview { PlanView().previewEnvironment() }
