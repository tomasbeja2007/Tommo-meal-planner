import Foundation
import StoreKit
import Observation

/// StoreKit 2: products, purchases, entitlements and trial state.
/// Prices always come from StoreKit (`displayPrice`), never hard-coded.
@MainActor
@Observable
final class SubscriptionManager {
    static let yearlyId: String = "com.tomasbeja.tommo.pro.yearly"
    static let monthlyId: String = "com.tomasbeja.tommo.pro.monthly"
    static let productIds: [String] = [yearlyId, monthlyId]

    enum PurchaseOutcome {
        case success
        case pending
        case cancelled
        case failed(String)
    }

    private(set) var products: [Product] = []
    private(set) var isLoadingProducts: Bool = false
    private(set) var productLoadFailed: Bool = false
    private(set) var isPro: Bool = false
    private(set) var isInTrial: Bool = false
    private(set) var trialEndDate: Date? = nil
    private(set) var expirationDate: Date? = nil
    private(set) var activeProductId: String? = nil
    private(set) var isEligibleForTrial: Bool = false

    /// Debug-menu override, persisted so it survives relaunches (DEBUG builds only).
    private(set) var debugProOverride: Bool = UserDefaults.standard.bool(forKey: FeatureFlags.debugProOverrideKey)

    func setDebugProOverride(_ value: Bool) {
        debugProOverride = value
        UserDefaults.standard.set(value, forKey: FeatureFlags.debugProOverrideKey)
    }

    @ObservationIgnored private var updatesTask: Task<Void, Never>? = nil
    @ObservationIgnored private var entitlementRequest = 0
    @ObservationIgnored private var appliedEntitlementRequest = 0

    /// What the UI should use for gating.
    var hasProAccess: Bool {
        #if DEBUG
        return isPro || FeatureFlags.bypassPaywall || debugProOverride
        #else
        return isPro
        #endif
    }

    var yearly: Product? { products.first { $0.id == SubscriptionManager.yearlyId } }
    var monthly: Product? { products.first { $0.id == SubscriptionManager.monthlyId } }

    /// Call once at launch.
    func start() async {
        listenForTransactions()
        await refreshEntitlements()
        await loadProducts()
    }

    func loadProducts() async {
        guard !isLoadingProducts else { return }
        isLoadingProducts = true
        productLoadFailed = false
        isEligibleForTrial = false
        defer { isLoadingProducts = false }
        do {
            let loaded: [Product] = try await Product.products(for: SubscriptionManager.productIds)
            // The paywall labels these products as one month and one year.
            products = loaded.filter { product in
                guard product.type == .autoRenewable, let period = product.subscription?.subscriptionPeriod,
                      period.value == 1 else { return false }
                return (product.id == Self.yearlyId && period.unit == .year)
                    || (product.id == Self.monthlyId && period.unit == .month)
            }.sorted { $0.price > $1.price }
            productLoadFailed = products.isEmpty
            if let subscription = yearly?.subscription,
               subscription.introductoryOffer?.paymentMode == .freeTrial {
                isEligibleForTrial = await subscription.isEligibleForIntroOffer
            }
        } catch {
            productLoadFailed = true
        }
    }

    func purchase(_ product: Product) async -> PurchaseOutcome {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await refreshEntitlements()
                    await transaction.finish()
                    return isPro ? .success : .failed(String(localized: "Tommo Pro is still unavailable. Try Restore purchases."))
                case .unverified(_, let error):
                    return .failed(error.localizedDescription)
                }
            case .pending:
                return .pending
            case .userCancelled:
                return .cancelled
            @unknown default:
                return .cancelled
            }
        } catch {
            return .failed(error.localizedDescription)
        }
    }

    /// "Restore purchases".
    func restore() async throws {
        try await AppStore.sync()
        await refreshEntitlements()
    }

    func refreshEntitlements() async {
        entitlementRequest += 1
        let request = entitlementRequest
        var pro: Bool = false
        var trial: Bool = false
        var trialEnd: Date? = nil
        var expiry: Date? = nil
        var productId: String? = nil
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            guard SubscriptionManager.productIds.contains(transaction.productID),
                  transaction.revocationDate == nil, !transaction.isUpgraded else { continue }
            // StoreKit includes subscriptions in billing grace in currentEntitlements.
            pro = true
            guard productId == nil || (transaction.expirationDate ?? .distantPast) > (expiry ?? .distantPast) else { continue }
            productId = transaction.productID
            expiry = transaction.expirationDate
            trial = transaction.expirationDate.map { $0 > Date() } == true && isFreeTrial(transaction)
            trialEnd = trial ? expiry : nil
        }
        // A foreground refresh can overlap a purchase or transaction update.
        guard !Task.isCancelled, request > appliedEntitlementRequest else { return }
        appliedEntitlementRequest = request
        isPro = pro
        isInTrial = trial
        trialEndDate = trialEnd
        expirationDate = expiry
        activeProductId = productId
    }

    private func isFreeTrial(_ transaction: Transaction) -> Bool {
        if #available(iOS 17.2, *), let paymentMode = transaction.offer?.paymentMode {
            return paymentMode == .freeTrial
        }
        // Older clients can use the payment mode in the verified transaction payload.
        let payload = (try? JSONSerialization.jsonObject(with: transaction.jsonRepresentation)) as? [String: Any]
        return payload?["offerDiscountType"] as? String == "FREE_TRIAL"
    }

    private func listenForTransactions() {
        guard updatesTask == nil else { return }
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result,
                      Self.productIds.contains(transaction.productID) else { continue }
                await self?.refreshEntitlements()
                await transaction.finish()
            }
        }
    }

    // MARK: Display helpers

    /// "$3.33" for the yearly plan, from `price / 12` in the product's own format.
    func monthlyEquivalent(of product: Product) -> String {
        let perMonth: Decimal = product.price / Decimal(12)
        return perMonth.formatted(product.priceFormatStyle)
    }

    /// Percentage saved by yearly vs. 12 × monthly (e.g. 67).
    var yearlySavingsPercent: Int? {
        guard let yearly, let monthly else { return nil }
        let monthlyYear: Double = NSDecimalNumber(decimal: monthly.price).doubleValue * 12
        let yearlyPrice: Double = NSDecimalNumber(decimal: yearly.price).doubleValue
        guard monthlyYear > 0, yearlyPrice < monthlyYear else { return nil }
        return Int(((1 - yearlyPrice / monthlyYear) * 100).rounded())
    }

    /// Short status for the profile card.
    var statusText: String {
        if isInTrial, let end = trialEndDate {
            return String(localized: "Pro · trial ends \(end.formatted(.dateTime.day().month(.abbreviated)))")
        }
        if isPro { return String(localized: "Pro") }
        #if DEBUG
        if hasProAccess { return String(localized: "Pro (debug)") }
        #endif
        return String(localized: "Free")
    }
}
