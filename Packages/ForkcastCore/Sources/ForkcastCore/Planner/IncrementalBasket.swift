import Foundation

/// Uses the same pack rounding as the grocery list. Candidate comparisons only
/// touch the ingredients that change and leave display quantities to the final list.
struct IncrementalBasket {
    struct Quantity {
        var packs: Double = 0
        var uses: Int = 0
    }

    struct Addition {
        var cost: Double = 0
        var freshReuse: Double = 0
        var shared: Double = 0
        var freshShared: Double = 0
        var freshIngredient: String?
    }

    let prices: [String: Double]
    let onHand: Set<String>
    private var quantities: [String: Quantity] = [:]
    private(set) var total: Double = 0

    init(prices: [String: Double], onHand: Set<String>) {
        self.prices = prices
        self.onHand = onHand
    }

    mutating func add(_ items: [IngredientUse], servings: Double, removing: Bool = false) {
        let sign = removing ? -1 : 1
        for item in items where !onHand.contains(item.id) {
            let old = quantities[item.id, default: Quantity()]
            let new = Quantity(packs: old.packs + Double(sign) * servings * item.packsPerServing, uses: old.uses + sign)
            total += cost(item, new) - cost(item, old)
            quantities[item.id] = new.uses > 0 ? new : nil
        }
    }

    func addition(_ items: [IngredientUse], servings: Double) -> Addition {
        var result = Addition()
        var largestReuse = 0.0
        for item in items where !onHand.contains(item.id) {
            let old = quantities[item.id, default: Quantity()]
            let needed = item.packsPerServing * servings
            let change = cost(item, Quantity(packs: old.packs + needed, uses: old.uses + 1)) - cost(item, old)
            result.cost += change
            guard old.uses > 0, !item.staple else { continue }
            result.shared += 1
            let unused = max(0, Double(GroceryAggregator.packCount(for: old.packs)) - old.packs)
            let reuse = min(unused, needed) * item.urgency * prices[item.id, default: 0]
            result.freshReuse += reuse
            if reuse > 0 { result.freshShared += 1 }
            if reuse > largestReuse {
                largestReuse = reuse
                result.freshIngredient = item.id
            }
        }
        return result
    }

    private func cost(_ item: IngredientUse, _ quantity: Quantity) -> Double {
        guard quantity.uses > 0 else { return 0 }
        let price = prices[item.id, default: 0]
        return item.staple ? GroceryAggregator.pantryCost(packPrice: price)
            : Double(GroceryAggregator.packCount(for: quantity.packs)) * price
    }
}
