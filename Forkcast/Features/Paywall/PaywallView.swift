import SwiftUI
import StoreKit
import ForkcastCore

struct PaywallView: View {
    let onClose: () -> Void

    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(ProfileStore.self) private var profileStore: ProfileStore

    @State private var selectedId: String = SubscriptionManager.yearlyId
    @State private var isPurchasing: Bool = false
    @State private var errorMessage: String? = nil
    @State private var isRedeemShown: Bool = false
    @State private var purchased: Bool = false

    private var selectedProduct: Product? {
        subscriptions.products.first { $0.id == selectedId } ?? subscriptions.products.first
    }

    private var trial: Product.SubscriptionOffer? {
        guard selectedProduct?.id == SubscriptionManager.yearlyId, subscriptions.isEligibleForTrial else { return nil }
        return selectedProduct?.subscription?.introductoryOffer
    }

    private var offersTrial: Bool { trial != nil }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    IngredientHero(height: 138)
                    Text("Your entire week of meals, sorted.")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.aubergine)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                        PaywallBenefit(text: String(localized: "a costed week for your shop"))
                        PaywallBenefit(text: String(localized: "one tidy grocery list"))
                        PaywallBenefit(text: String(localized: "recipes that fit your rules, with macros"))
                    }
                    planSelector
                    if let trial, let selectedProduct {
                        TrialTimeline(offer: trial, renewalPrice: selectedProduct.displayPrice)
                    }
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(Theme.tomatoDeep)
                    }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.xxl)
                .padding(.bottom, Theme.Spacing.l)
            }
            .safeAreaInset(edge: .bottom) { bottomBar }

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.aubergineMuted)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Theme.card.opacity(0.9)))
            }
            .padding(.leading, Theme.Spacing.m)
            .padding(.top, Theme.Spacing.s)
            .accessibilityLabel(Text("Close"))
        }
        .background(Theme.cream.ignoresSafeArea())
        .sensoryFeedback(.success, trigger: purchased)
        .offerCodeRedemption(isPresented: $isRedeemShown) { _ in
            Task { await subscriptions.refreshEntitlements() }
        }
        .task {
            if subscriptions.products.isEmpty { await subscriptions.loadProducts() }
        }
        .onChange(of: subscriptions.hasProAccess) { _, hasPro in
            if hasPro { onClose() }
        }
    }

    // MARK: Plans

    @ViewBuilder
    private var planSelector: some View {
        if subscriptions.isLoadingProducts && subscriptions.products.isEmpty {
            HStack {
                ProgressView().tint(Theme.tomato)
                Text("loading prices…").foregroundStyle(Theme.aubergineMuted)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        } else if subscriptions.products.isEmpty {
            VStack(spacing: Theme.Spacing.s) {
                Text("We couldn't load prices right now.")
                    .foregroundStyle(Theme.aubergineMuted)
                Button(String(localized: "Try again")) {
                    Task { await subscriptions.loadProducts() }
                }
                .buttonStyle(QuietButtonStyle(color: Theme.tomato))
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        } else {
            VStack(spacing: Theme.Spacing.m) {
                if let yearly = subscriptions.yearly {
                    PlanCard(
                        title: String(localized: "Yearly"),
                        badge: yearlyBadge,
                        price: yearly.displayPrice + String(localized: "/year"),
                        detail: yearlyDetail(yearly),
                        isSelected: selectedProduct?.id == yearly.id
                    ) { selectedId = yearly.id }
                }
                if let monthly = subscriptions.monthly {
                    PlanCard(
                        title: String(localized: "Monthly"),
                        badge: nil,
                        price: monthly.displayPrice + String(localized: "/month"),
                        detail: String(localized: "flexible, cancel anytime"),
                        isSelected: selectedProduct?.id == monthly.id
                    ) { selectedId = monthly.id }
                }
            }
        }
    }

    private var yearlyBadge: String {
        if let percent = subscriptions.yearlySavingsPercent {
            return String(localized: "BEST VALUE · \(percent)% off")
        }
        return String(localized: "BEST VALUE")
    }

    private func yearlyDetail(_ product: Product) -> String {
        let perMonth: String = subscriptions.monthlyEquivalent(of: product)
        return String(localized: "\(perMonth)/mo, billed \(product.displayPrice) yearly")
    }

    // MARK: Bottom bar

    private var bottomBar: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Button(action: purchase) {
                HStack(spacing: Theme.Spacing.s) {
                    if isPurchasing { ProgressView().tint(Color.white) }
                    Text(offersTrial ? String(localized: "Start free trial") : String(localized: "Subscribe"))
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isPurchasing || selectedProduct == nil)
            if offersTrial {
                Text("No payment due now")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.herb)
            } else if selectedProduct != nil {
                Text("Renews automatically. Manage or cancel in Apple Subscriptions.")
                    .font(.footnote)
                    .foregroundStyle(Theme.aubergineMuted)
                    .multilineTextAlignment(.center)
            }
            HStack(spacing: Theme.Spacing.m) {
                Button(String(localized: "Restore")) {
                    Task {
                        isPurchasing = true
                        errorMessage = nil
                        defer { isPurchasing = false }
                        do {
                            try await subscriptions.restore()
                            if !subscriptions.isPro {
                                errorMessage = String(localized: "No active subscription found for this Apple Account.")
                            }
                        } catch {
                            errorMessage = String(localized: "Couldn’t restore purchases. \(error.localizedDescription)")
                        }
                    }
                }
                .disabled(isPurchasing)
                Link(String(localized: "Terms"), destination: AppLinks.terms)
                Link(String(localized: "Privacy"), destination: AppLinks.privacyPolicy)
                Button(String(localized: "Have a code?")) { isRedeemShown = true }
            }
            .font(.caption)
            .foregroundStyle(Theme.aubergineMuted)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.top, Theme.Spacing.s)
        .padding(.bottom, Theme.Spacing.s)
        .background(Theme.cream.opacity(0.97).ignoresSafeArea())
    }

    private func purchase() {
        guard let product = selectedProduct else { return }
        isPurchasing = true
        errorMessage = nil
        Task {
            let outcome = await subscriptions.purchase(product)
            isPurchasing = false
            switch outcome {
            case .success:
                purchased = true
                scheduleTrialReminderIfNeeded()
                onClose()
            case .pending:
                errorMessage = String(localized: "Your purchase is waiting for approval.")
            case .cancelled:
                break
            case .failed(let message):
                errorMessage = message
            }
        }
    }

    /// The reminder screen promised this, so it must be scheduled.
    private func scheduleTrialReminderIfNeeded() {
        guard subscriptions.isInTrial, let end = subscriptions.trialEndDate else { return }
        let days: Int = profileStore.profile?.trialReminderDaysBefore ?? 1
        notifications.scheduleTrialReminder(trialEnd: end, daysBefore: days)
    }
}

private struct PaywallBenefit: View {
    let text: String

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(Color.white)
                .frame(width: 26, height: 26)
                .background(Circle().fill(Theme.herb))
                .accessibilityHidden(true)
            Text(text)
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.aubergine)
        }
    }
}

private struct PlanCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let title: String
    let badge: String?
    let price: String
    let detail: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                if let badge {
                    Text(badge)
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(Theme.aubergine)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Theme.saffron))
                        .padding(.bottom, Theme.Spacing.s)
                }
                HStack(alignment: .top, spacing: Theme.Spacing.m) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(isSelected ? Theme.tomato : Theme.aubergineFaint)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(title)
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(Theme.aubergine)
                            Spacer()
                            Text(price)
                                .font(.system(.headline, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(Theme.aubergine)
                        }
                        Text(detail)
                            .font(.subheadline)
                            .foregroundStyle(Theme.aubergineMuted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(Theme.Spacing.l)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).fill(isSelected ? Theme.tomatoSoft : Theme.card))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous).stroke(isSelected ? Theme.tomato : Theme.line, lineWidth: isSelected ? 2 : 1))
        }
        .buttonStyle(.plain)
        .animation(reduceMotion ? nil : Theme.Motion.update, value: isSelected)
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}

private struct TrialTimeline: View {
    let offer: Product.SubscriptionOffer
    let renewalPrice: String

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
            Label("Today · Full access, no payment due", systemImage: "lock.open")
            if let renewalDate {
                let date = renewalDate.formatted(date: .abbreviated, time: .omitted)
                Label("Estimated first charge on \(date) · \(renewalPrice) per year", systemImage: "calendar")
            } else {
                Label("After the trial · \(renewalPrice) per year", systemImage: "calendar")
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
}

#Preview { PaywallView {}.previewEnvironment() }
