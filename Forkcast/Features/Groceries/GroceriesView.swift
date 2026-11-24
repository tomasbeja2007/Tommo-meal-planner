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
    @State private var showDoneToast: Bool = false

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.groceriesPath) {
            Group {
                if planStore.groceryList.itemCount == 0 && planStore.extras.isEmpty {
                    EmptyState(
                        title: String(localized: "your list is empty"),
                        message: String(localized: "plan a few dinners and your groceries appear here, grouped by aisle."),
                        actionTitle: String(localized: "Go to my plan")
                    ) {
                        router.selectedTab = .plan
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    listContent
                }
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "Grocery list"))
            .toolbar { toolbarContent }
            .overlay(alignment: .bottom) {
                if showDoneToast {
                    ShopDoneToast()
                        .padding(.bottom, Theme.Spacing.l)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .sheet(isPresented: $isAddingExtra) {
            AddExtraSheet()
                .presentationDetents([.height(320)])
        }
        .onChange(of: planStore.allGroceriesChecked) { _, allDone in
            guard allDone else { return }
            Haptics.success()
            withAnimation(Theme.spring) { showDoneToast = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation(Theme.spring) { showDoneToast = false }
            }
        }
    }

    private var listContent: some View {
        List {
            Section {
                GroceryHeader()
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                Picker(String(localized: "Sort"), selection: $sortMode) {
                    ForEach(SortMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))
            }
            ExtrasSection { isAddingExtra = true }
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
            if !planStore.groceryList.pantryStaples.isEmpty {
                Section {
                    DisclosureGroup(isExpanded: $showsPantry) {
                        ForEach(planStore.groceryList.pantryStaples) { item in
                            GroceryRow(item: item)
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
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
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .animation(Theme.motion(reduceMotion), value: planStore.checkedKeys)
    }

    /// Checked rows move to the bottom of their section.
    private func ordered(_ items: [GroceryItem]) -> [GroceryItem] {
        let unchecked: [GroceryItem] = items.filter { !planStore.isChecked($0.key) }
        let checked: [GroceryItem] = items.filter { planStore.isChecked($0.key) }
        return unchecked + checked
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            ShareLink(item: planStore.shareText(title: shareTitle)) {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel(Text("Share grocery list"))
            Menu {
                Button(String(localized: "Uncheck all"), systemImage: "arrow.uturn.backward") {
                    withAnimation(Theme.spring) { planStore.uncheckAll() }
                }
                Button(String(localized: "Add item"), systemImage: "plus") { isAddingExtra = true }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .accessibilityLabel(Text("More"))
        }
    }

    private var shareTitle: String {
        String(localized: "Grocery list for \(profileStore.storeName)")
    }
}

/// Store, dates, total and progress ring.
private struct GroceryHeader: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        let total: Int = planStore.groceryList.itemCount
        let done: Int = planStore.checkedCount
        HStack(spacing: Theme.Spacing.l) {
            ProgressRing(value: total > 0 ? Double(done) / Double(total) : 0, lineWidth: 7, tint: done == total && total > 0 ? Theme.herb : Theme.tomato, label: "\(done) / \(total)")
                .frame(width: 72, height: 72)
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
                    .fixedSize(horizontal: false, vertical: true)
                MoneyText(amount: planStore.total, currencyCode: profileStore.currencyCode, font: .system(.title2, design: .rounded).weight(.bold), prefix: "~")
                    .fixedSize()
                Text("approx. total")
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineFaint)
            }
            Spacer(minLength: 0)
        }
        .cardStyle()
    }

    private var subtitle: String {
        var text: String = String(localized: "for \(profileStore.storeName)")
        if let plan = planStore.currentPlan {
            text += " · " + DateText.range(from: plan.weekStartDate, to: plan.weekEndDate)
        }
        return text
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
                .foregroundStyle(done == total ? Theme.herb : Theme.aubergineFaint)
        }
        .accessibilityElement(children: .combine)
    }
}

struct GroceryRow: View {
    let item: GroceryItem
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    var body: some View {
        let checked: Bool = planStore.isChecked(item.key)
        Button {
            withAnimation(Theme.spring) { planStore.toggleChecked(item.key) }
        } label: {
            HStack(alignment: .top, spacing: Theme.Spacing.m) {
                CheckCircle(isChecked: checked)
                Text(item.emoji)
                    .font(.title3)
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name.capitalizedFirst)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .strikethrough(checked, color: Theme.aubergineFaint)
                        .foregroundStyle(checked ? Theme.aubergineFaint : Theme.aubergine)
                    if !item.isPantryStaple {
                        Text(item.displayQuantity)
                            .font(.subheadline)
                            .foregroundStyle(checked ? Theme.aubergineFaint : Theme.aubergineMuted)
                    }
                    Text(item.neededText)
                        .font(.caption)
                        .foregroundStyle(Theme.aubergineFaint)
                    if !item.usedOnWeekdays.isEmpty {
                        Text(DateText.usedOn(item.usedOnWeekdays))
                            .font(.caption)
                            .foregroundStyle(Theme.aubergineFaint)
                    }
                }
                Spacer(minLength: 4)
                if item.hasPrice && !item.isPantryStaple {
                    Text("~" + profileStore.formatMoney(item.cost))
                        .font(.caption.weight(.semibold))
                        .monospacedDigit()
                        .foregroundStyle(Theme.aubergineFaint)
                }
            }
            .padding(.vertical, 4)
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
struct CheckCircle: View {
    let isChecked: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(isChecked ? Theme.herb : Theme.aubergineFaint, lineWidth: 2)
            if isChecked {
                Circle().fill(Theme.herb)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(Color.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 26, height: 26)
        .frame(width: 30, height: 44)
        .accessibilityHidden(true)
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
                .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 4)
        )
    }
}

#Preview { GroceriesView().previewEnvironment() }
