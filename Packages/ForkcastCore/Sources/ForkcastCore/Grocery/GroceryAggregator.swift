import Foundation

/// One dinner going into the basket.
public struct MealPortion: Hashable, Sendable {
    public let recipe: Recipe
    public let servings: Double
    /// ISO weekday, 1 = Monday ... 7 = Sunday.
    public let weekday: Int

    public init(recipe: Recipe, servings: Double, weekday: Int) {
        self.recipe = recipe
        self.servings = servings
        self.weekday = weekday
    }

    public var scale: Double { servings / Double(max(1, recipe.baseServings)) }
}

public struct GroceryItem: Identifiable, Hashable, Sendable {
    /// Stable key used to persist the checked state.
    public let key: String
    public let ingredientId: String?
    public let name: String
    public let emoji: String
    public let aisle: Aisle
    public let isPantryStaple: Bool
    /// Number of packs to buy (0 for staples and unlinked items).
    public let packCount: Int
    /// "2 × 400 g tin"
    public let displayQuantity: String
    /// "you need 1½ onions"
    public let neededText: String
    /// Amount needed, in the ingredient's base unit.
    public let neededBase: Double
    /// ISO weekdays this item is used on, sorted.
    public let usedOnWeekdays: [Int]
    public let cost: Double
    public let hasPrice: Bool

    public var id: String { key }
}

public struct GrocerySection: Identifiable, Hashable, Sendable {
    public let aisle: Aisle
    public let items: [GroceryItem]
    public var id: String { aisle.rawValue }
}

public struct GroceryList: Hashable, Sendable {
    public let sections: [GrocerySection]
    public let pantryStaples: [GroceryItem]
    /// Approximate basket total including the amortised pantry cost.
    public let total: Double
    /// Each meal's share of the basket, aligned with the input meals.
    public let mealCosts: [Double]
    /// What the meals would cost if each were bought on its own (whole packs each time).
    public let standaloneTotal: Double
    public let standaloneMealCosts: [Double]

    public static let empty: GroceryList = GroceryList(sections: [], pantryStaples: [], total: 0, mealCosts: [], standaloneTotal: 0, standaloneMealCosts: [])

    public var allItems: [GroceryItem] { sections.flatMap { $0.items } }
    /// Items counted in "12 / 31" (excludes pantry staples).
    public var itemCount: Int { sections.reduce(0) { $0 + $1.items.count } }
    public var savingsFromSharing: Double { max(0, standaloneTotal - total) }
}

public enum GroceryAggregator {
    /// Amortised weekly cost of a pantry staple: a small slice of a pack.
    public static func pantryCost(packPrice: Double) -> Double {
        min(max(packPrice * 0.08, 0.05), 0.6)
    }

    private struct Accumulator {
        var needed: Double = 0
        var weekdays: Set<Int> = []
        var perMeal: [Int: Double] = [:]
    }

    private struct CustomAccumulator {
        var name: String
        var unit: MeasureUnit
        var amount: Double = 0
        var weekdays: Set<Int> = []
    }

    /// `onHand`: ingredient ids the user already has. They move to the "check you have" list at no cost.
    public static func aggregate(meals: [MealPortion], catalog: FoodCatalog, pricing: PriceContext, unitSystem: UnitSystem, onHand: Set<String> = []) -> GroceryList {
        var linked: [String: Accumulator] = [:]
        var custom: [String: CustomAccumulator] = [:]

        for (mealIndex, meal) in meals.enumerated() {
            for item in meal.recipe.ingredients {
                let scaledAmount: Double = item.amount * meal.scale
                if let id = item.ingredientId, let ingredient = catalog.ingredient(id: id) {
                    let base: Double = UnitConverter.baseAmount(amount: scaledAmount, unit: item.unit, ingredient: ingredient) ?? 0
                    var acc: Accumulator = linked[id] ?? Accumulator()
                    acc.needed += base
                    acc.weekdays.insert(meal.weekday)
                    acc.perMeal[mealIndex, default: 0] += base
                    linked[id] = acc
                } else {
                    let rawName: String = (item.name ?? "item").trimmingCharacters(in: .whitespacesAndNewlines)
                    let key: String = "custom:" + rawName.lowercased() + "|" + item.unit.rawValue
                    var acc: CustomAccumulator = custom[key] ?? CustomAccumulator(name: rawName, unit: item.unit)
                    acc.amount += scaledAmount
                    acc.weekdays.insert(meal.weekday)
                    custom[key] = acc
                }
            }
        }

        var items: [GroceryItem] = []
        var staples: [GroceryItem] = []
        var mealCosts: [Double] = Array(repeating: 0, count: meals.count)
        var standalone: [Double] = Array(repeating: 0, count: meals.count)
        var total: Double = 0

        for (id, acc) in linked {
            guard let ingredient = catalog.ingredient(id: id) else { continue }
            let packPrice: Double? = catalog.packPrice(ingredientId: id, context: pricing)
            let name: String = ingredient.displayName(for: unitSystem, plural: acc.needed > 1.0001 && ingredient.baseUnit == .piece)
            let weekdays: [Int] = acc.weekdays.sorted()

            if onHand.contains(id) {
                staples.append(GroceryItem(
                    key: id,
                    ingredientId: id,
                    name: name,
                    emoji: ingredient.emoji,
                    aisle: ingredient.aisle,
                    isPantryStaple: true,
                    packCount: 0,
                    displayQuantity: ingredient.pack.display(for: unitSystem),
                    neededText: "you have this · you need " + QuantityFormatter.baseString(acc.needed, ingredient: ingredient, system: unitSystem),
                    neededBase: acc.needed,
                    usedOnWeekdays: weekdays,
                    cost: 0,
                    hasPrice: packPrice != nil
                ))
                continue
            }

            if ingredient.isPantryStaple {
                let cost: Double = pantryCost(packPrice: packPrice ?? 0)
                total += cost
                // Split the staple's small cost evenly across the meals using it.
                let users: [Int] = acc.perMeal.keys.sorted()
                for index in users {
                    mealCosts[index] += cost / Double(max(1, users.count))
                    standalone[index] += cost
                }
                staples.append(GroceryItem(
                    key: id,
                    ingredientId: id,
                    name: name,
                    emoji: ingredient.emoji,
                    aisle: ingredient.aisle,
                    isPantryStaple: true,
                    packCount: 0,
                    displayQuantity: ingredient.pack.display(for: unitSystem),
                    neededText: "you need " + QuantityFormatter.baseString(acc.needed, ingredient: ingredient, system: unitSystem),
                    neededBase: acc.needed,
                    usedOnWeekdays: weekdays,
                    cost: cost,
                    hasPrice: packPrice != nil
                ))
                continue
            }

            let packAmount: Double = max(ingredient.pack.amount, 0.0001)
            // Small tolerance so 400.0001 g doesn't buy a second tin.
            let packs: Int = max(1, Int((acc.needed / packAmount - 0.02).rounded(.up)))
            let cost: Double = Double(packs) * (packPrice ?? 0)
            total += cost
            for (index, amount) in acc.perMeal {
                let share: Double = acc.needed > 0 ? amount / acc.needed : 0
                mealCosts[index] += cost * share
                let ownPacks: Int = max(1, Int((amount / packAmount - 0.02).rounded(.up)))
                standalone[index] += Double(ownPacks) * (packPrice ?? 0)
            }
            let packsNeeded: Double = acc.needed / packAmount
            var needed: String = "you need " + QuantityFormatter.baseString(acc.needed, ingredient: ingredient, system: unitSystem)
            if packs > 1 {
                let noun: String = packsNeeded > 1.0001 ? ingredient.pack.nounPlural : ingredient.pack.noun
                if ingredient.baseUnit != .piece {
                    needed += " (\(FractionFormatter.string(packsNeeded)) \(noun))"
                }
            }
            items.append(GroceryItem(
                key: id,
                ingredientId: id,
                name: name,
                emoji: ingredient.emoji,
                aisle: ingredient.aisle,
                isPantryStaple: false,
                packCount: packs,
                displayQuantity: "\(packs) × \(ingredient.pack.display(for: unitSystem))",
                neededText: needed,
                neededBase: acc.needed,
                usedOnWeekdays: weekdays,
                cost: cost,
                hasPrice: packPrice != nil
            ))
        }

        for (key, acc) in custom {
            let quantity: String = QuantityFormatter.string(amount: acc.amount, unit: acc.unit, system: unitSystem, ingredient: nil)
            items.append(GroceryItem(
                key: key,
                ingredientId: nil,
                name: acc.name,
                emoji: "🛒",
                aisle: .other,
                isPantryStaple: false,
                packCount: 0,
                displayQuantity: quantity,
                neededText: "you need " + quantity,
                neededBase: acc.amount,
                usedOnWeekdays: acc.weekdays.sorted(),
                cost: 0,
                hasPrice: false
            ))
        }

        var grouped: [Aisle: [GroceryItem]] = [:]
        for item in items {
            grouped[item.aisle, default: []].append(item)
        }
        let sections: [GrocerySection] = grouped.keys.sorted().map { aisle in
            let sorted: [GroceryItem] = (grouped[aisle] ?? []).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            return GrocerySection(aisle: aisle, items: sorted)
        }
        let sortedStaples: [GroceryItem] = staples.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

        return GroceryList(
            sections: sections,
            pantryStaples: sortedStaples,
            total: total,
            mealCosts: mealCosts,
            standaloneTotal: standalone.reduce(0, +),
            standaloneMealCosts: standalone
        )
    }

    /// "used Mon & Thu" / "used Mon, Wed & Fri"
    public static func usedOnText(_ weekdays: [Int], shortNames: [String] = WeekMath.englishShortWeekdays) -> String {
        let names: [String] = weekdays.compactMap { day in
            (1...7).contains(day) ? shortNames[day - 1] : nil
        }
        guard !names.isEmpty else { return "" }
        if names.count == 1 { return "used \(names[0])" }
        let head: String = names.dropLast().joined(separator: ", ")
        return "used \(head) & \(names[names.count - 1])"
    }
}

public enum GroceryTextExporter {
    /// Plain text for sharing, grouped by aisle with "☐"/"☑" boxes.
    public static func plainText(
        list: GroceryList,
        title: String,
        checkedKeys: Set<String>,
        extras: [(name: String, quantity: String, checked: Bool)] = [],
        formatMoney: (Double) -> String
    ) -> String {
        var lines: [String] = [title, ""]
        if !extras.isEmpty {
            lines.append("Extras")
            for extra in extras {
                let box: String = extra.checked ? "☑" : "☐"
                lines.append(extra.quantity.isEmpty ? "\(box) \(extra.name)" : "\(box) \(extra.name) (\(extra.quantity))")
            }
            lines.append("")
        }
        for section in list.sections {
            lines.append(section.aisle.displayName)
            for item in section.items {
                let box: String = checkedKeys.contains(item.key) ? "☑" : "☐"
                lines.append("\(box) \(item.name), \(item.displayQuantity)")
            }
            lines.append("")
        }
        if !list.pantryStaples.isEmpty {
            lines.append("You probably have these")
            for item in list.pantryStaples {
                let box: String = checkedKeys.contains(item.key) ? "☑" : "☐"
                lines.append("\(box) \(item.name)")
            }
            lines.append("")
        }
        lines.append("Approx. total: \(formatMoney(list.total))")
        lines.append("Planned with Forkcast")
        return lines.joined(separator: "\n")
    }
}
