import SwiftUI
import ForkcastCore

/// 2-column grid of store tiles (coloured monogram, never a real logo).
struct StorePicker: View {
    let countryId: String
    @Binding var selection: String
    var onPick: (() -> Void)? = nil
    @State private var query: String = ""

    private var stores: [Store] {
        let all: [Store] = FoodCatalog.bundled.stores(forCountry: countryId)
        let trimmed: String = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return all }
        return all.filter { $0.name.localizedCaseInsensitiveContains(trimmed) || $0.isLocalStore }
    }

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: Theme.Spacing.m),
        GridItem(.flexible(), spacing: Theme.Spacing.m)
    ]

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            SearchField(text: $query, prompt: String(localized: "Search stores"))
            LazyVGrid(columns: columns, spacing: Theme.Spacing.m) {
                ForEach(stores) { store in
                    StoreTile(store: store, isSelected: selection == store.id) {
                        selection = store.id
                        onPick?()
                    }
                }
            }
        }
    }
}

struct StoreTile: View {
    let store: Store
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.s) {
                StoreMonogram(store: store, size: 52)
                Text(store.name)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Theme.Spacing.m)
            .frame(maxWidth: .infinity, minHeight: 116)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(isSelected ? Theme.tomatoSoft : Theme.card))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).stroke(isSelected ? Theme.tomato : Theme.line, lineWidth: isSelected ? 2 : 1))
            .overlay(alignment: .topTrailing) {
                if isSelected { CheckBadge().padding(8) }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityLabel(Text(store.name))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}

/// Initial letter on the store's colour. Placeholder for a logo we don't ship.
struct StoreMonogram: View {
    let store: Store
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle().fill(store.isLocalStore ? Theme.creamDeep : Color(hexString: store.brandColorHex))
            if store.isLocalStore {
                Image(systemName: "basket.fill")
                    .font(.system(size: size * 0.42, weight: .semibold))
                    .foregroundStyle(Theme.tomato)
            } else {
                Text(store.monogram)
                    .font(.system(size: size * 0.46, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.white)
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

#Preview {
    ScrollView { StorePicker(countryId: "us", selection: .constant("kroger")).padding() }.creamBackground()
}
