import SwiftUI
import StoreKit

/// Trial dates and renewal terms for the offer selected in the paywall.
struct TrialTimeline: View {
    let offer: Product.SubscriptionOffer
    let renewalPrice: String
    let renewalPeriod: Product.SubscriptionPeriod?

    private var renewalTerms: String {
        guard let period = renewalPeriod else { return renewalPrice }
        let components: DateComponents
        switch period.unit {
        case .day: components = DateComponents(day: period.value)
        case .week: components = DateComponents(weekOfMonth: period.value)
        case .month: components = DateComponents(month: period.value)
        case .year: components = DateComponents(year: period.value)
        @unknown default: return renewalPrice
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .weekOfMonth, .month, .year]
        formatter.unitsStyle = .full
        guard let interval = formatter.string(from: components) else { return renewalPrice }
        return String(localized: "\(renewalPrice) every \(interval)")
    }

    private var renewalDate: Date? {
        let component: Calendar.Component
        switch offer.period.unit {
        case .day: component = .day
        case .week: component = .weekOfYear
        case .month: component = .month
        case .year: component = .year
        @unknown default: return nil
        }
        return Calendar.current.date(byAdding: component, value: offer.period.value * offer.periodCount, to: Date.now)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            timelineRow(title: String(localized: "Due today"), amount: offer.displayPrice, symbol: "lock.open")
            if let renewalDate {
                let date = renewalDate.formatted(date: .abbreviated, time: .omitted)
                timelineRow(title: String(localized: "Estimated charge on \(date)"), amount: renewalTerms, symbol: "calendar")
            } else {
                timelineRow(title: String(localized: "After the trial"), amount: renewalTerms, symbol: "calendar")
            }
            Text("Renews automatically. To avoid a charge, cancel in Apple Subscriptions before the trial ends.")
                .font(.footnote)
                .foregroundStyle(Theme.aubergineMuted)
        }
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(Theme.aubergine)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func timelineRow(title: String, amount: String, symbol: String) -> some View {
        Label {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(title)
                Text(amount)
                    .fontWeight(.bold)
                    .monospacedDigit()
            }
        } icon: {
            Image(systemName: symbol)
                .frame(width: 30)
                .foregroundStyle(Theme.tomatoDeep)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
    }
}
