import SwiftUI

/// White rounded card with the soft Forkcast shadow.
struct Card<Content: View>: View {
    var padding: CGFloat = Theme.Spacing.l
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .cardStyle(padding: padding)
    }
}

#Preview("Card") {
    Card {
        VStack(alignment: .leading, spacing: Theme.Spacing.inline) {
            Text("Grocery list").font(.headline)
            Text("31 items · 0 checked").font(.subheadline).foregroundStyle(Theme.aubergineMuted)
        }
    }
    .padding()
    .creamBackground()
}
