import SwiftUI

/// User-added items at the top of the list.
struct ExtrasSection: View {
    let onAdd: () -> Void
    @Environment(PlanStore.self) private var planStore: PlanStore

    var body: some View {
        Section {
            ForEach(planStore.extras) { extra in
                Button {
                    withAnimation(Theme.spring) { planStore.toggleExtra(extra) }
                } label: {
                    HStack(spacing: Theme.Spacing.m) {
                        CheckCircle(isChecked: extra.isChecked)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(extra.name)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .strikethrough(extra.isChecked, color: Theme.aubergineFaint)
                                .foregroundStyle(extra.isChecked ? Theme.aubergineFaint : Theme.aubergine)
                            if !extra.quantityText.isEmpty {
                                Text(extra.quantityText)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.aubergineMuted)
                            }
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowBackground(Theme.card)
                .swipeActions {
                    Button(role: .destructive) {
                        planStore.deleteExtra(extra)
                    } label: {
                        Label(String(localized: "Delete"), systemImage: "trash")
                    }
                }
            }
            Button(action: onAdd) {
                Label(String(localized: "Add item"), systemImage: "plus")
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.tomato)
                    .frame(minHeight: 44)
            }
            .listRowBackground(Theme.card)
        } header: {
            Text("Extras")
                .font(.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
                .textCase(nil)
        }
    }
}

/// Name + optional quantity.
struct AddExtraSheet: View {
    @Environment(PlanStore.self) private var planStore: PlanStore
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State private var name: String = ""
    @State private var quantity: String = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            Text("add an item")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
            TextField(String(localized: "Item, e.g. coffee"), text: $name)
                .focused($focused)
                .submitLabel(.next)
                .padding(.horizontal, Theme.Spacing.l)
                .frame(minHeight: 50)
                .background(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).fill(Theme.card))
            TextField(String(localized: "Quantity (optional)"), text: $quantity)
                .padding(.horizontal, Theme.Spacing.l)
                .frame(minHeight: 50)
                .background(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).fill(Theme.card))
                .submitLabel(.done)
                .onSubmit(save)
            PrimaryButton(String(localized: "Add to list"), action: save)
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(Theme.Spacing.gutter)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Theme.cream.ignoresSafeArea())
        .onAppear { focused = true }
    }

    private func save() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        planStore.addExtra(name: name, quantity: quantity)
        dismiss()
    }
}

#Preview { AddExtraSheet().previewEnvironment() }
