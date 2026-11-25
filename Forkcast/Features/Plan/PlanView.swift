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
    @State private var isWhyCheaperShown: Bool = false
    @State private var isFeedbackShown: Bool = false
    @State private var isRegenerateConfirmShown: Bool = false
    @State private var showsNotifications = false
    @State private var selectedDate: Date?
    @State private var expandsCalendar = true

    @State private var didAutoShowFeedback: Bool = false
    @Namespace private var dayPill

    private var isPro: Bool { subscriptions.hasProAccess }

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.planPath) {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: Theme.Spacing.m) {
                    PlanHeader(name: profileStore.name, storeName: profileStore.storeName, store: profileStore.store)
                    Button { showsNotifications = true } label: {
                        Glyph(name: "glyph-reminder", size: 22)
                            .foregroundStyle(Theme.tomatoDeep)
                            .frame(width: 44, height: 44)
                            .background(Theme.tomatoSoft, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text("Reminders"))
                    .padding(.top, Theme.Spacing.l)
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                if planStore.hasPlan, let activeDate {
                    calendarStrip(active: activeDate)
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                        if planStore.hasPlan {
                            planContent
                        } else {
                            EmptyState(
                                title: String(localized: "No plan this week yet"),
                                message: String(localized: "We'll build a week of meals with estimated costs for your shop."),
                                actionTitle: String(localized: "Build my week")
                            ) {
                                guard !planStore.isGenerating else { return }
                                Task { await planStore.generatePlan() }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .padding(.bottom, 78)
                }
            }
            .background(Theme.cream.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: RecipeRoute.self) { route in
                RecipeDetailView(recipeId: route.recipeId, plannedMealID: route.plannedMealID)
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
        .sheet(isPresented: $showsNotifications) {
            NavigationStack {
                List {
                    if let profile = profileStore.profile { NotificationsSection(profile: profile) }
                }
                .navigationTitle("Reminders")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { showsNotifications = false }
                    }
                }
            }
        }
        .sheet(item: $swapTarget) { meal in
            SwapSheet(meal: meal)
                .presentationDetents([.large, .medium])
        }
        .sheet(item: $addTarget) { target in
            let title = target.mealType.map { String(localized: "Add \($0.noun)") } ?? String(localized: "Add a side or extra")
            RecipePickerSheet(title: title, mealType: target.mealType) { recipeId in
                planStore.addMeal(recipeId: recipeId, on: target.date, mealType: target.mealType, isSide: target.mealType == nil)
                addTarget = nil
            }
        }
        .fullScreenCover(isPresented: $router.isWeekEditorPresented) {
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

    private var activeDate: Date? {
        let days = planStore.weekDays
        if let selectedDate, days.contains(selectedDate) { return selectedDate }
        return days.first { Calendar.current.isDateInToday($0) } ?? days.first
    }

    private func calendarStrip(active: Date) -> some View {
        HStack(alignment: .top, spacing: Theme.Spacing.xs) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: Theme.Spacing.xs) {
                    ForEach(planStore.weekDays, id: \.self) { day in
                        let meals = planStore.meals(on: day)
                        let selected = day == active
                        Button {
                            withAnimation(Theme.motion(reduceMotion)) { selectedDate = day }
                        } label: {
                            VStack(spacing: Theme.Spacing.xs) {
                                VStack(spacing: Theme.Spacing.xxs) {
                                    Text(DateText.shortWeekday(day).prefix(1))
                                        .font(.caption2.weight(.bold))
                                    Text(day.formatted(.dateTime.day()))
                                        .font(.subheadline.weight(.bold))
                                    Circle()
                                        .fill(selected ? Color.white : Theme.tomato)
                                        .frame(width: 4, height: 4)
                                        .opacity(meals.isEmpty ? 0 : 1)
                                }
                                .frame(width: 44, height: 52)
                                .background {
                                    // One pill travels between days instead of swapping colours in place.
                                    ZStack {
                                        RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous).fill(Theme.card)
                                        if selected {
                                            RoundedRectangle(cornerRadius: Theme.Radius.medium, style: .continuous)
                                                .fill(Theme.tomatoDeep)
                                                .shadow(color: Theme.tomatoDeep.opacity(0.25), radius: 6, y: 3)
                                                .matchedGeometryEffect(id: "selectedDay", in: dayPill)
                                        }
                                    }
                                }
                                if expandsCalendar {
                                    Group {
                                        if let meal = meals.first(where: { !$0.isSide }) ?? meals.first,
                                           let recipe = planStore.recipe(for: meal) {
                                            DishTileView(recipe: recipe, size: 38, cornerRadius: Theme.Radius.small)
                                                .scaleEffect(selected ? 1.06 : 1)
                                        } else {
                                            RoundedRectangle(cornerRadius: Theme.Radius.small)
                                                .fill(Theme.creamDeep)
                                                .frame(width: 38, height: 38)
                                        }
                                    }
                                    .transition(.opacity)
                                }
                            }
                            .foregroundStyle(selected ? Color.white : Theme.aubergine)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(Text(day.formatted(.dateTime.weekday(.wide).day().month(.wide))))
                        .accessibilityValue(Text("\(meals.count) meals"))
                        .accessibilityAddTraits(selected ? .isSelected : [])
                    }
                }
            }
            Button {
                withAnimation(Theme.motion(reduceMotion)) { expandsCalendar.toggle() }
            } label: {
                Image(systemName: expandsCalendar ? "chevron.up" : "chevron.down")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                    .frame(width: 44, height: 48)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(expandsCalendar ? Text("Hide meal previews") : Text("Show meal previews"))
        }
        .padding(.horizontal, Theme.Spacing.m)
        .padding(.vertical, Theme.Spacing.s)
        .background(Theme.cream)
        .sensoryFeedback(.selection, trigger: selectedDate)
    }

    private func dayMacros(_ date: Date) -> Macros {
        planStore.meals(on: date).reduce(.zero) { total, meal in
            guard let recipe = planStore.recipe(for: meal) else { return total }
            // Per person: one serving scaled by this meal's portion (portions follow the calorie target).
            let portion = meal.servings / max(1, profileStore.defaultServings)
            return total + planStore.repository.nutrition(for: recipe).macros.scaled(by: portion)
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
        if let day = activeDate {
            let date = day.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
            let count = planStore.meals(on: day).count
            SectionHeader(
                title: Calendar.current.isDateInToday(day) ? String(localized: "\(date) · today") : date,
                subtitle: count == 1 ? String(localized: "1 meal") : String(localized: "\(count) meals")
            )
            DayList(
                day: day,
                onOpen: { meal in
                    router.gate(isPro: isPro) { router.planPath.append(RecipeRoute(recipeId: meal.recipeId, plannedMealID: meal.ensurePlannerMealID())) }
                },
                onSwap: { meal in router.gate(isPro: isPro) { swapTarget = meal } },
                onAdd: { date, type in
                    router.gate(isPro: isPro) { addTarget = AddMealTarget(date: date, mealType: type) }
                }
            )
            Button {
                router.gate(isPro: isPro) { addTarget = AddMealTarget(date: day, mealType: nil) }
            } label: {
                Label("Add a side or extra", systemImage: "plus")
            }
            .buttonStyle(SecondaryButtonStyle(outlined: true))
            MacrosCard(macros: dayMacros(day), caption: String(localized: "Planned · per person"),
                       title: String(localized: "Macros · your day"), goal: profileStore.profile?.nutritionTarget?.calories)
        }
        GroceryShortcutCard(
            itemCount: planStore.groceryList.itemCount + planStore.extras.count,
            checkedCount: planStore.checkedCount + planStore.extras.filter { $0.isChecked }.count,
            estimate: planStore.basketEstimate.map { profileStore.formatMoney($0.amount) }
        ) {
            router.gate(isPro: isPro) { router.selectedTab = .groceries }
        }
        PlanActions(
            onEdit: { router.gate(isPro: isPro) { router.isWeekEditorPresented = true } },
            onRegenerate: { router.gate(isPro: isPro) { isRegenerateConfirmShown = true } }
        )
        .padding(.top, Theme.Spacing.s)
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
    let mealType: MealType?
    var id: String { "\(date.timeIntervalSince1970)-\(mealType?.rawValue ?? "side")" }
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
            Text("Meal Plan")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
                .accessibilityAddTraits(.isHeader)
            HStack(spacing: Theme.Spacing.inline) {
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
