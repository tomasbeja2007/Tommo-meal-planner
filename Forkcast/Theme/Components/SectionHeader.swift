import SwiftUI

/// Rounded section title with an optional trailing action.
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                Text(title)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                }
            }
            Spacer(minLength: Theme.Spacing.s)
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Theme.tomatoDeep)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isHeader)
    }
}

/// Tab screen title: the big rounded title and the screen's actions on one row, like the Meal Plan tab.
/// Used instead of the system large title, which leaves an empty toolbar row above the title.
struct ScreenTitleBar<Trailing: View>: View {
    let title: String
    @ViewBuilder let trailing: () -> Trailing

    init(_ title: String, @ViewBuilder trailing: @escaping () -> Trailing) {
        self.title = title
        self.trailing = trailing
    }

    var body: some View {
        HStack(alignment: .center, spacing: Theme.Spacing.m) {
            Text(title)
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.aubergine)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: Theme.Spacing.s)
            trailing()
        }
        .padding(.top, Theme.Spacing.s)
        .frame(minHeight: Theme.Size.tapTarget)
    }
}

extension ScreenTitleBar where Trailing == EmptyView {
    init(_ title: String) {
        self.init(title) { EmptyView() }
    }
}

#Preview("Section header") {
    SectionHeader(title: "Your vibes", subtitle: "picked for you", actionTitle: "See all") {}
        .padding()
        .creamBackground()
}
