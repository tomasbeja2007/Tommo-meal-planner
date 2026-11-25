import SwiftUI
import ForkcastCore

/// 2-column grid of store tiles. Pick as many shops as you like; the first one
/// picked is the main shop and sets prices. Tiles show a logo only when the asset
/// "store-<id>" exists (with the store's permission), otherwise a coloured monogram.
struct StorePicker: View {
    let countryId: String
    /// Picked shops in order, main shop first.
    @Binding var selection: [String]
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
                    StoreTile(
                        store: store,
                        isSelected: selection.contains(store.id),
                        isMain: selection.count > 1 && selection.first == store.id
                    ) {
                        toggle(store.id)
                    }
                }
            }
        }
    }

    private func toggle(_ id: String) {
        if let index = selection.firstIndex(of: id) {
            selection.remove(at: index)
        } else {
            selection.append(id)
        }
    }
}

struct StoreTile: View {
    let store: Store
    let isSelected: Bool
    /// Shown only when several shops are picked: this one sets prices.
    var isMain: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.s) {
                StoreLogo(store: store, height: 56)
                if store.isLocalStore {
                    Text(store.name)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if isMain {
                    Text("main shop")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Theme.tomatoDeep)
                }
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
        .accessibilityLabel(isMain ? Text("\(store.name), main shop") : Text(store.name))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}

/// The store's logo if the asset "store-<id>" exists, otherwise its initial on the store's colour.
/// Only add a logo asset once the retailer has given permission (see Design/IMAGE_REQUESTS.md).
struct StoreMonogram: View {
    let store: Store
    var size: CGFloat = 44

    private var logoName: String { "store-" + store.id }

    var body: some View {
        if !store.isLocalStore, AssetImage.exists(logoName) {
            Image(logoName)
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .padding(size * 0.14)
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
                .clipShape(Circle())
                .overlay(Circle().stroke(Theme.line, lineWidth: 1))
                .accessibilityHidden(true)
        } else {
            monogram
        }
    }

    private var monogram: some View {
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
    ScrollView { StorePicker(countryId: "us", selection: .constant(["kroger", "aldi"])).padding() }.creamBackground()
}

/// A wide logo tile for a supermarket: the real logo when the asset "store-<id>" exists
/// (added once the retailer allows it), otherwise the store's name set in its brand colour,
/// so every shop reads as a brand, never as a generic icon. The local-shop option keeps its basket.
struct StoreLogo: View {
    let store: Store
    var height: CGFloat = 56

    private var logoName: String { "store-" + store.id }

    var body: some View {
        Group {
            if store.isLocalStore {
                StoreMonogram(store: store, size: height)
            } else if AssetImage.exists(logoName) {
                Image(logoName)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .padding(.horizontal, 6)
                    .frame(maxWidth: .infinity, maxHeight: height)
            } else {
                Text(store.name)
                    .font(.system(size: height * 0.34, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hexString: store.brandColorHex))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity, maxHeight: height)
            }
        }
        .frame(height: height)
        .accessibilityHidden(true)
    }
}
