import SwiftUI
import ForkcastCore

/// One consolidated list, derived from the current plan. Only checks persist.
struct GroceriesView: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    enum SortMode: String, CaseIterable, Identifiable {
        case aisle
        case alphabetical

        var id: String { rawValue }
        var title: String { self == .aisle ? String(localized: "Aisle") : String(localized: "A–Z") }
    }

    @State private var sortMode: SortMode = .aisle
    @State private var showsPantry: Bool = false
    @State private var isAddingExtra: Bool = false
    @State private var activeListID: String?
    @State private var showsCompare = false
    @AccessibilityFocusState private var compareFocused: Bool
    @State private var isCreatingList = false
    @State private var listName = ""
    @State private var showDoneToast: Bool = false

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.groceriesPath) {
            VStack(spacing: 0) {
                ScreenTitleBar(String(localized: "Groceries")) { headerActions }
                    .padding(.horizontal, Theme.Spacing.gutter)
                listSelectors
                if activeListID == nil {
                    listContent
                } else {
                    List {
                        if planStore.extras(for: activeListID).isEmpty {
                            Text("Add items to start this list.")
                                .foregroundStyle(Theme.aubergineMuted)
                                .listRowBackground(Theme.card)
                        } else {
                            ExtrasSection(listID: activeListID)
                        }
                        addRow
                    }
                    .scrollContentBackground(.hidden)
                    .contentMargins(.bottom, Theme.Size.tabBarClearance, for: .scrollContent)
                }
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "Groceries"))
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .bottom) {
                if activeListID == nil && showDoneToast && planStore.allGroceriesChecked {
                    ShopDoneToast()
                        .padding(.bottom, Theme.Spacing.l)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .sheet(isPresented: $isAddingExtra) {
            AddExtraSheet(listID: activeListID)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showsCompare, onDismiss: { compareFocused = true }) {
            StoreComparisonSheet()
                .presentationDetents([.fraction(0.62), .large])
                .presentationDragIndicator(.visible)
        }
        .alert("New grocery list", isPresented: $isCreatingList) {
            TextField("List name", text: $listName)
            Button("Cancel", role: .cancel) {}
            Button("Create") {
                if let id = planStore.createGroceryCollection(listName) { activeListID = id }
            }
            .disabled(listName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .onChange(of: planStore.allGroceriesChecked) { _, allDone in
            if allDone { Haptics.success() }
            withAnimation(reduceMotion ? nil : Theme.Motion.update) { showDoneToast = allDone }
        }
        .task(id: showDoneToast) {
            guard showDoneToast else { return }
            try? await Task.sleep(for: .seconds(2.8))
            guard !Task.isCancelled else { return }
            withAnimation(reduceMotion ? nil : Theme.Motion.update) { showDoneToast = false }
        }
        .onDisappear { showDoneToast = false }
    }

    private var listSelectors: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.s) {
                Chip(title: String(localized: "Main list"), isSelected: activeListID == nil) { activeListID = nil }
                Chip(title: String(localized: "Usuals"), isSelected: activeListID == PlanStore.usualsListID) {
                    activeListID = PlanStore.usualsListID
                }
                ForEach(planStore.groceryCollections, id: \.id) { list in
                    Chip(title: list.title, isSelected: activeListID == list.id) { activeListID = list.id }
                }
                Chip(title: String(localized: "+ New"), isSelected: false) {
                    listName = ""
                    isCreatingList = true
                }
            }
            .padding(.horizontal, Theme.Spacing.gutter)
            .padding(.vertical, Theme.Spacing.s)
        }
    }

    private var addRow: some View {
        Button { isAddingExtra = true } label: {
            Label("Add groceries", systemImage: "plus")
                .font(.body.weight(.semibold))
                .frame(minHeight: 44)
        }
        .foregroundStyle(Theme.tomatoDeep)
        .listRowBackground(Theme.card)
    }

    private var listContent: some View {
        List {
            Section {
                GroceryHeader(compareFocused: $compareFocused) { showsCompare = true }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: Theme.Spacing.xs, leading: 0, bottom: Theme.Spacing.xs, trailing: 0))
                Picker(String(localized: "Sort"), selection: $sortMode) {
                    ForEach(SortMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: Theme.Spacing.xs, leading: 0, bottom: Theme.Spacing.s, trailing: 0))
            }
            if !planStore.extras.isEmpty { ExtrasSection() }
            if sortMode == .aisle {
                ForEach(planStore.groceryList.sections) { section in
                    Section {
                        ForEach(ordered(section.items)) { item in
                            GroceryRow(item: item)
                        }
                    } header: {
                        AisleHeader(aisle: section.aisle, done: section.items.filter { planStore.isChecked($0.key) }.count, total: section.items.count)
                    }
                }
            } else {
                Section {
                    ForEach(ordered(planStore.groceryList.allItems.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })) { item in
                        GroceryRow(item: item)
                    }
                }
            }
            if planStore.groceryList.itemCount == 0 && planStore.extras.isEmpty {
                Text("Plan a meal or add groceries to start your list.")
                    .foregroundStyle(Theme.aubergineMuted)
                    .listRowBackground(Theme.card)
            }
            if !planStore.groceryList.pantryStaples.isEmpty {
                Section {
                    DisclosureGroup(isExpanded: $showsPantry) {
                        ForEach(planStore.groceryList.pantryStaples) { item in
                            GroceryRow(item: item)
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                            Text("Pantry staples")
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(Theme.aubergine)
                            Text("you probably have these")
                                .font(.caption)
                                .foregroundStyle(Theme.aubergineMuted)
                        }
                    }
                    .tint(Theme.aubergineMuted)
                }
                .listRowBackground(Theme.card)
            }
            Section { addRow }
        }
        .listStyle(.insetGrouped)
        .listSectionSpacing(.compact)
        .contentMargins(.top, Theme.Spacing.xs, for: .scrollContent)
        .contentMargins(.bottom, Theme.Size.tabBarClearance, for: .scrollContent)
        .scrollContentBackground(.hidden)
        .animation(Theme.motion(reduceMotion), value: planStore.checkedKeys)
    }

    /// Checked rows move to the bottom of their section.
    private func ordered(_ items: [GroceryItem]) -> [GroceryItem] {
        let unchecked: [GroceryItem] = items.filter { !planStore.isChecked($0.key) }
        let checked: [GroceryItem] = items.filter { planStore.isChecked($0.key) }
        return unchecked + checked
    }

    /// "Share" pill and the more menu, on the title row.
    private var headerActions: some View {
        HStack(spacing: Theme.Spacing.s) {
            ShareLink(item: planStore.shareText(title: shareTitle, listID: activeListID)) {
                Label(String(localized: "Share"), systemImage: "square.and.arrow.up")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.tomatoDeep)
                    .padding(.horizontal, Theme.Spacing.l)
                    .frame(minHeight: Theme.Size.tapTarget)
                    .background(Capsule().fill(Theme.tomatoSoft))
            }
            .accessibilityLabel(Text("Share grocery list"))
            Menu {
                if activeListID == nil {
                    Button(String(localized: "Uncheck all"), systemImage: "arrow.uturn.backward") {
                        withAnimation(reduceMotion ? nil : Theme.Motion.update) { planStore.uncheckAll() }
                    }
                }
                Button(String(localized: "Add item"), systemImage: "plus") { isAddingExtra = true }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.body.weight(.bold))
                    .foregroundStyle(Theme.tomatoDeep)
                    .frame(width: Theme.Size.iconButton, height: Theme.Size.iconButton)
                    .background(Circle().fill(Theme.tomatoSoft))
            }
            .accessibilityLabel(Text("More"))
        }
    }

    private var shareTitle: String {
        switch activeListID {
        case nil: return String(localized: "Grocery list for \(profileStore.storeName)")
        case PlanStore.usualsListID: return String(localized: "Usuals")
        default: return planStore.groceryCollections.first { $0.id == activeListID }?.title ?? String(localized: "Groceries")
        }
    }
}

private struct GroceryHeader: View {
    let compareFocused: AccessibilityFocusState<Bool>.Binding
    let onCompare: () -> Void
    @Environment(PlanStore.self) private var planStore
    @Environment(ProfileStore.self) private var profileStore

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                HStack(alignment: .firstTextBaseline) {
                    if let estimate = planStore.basketEstimate {
                        MoneyText(amount: estimate.amount, currencyCode: profileStore.currencyCode, font: .system(.largeTitle, design: .rounded).weight(.bold), color: isOver ? Theme.tomatoDeep : Theme.aubergine)
                            .accessibilityLabel(Text("Estimated total \(profileStore.formatMoney(estimate.amount))"))
                    } else {
                        Text(planStore.hasPlan ? "Full estimate unavailable" : "No planned groceries")
                            .font(.headline)
                            .foregroundStyle(Theme.aubergineMuted)
                    }
                    Spacer(minLength: Theme.Spacing.s)
                    if planStore.budget > 0 {
                        Text("Your budget: \(profileStore.formatMoney(planStore.budget))")
                            .font(.subheadline)
                            .foregroundStyle(Theme.aubergineMuted)
                            .multilineTextAlignment(.trailing)
                    }
                }
                if let estimate = planStore.basketEstimate, let budget = GroceryEstimate(planStore.budget), budget.amount > 0 {
                    ProgressBar(value: min(estimate.amount / budget.amount, 1),
                                tint: isOver ? Theme.tomatoDeep : Theme.herb, height: 8)
                }
                HStack(alignment: .center, spacing: Theme.Spacing.s) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        if let status = budgetStatus {
                            Text(status)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(isOver ? Theme.tomatoDeep : Theme.herb)
                        }
                        storeLabel
                    }
                    Spacer(minLength: Theme.Spacing.s)
                    if let store = profileStore.store {
                        StoreMonogram(store: store, size: 40)
                            .accessibilityHidden(true)
                    }
                    compareButton
                }
            }
            .cardStyle()
            if let plan = planStore.currentPlan {
                let count = planStore.groceryList.itemCount + planStore.extras.count
                let range = DateText.range(from: plan.weekStartDate, to: plan.weekEndDate)
                (Text("\(count) items · ").foregroundStyle(Theme.aubergineMuted) + Text(range).foregroundStyle(Theme.tomatoDeep))
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, Theme.Spacing.xs)
            }
        }
    }

    private var difference: Double? {
        guard let estimate = planStore.basketEstimate, let budget = GroceryEstimate(planStore.budget), budget.amount > 0 else { return nil }
        return estimate.difference(from: budget)
    }

    private var isOver: Bool { (difference ?? 0) > 0 }

    private var budgetStatus: String? {
        guard let difference else { return nil }
        let delta = profileStore.formatMoney(abs(difference))
        if difference > 0 { return String(localized: "Over budget by \(delta)") }
        if difference < 0 { return String(localized: "\(delta) under budget") }
        return String(localized: "On budget")
    }

    private var storeLabel: some View {
        Text("Shopping at \(profileStore.store?.name ?? profileStore.storeName)")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Theme.aubergine)
            .lineLimit(1)
            .minimumScaleFactor(0.85)
    }

    private var compareButton: some View {
        Button(action: onCompare) {
            HStack(spacing: Theme.Spacing.xxs) {
                Text("Compare")
                Image(systemName: "chevron.right").font(.caption.weight(.bold))
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Theme.tomatoDeep)
            .padding(.horizontal, Theme.Spacing.m)
            .frame(minHeight: 40)
            .background(Capsule().fill(Theme.tomatoSoft))
        }
        .buttonStyle(.plain)
        .disabled(!planStore.hasPlan)
        .opacity(planStore.hasPlan ? 1 : 0.5)
        .accessibilityFocused(compareFocused)
    }
}

private struct StoreComparisonSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PlanStore.self) private var planStore
    @Environment(ProfileStore.self) private var profileStore
    @State private var estimates: [String: GroceryEstimate] = [:]

    private var yourStores: [Store] { profileStore.stores }
    private var otherStores: [Store] {
        let selected = Set(yourStores.map(\.id))
        return planStore.catalog.stores(forCountry: profileStore.country.id).filter { !selected.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            List {
                Text("Compare your weekly shop at your stores and other local options.")
                    .foregroundStyle(Theme.aubergineMuted)
                    .listRowBackground(Color.clear)
                if !yourStores.isEmpty {
                    Section("Your stores") { ForEach(yourStores) { row($0) } }
                }
                if !otherStores.isEmpty {
                    Section("Other stores") { ForEach(otherStores) { row($0) } }
                }
                Text("One store for your whole planned list. Unpriced extras are excluded from all estimates.")
                    .font(.footnote)
                    .foregroundStyle(Theme.aubergineMuted)
                    .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream)
            .navigationTitle("Compare stores")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
        .task {
            for store in yourStores + otherStores {
                estimates[store.id] = planStore.estimatedBasket(for: store)
            }
        }
    }

    private func row(_ store: Store) -> some View {
        HStack(spacing: Theme.Spacing.m) {
            StoreMonogram(store: store, size: 36)
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(store.name).font(.headline).foregroundStyle(Theme.aubergine)
                if let price = estimates[store.id], let best = estimates.values.min() {
                    let difference = price.difference(from: best)
                    if difference == 0 {
                        Label("Best price", systemImage: "checkmark")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.herb)
                    } else if let relative = price.relativeDifference(from: best) {
                        let percent = relative.formatted(.percent.precision(.fractionLength(0)))
                        Text("+\(profileStore.formatMoney(difference)) · \(percent) more")
                            .font(.caption)
                            .foregroundStyle(Theme.aubergineMuted)
                    }
                } else {
                    Text("Full estimate unavailable").font(.caption).foregroundStyle(Theme.aubergineMuted)
                }
            }
            Spacer(minLength: Theme.Spacing.xs)
            if let price = estimates[store.id] {
                Text(profileStore.formatMoney(price.amount)).font(.subheadline.weight(.bold)).monospacedDigit()
            }
        }
        .listRowBackground(Theme.card)
        .accessibilityElement(children: .combine)
    }
}

private struct AisleHeader: View {
    let aisle: Aisle
    let done: Int
    let total: Int

    var body: some View {
        HStack {
            Text("\(aisle.emoji) \(aisle.displayName)")
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
                .textCase(nil)
            Spacer()
            Text("\(done)/\(total)")
                .font(.caption.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(done == total ? Theme.herb : Theme.aubergineMuted)
        }
        .accessibilityElement(children: .combine)
    }
}

struct GroceryRow: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    let item: GroceryItem
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        let checked: Bool = planStore.isChecked(item.key)
        Button {
            withAnimation(reduceMotion ? nil : Theme.Motion.update) { planStore.toggleChecked(item.key) }
        } label: {
            HStack(alignment: .center, spacing: Theme.Spacing.m) {
                CheckCircle(isChecked: checked)
                // A big photo, like a shelf label: easy to spot in the shop.
                IngredientThumbnail(ingredientID: item.ingredientId, size: 60, showsBackground: false)
                    .opacity(checked ? 0.45 : 1)
                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text(item.name.capitalizedFirst)
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .strikethrough(checked, color: Theme.aubergineFaint)
                        .foregroundStyle(checked ? Theme.aubergineFaint : Theme.aubergine)
                        .fixedSize(horizontal: false, vertical: true)
                    if !item.isPantryStaple {
                        Text(item.displayQuantity)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(checked ? Theme.aubergineFaint : Theme.aubergineMuted)
                    } else {
                        Text(item.neededText)
                            .font(.caption)
                            .foregroundStyle(checked ? Theme.aubergineFaint : Theme.aubergineMuted)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .trailing, spacing: Theme.Spacing.xs) {
                    let recipes = planStore.recipesByGroceryKey[item.key] ?? []
                    if !recipes.isEmpty {
                        // The meals it's for, as small overlapping plates.
                        HStack(spacing: -Theme.Spacing.m) {
                            ForEach(recipes.prefix(3)) { recipe in
                                DishTileView(recipe: recipe, size: 30)
                                    .clipShape(Circle())
                                    .overlay(Circle().strokeBorder(Theme.card, lineWidth: 2))
                            }
                            if recipes.count > 3 {
                                Text("+\(recipes.count - 3)")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(Theme.aubergineMuted)
                                    .padding(.leading, Theme.Spacing.m)
                            }
                        }
                        .opacity(checked ? 0.45 : 1)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text(recipes.map(\.title).formatted(.list(type: .and))))
                    }
                    if item.hasPrice && !item.isPantryStaple {
                        Text("~" + profileStore.formatMoney(item.cost))
                            .font(.caption.weight(.semibold))
                            .monospacedDigit()
                            .foregroundStyle(checked ? Theme.aubergineFaint : Theme.aubergineMuted)
                    }
                }
            }
            .frame(minHeight: 72)
            .padding(.vertical, Theme.Spacing.xs)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(Theme.card)
        .sensoryFeedback(.selection, trigger: checked)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(checked ? [.isButton, .isSelected] : [.isButton])
        .accessibilityHint(Text(checked ? "Double tap to uncheck" : "Double tap to check off"))
    }
}

/// Herb-filled circle with a white check when done.
/// Checking: the fill opens out from 70% (never from 0) and the tick draws itself on with ease-out.
/// Unchecking is faster than checking (exits are faster than entrances). Reduce Motion: instant.
struct CheckCircle: View {
    let isChecked: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(isChecked ? Theme.herb : Theme.aubergineFaint, lineWidth: 2)
            Circle()
                .fill(Theme.herb)
                .scaleEffect(isChecked ? 1 : 0.7)
                .opacity(isChecked ? 1 : 0)
            TickShape()
                .trim(from: 0, to: isChecked ? 1 : 0)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
                .frame(width: 12, height: 10)
                .animation(reduceMotion ? nil : (isChecked ? Animation.open(0.26).delay(0.06) : .easeIn(duration: 0.12)), value: isChecked)
        }
        .animation(reduceMotion ? nil : (isChecked ? Animation.open(0.22) : .easeIn(duration: 0.14)), value: isChecked)
        .frame(width: 26, height: 26)
        .frame(width: 30, height: 44)
        .accessibilityHidden(true)
    }
}

/// A hand-drawn-feeling tick, drawn from the short stroke into the long one so `trim` reads as writing.
private struct TickShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY + rect.height * 0.05))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.36, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return p
    }
}

private struct ShopDoneToast: View {
    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            MascotView(size: 48, mood: .cheer)
            Text("shop done!")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.aubergine)
        }
        .padding(.horizontal, Theme.Spacing.l)
        .padding(.vertical, Theme.Spacing.s)
        .background(
            Capsule()
                .fill(Theme.card)
                .elevation(Theme.Elevation.lifted)
        )
    }
}

#Preview { GroceriesView().previewEnvironment() }
