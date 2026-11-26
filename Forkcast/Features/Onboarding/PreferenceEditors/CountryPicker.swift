import SwiftUI
import ForkcastCore

/// Searchable country list. US first, flag + currency badge.
struct CountryPicker: View {
    @Binding var selection: String
    var onPick: (() -> Void)? = nil
    @State private var query: String = ""

    private var countries: [Country] {
        let all: [Country] = FoodCatalog.bundled.countries
        let trimmed: String = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return all }
        return all.filter { $0.name.localizedCaseInsensitiveContains(trimmed) || $0.currencyCode.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            SearchField(text: $query, prompt: String(localized: "Search countries"))
            LazyVStack(spacing: Theme.Spacing.s) {
                ForEach(countries) { country in
                    CountryRow(country: country, isSelected: selection == country.id) {
                        selection = country.id
                        onPick?()
                    }
                }
            }
            if countries.isEmpty {
                Text("No country matches \"\(query)\". Pick the closest one for now.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
            }
        }
    }
}

private struct CountryRow: View {
    let country: Country
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.m) {
                Text(country.flagEmoji).font(.title2)
                Text(country.name)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                Spacer(minLength: Theme.Spacing.s)
                TagLabel(text: country.currencyCode)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.tomato)
                }
            }
            .padding(.horizontal, Theme.Spacing.l)
            .frame(minHeight: 56)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(isSelected ? Theme.tomatoSoft : Theme.card))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).stroke(isSelected ? Theme.tomato : Theme.line, lineWidth: isSelected ? 2 : 1))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

/// Rounded search field used across the app.
struct SearchField: View {
    @Binding var text: String
    var prompt: String

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.aubergineFaint)
            TextField(prompt, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(Theme.aubergine)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.aubergineFaint)
                }
                .accessibilityLabel(Text("Clear search"))
            }
        }
        .padding(.horizontal, Theme.Spacing.m)
        .frame(minHeight: 48)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).fill(Theme.card))
        .overlay(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).stroke(Theme.line, lineWidth: 1))
    }
}

#Preview {
    ScrollView { CountryPicker(selection: .constant("us")).padding() }.creamBackground()
}
