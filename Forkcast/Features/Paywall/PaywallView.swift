import SwiftUI
import StoreKit
import ForkcastCore

struct PaywallView: View {
    var onBack: (() -> Void)? = nil
    let onClose: () -> Void

    @Environment(SubscriptionManager.self) private var subscriptions: SubscriptionManager
    @Environment(NotificationManager.self) private var notifications: NotificationManager
    @Environment(ProfileStore.self) private var profileStore: ProfileStore
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var selectedId: String = SubscriptionManager.yearlyId
    @State private var isPurchasing: Bool = false
    @State private var errorMessage: String? = nil
    @State private var purchased: Bool = false
    @State private var revealedStage = 0

    private var selectedProduct: Product? {
        subscriptions.products.first { $0.id == selectedId } ?? subscriptions.products.first
    }

    private var trial: Product.SubscriptionOffer? {
        guard selectedProduct?.id == SubscriptionManager.yearlyId, subscriptions.isEligibleForTrial,
              let offer = selectedProduct?.subscription?.introductoryOffer, offer.paymentMode == .freeTrial else { return nil }
        return offer
    }

    private var offersTrial: Bool { trial != nil }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    // App Review 3.1.2: name the subscription.
                    Text("TOMMO PRO")
                        .font(Theme.Typography.eyebrow)
                        .tracking(1.2)
                        .foregroundStyle(Theme.tomatoDeep)
                        .padding(.bottom, -Theme.Spacing.m)
                    Text(headline)
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .foregroundStyle(Theme.aubergine)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityAddTraits(.isHeader)
                    VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                        PaywallBenefit(title: "Meals, planned your way", detail: "Recipes that fit your diet and kitchen.", continues: visible(2))
                            .modifier(PaywallEntrance(visible: visible(1)))
                        PaywallBenefit(title: "Plan around your budget", detail: "See estimated grocery costs before you shop.", continues: visible(3))
                            .modifier(PaywallEntrance(visible: visible(2)))
                        PaywallBenefit(title: "Shop once, waste less", detail: "One grocery list for the whole week.", featured: true)
                            .modifier(PaywallEntrance(visible: visible(3)))
                    }
                    planSelector
                        .modifier(PaywallEntrance(visible: visible(4)))
                    if let trial, let selectedProduct {
                        TrialTimeline(offer: trial, renewalPrice: selectedProduct.displayPrice, renewalPeriod: selectedProduct.subscription?.subscriptionPeriod)
                            .modifier(PaywallEntrance(visible: visible(5)))
                    }
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(Theme.tomatoDeep)
                    }
                    if dynamicTypeSize.isAccessibilitySize { bottomBar }
                }
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.top, Theme.Spacing.xxxl + Theme.Spacing.l)  // clears the close button
                .padding(.bottom, Theme.Spacing.l)
            }
            .safeAreaInset(edge: .bottom) {
                if !dynamicTypeSize.isAccessibilitySize { bottomBar }
            }

            Button(action: onBack ?? onClose) {
                Image(systemName: onBack == nil ? "xmark" : "chevron.left")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.aubergineMuted)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Theme.card.opacity(0.9)))
            }
            .disabled(isPurchasing)
            .padding(.leading, Theme.Spacing.m)
            .padding(.top, Theme.Spacing.s)
            .accessibilityLabel(onBack == nil ? Text("Close") : Text("Back"))

            // The paywall can always be closed (App Review). In onboarding the back arrow sits
            // on the left, so the close button goes top right.
            if onBack != nil {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.aubergineMuted)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.card.opacity(0.9)))
                }
                .disabled(isPurchasing)
                .padding(.trailing, Theme.Spacing.m)
                .padding(.top, Theme.Spacing.s)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .accessibilityLabel(Text("Close"))
            }
        }
        .background(Theme.cream.ignoresSafeArea())
        .sensoryFeedback(.success, trigger: purchased)
        .task {
            if subscriptions.products.isEmpty { await subscriptions.loadProducts() }
        }
        .task {
            guard !reduceMotion else {
                revealedStage = 6
                return
            }
            for (index, delay) in [230, 420, 400, 350, 250, 150].enumerated() where index >= revealedStage {
                do { try await Task.sleep(for: .milliseconds(delay)) }
                catch { return }
                withAnimation(.easeOut(duration: 0.21)) { revealedStage = index + 1 }
            }
        }
        .onChange(of: subscriptions.hasProAccess) { _, hasPro in
            if hasPro && !isPurchasing { onClose() }
        }
    }

    private func visible(_ stage: Int) -> Bool { reduceMotion || revealedStage >= stage }

    private var trialDuration: String? {
        guard let trial else { return nil }
        let length = trial.period.value * trial.periodCount
        let components: DateComponents
        switch trial.period.unit {
        case .day: components = DateComponents(day: length)
        case .week: components = DateComponents(weekOfMonth: length)
        case .month: components = DateComponents(month: length)
        case .year: components = DateComponents(year: length)
        @unknown default: return nil
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .weekOfMonth, .month, .year]
        formatter.unitsStyle = .full
        return formatter.string(from: components)
    }

    private var headline: String {
        if let trialDuration { return String(localized: "Try Tommo free for \(trialDuration)") }
        return String(localized: "Your entire week of meals, sorted.")
    }

    private var purchaseTitle: String {
        if let trialDuration { return String(localized: "Start free trial · \(trialDuration)") }
        return offersTrial ? String(localized: "Start free trial") : String(localized: "Subscribe")
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
                .buttonStyle(QuietButtonStyle(color: Theme.tomatoDeep))
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        } else {
            VStack(spacing: Theme.Spacing.m) {
                if let yearly = subscriptions.yearly {
                    PlanCard(
                        title: String(localized: "Yearly"),
                        badge: yearlyBadge,
                        trialBadge: trialDuration.map { String(localized: "\($0) free") },
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
            return String(localized: "SAVE \(percent)% VS MONTHLY")
        }
        return String(localized: "BEST VALUE")
    }

    private func yearlyDetail(_ product: Product) -> String {
        let perMonth: String = subscriptions.monthlyEquivalent(of: product)
        return String(localized: "\(perMonth)/mo, billed \(product.displayPrice) yearly")
    }

    // MARK: Bottom bar

    private var billingText: String? {
        guard let product = selectedProduct else { return nil }
        if product.id == SubscriptionManager.yearlyId {
            if let trialDuration {
                return String(localized: "\(trialDuration) free, then \(product.displayPrice) per year.")
            }
            if offersTrial {
                return String(localized: "Free trial, then \(product.displayPrice) per year.")
            }
            return String(localized: "\(product.displayPrice) per year.")
        }
        return String(localized: "\(product.displayPrice) per month.")
    }

    private var bottomBar: some View {
        VStack(spacing: Theme.Spacing.xs) {
            if let billingText {
                Text(billingText)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                Text("Renews automatically. Manage or cancel in Apple Subscriptions.")
                    .font(.footnote)
                    .foregroundStyle(Theme.aubergineMuted)
                    .multilineTextAlignment(.center)
            }
            Button(action: purchase) {
                HStack(spacing: Theme.Spacing.s) {
                    if isPurchasing { ProgressView().tint(Color.white) }
                    Text(purchaseTitle)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isPurchasing || selectedProduct == nil)
            .modifier(PaywallEntrance(visible: visible(6)))
            FlowLayout(spacing: Theme.Spacing.m) {
                Button(String(localized: "Restore")) {
                    guard !isPurchasing else { return }
                    isPurchasing = true
                    errorMessage = nil
                    Task {
                        defer { isPurchasing = false }
                        do {
                            try await subscriptions.restore()
                            if subscriptions.isPro {
                                onClose()
                            } else {
                                errorMessage = String(localized: "No active subscription found for this Apple Account.")
                            }
                        } catch {
                            errorMessage = String(localized: "Couldn’t restore purchases. \(error.localizedDescription)")
                        }
                    }
                }
                .disabled(isPurchasing)
                Link(String(localized: "Terms of Use"), destination: AppLinks.licenseAgreement)
                Link(String(localized: "Privacy"), destination: AppLinks.privacyPolicy)
            }
            .font(.caption)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Theme.aubergineMuted)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.top, Theme.Spacing.s)
        .padding(.bottom, Theme.Spacing.s)
        .background(Theme.cream.opacity(0.97).ignoresSafeArea())
    }

    private func purchase() {
        guard !isPurchasing, let product = selectedProduct else { return }
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
        guard notifications.isAuthorized, subscriptions.isInTrial, let end = subscriptions.trialEndDate else { return }
        let days: Int = profileStore.profile?.trialReminderDaysBefore ?? 1
        notifications.scheduleTrialReminder(trialEnd: end, daysBefore: days)
    }
}

private struct PaywallEntrance: ViewModifier {
    let visible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 7)
            .allowsHitTesting(visible)
            .accessibilityHidden(!visible)
    }
}

private struct PaywallBenefit: View {
    let title: LocalizedStringKey
    let detail: LocalizedStringKey
    var continues = false
    var featured = false

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(Color.white)
                .frame(width: 26, height: 26)
                .background(featured ? Theme.tomatoDeep : Theme.herb, in: Circle())
                .frame(maxHeight: .infinity, alignment: .top)
                .background(alignment: .top) {
                    Rectangle().fill(Theme.herb.opacity(0.35))
                        .frame(width: 1)
                        .padding(.bottom, -Theme.Spacing.l)
                        .scaleEffect(y: continues ? 1 : 0, anchor: .top)
                }
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(title).font(.system(.body, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.aubergine)
                Text(detail).font(.subheadline)
                    .foregroundStyle(Theme.aubergineMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
    }
}

private struct PlanCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let title: String
    let badge: String?
    var trialBadge: String? = nil
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
                        .padding(.horizontal, Theme.Spacing.s)
                        .padding(.vertical, Theme.Spacing.xs)
                        .background(Capsule().fill(Theme.saffron))
                        .padding(.bottom, Theme.Spacing.s)
                }
                HStack(alignment: .top, spacing: Theme.Spacing.m) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(isSelected ? Theme.tomato : Theme.aubergineFaint)
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        ViewThatFits(in: .horizontal) {
                            HStack {
                                planTitle
                                Spacer()
                                planPrice
                            }
                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                planTitle
                                planPrice
                            }
                        }
                        if let trialBadge {
                            Text(trialBadge)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.tomatoDeep)
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

    private var planTitle: some View {
        Text(title)
            .font(.system(.title3, design: .rounded).weight(.bold))
            .foregroundStyle(Theme.aubergine)
    }

    private var planPrice: some View {
        Text(price)
            .font(.system(.headline, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(Theme.aubergine)
    }
}

#Preview { PaywallView {}.previewEnvironment() }
