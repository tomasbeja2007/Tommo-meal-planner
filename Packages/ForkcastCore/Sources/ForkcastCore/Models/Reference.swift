import Foundation

public struct Country: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let flagEmoji: String
    public let currencyCode: String
    public let unitSystem: UnitSystem
    public let regionPriceKey: RegionPriceKey
    /// Applied to the region price table (e.g. CAD/AUD converted from the US table).
    public let priceMultiplier: Double
    public let priceNote: String?

    public init(id: String, name: String, flagEmoji: String, currencyCode: String, unitSystem: UnitSystem, regionPriceKey: RegionPriceKey, priceMultiplier: Double = 1, priceNote: String? = nil) {
        self.id = id
        self.name = name
        self.flagEmoji = flagEmoji
        self.currencyCode = currencyCode
        self.unitSystem = unitSystem
        self.regionPriceKey = regionPriceKey
        self.priceMultiplier = priceMultiplier
        self.priceNote = priceNote
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, flagEmoji, currencyCode, unitSystem, regionPriceKey, priceMultiplier, priceNote
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        flagEmoji = try c.decode(String.self, forKey: .flagEmoji)
        currencyCode = try c.decode(String.self, forKey: .currencyCode)
        unitSystem = try c.decode(UnitSystem.self, forKey: .unitSystem)
        regionPriceKey = try c.decode(RegionPriceKey.self, forKey: .regionPriceKey)
        priceMultiplier = try c.decodeIfPresent(Double.self, forKey: .priceMultiplier) ?? 1
        priceNote = try c.decodeIfPresent(String.self, forKey: .priceNote)
    }
}

public struct Store: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let countryIds: [String]
    public let tier: StoreTier
    public let brandColorHex: String

    public static let localStoreId: String = "local"

    public var isLocalStore: Bool { id == Store.localStoreId }

    /// First letter for the monogram tile.
    public var monogram: String {
        String(name.first.map { String($0) } ?? "?").uppercased()
    }

    public init(id: String, name: String, countryIds: [String], tier: StoreTier, brandColorHex: String) {
        self.id = id
        self.name = name
        self.countryIds = countryIds
        self.tier = tier
        self.brandColorHex = brandColorHex
    }
}

public struct Macros: Codable, Hashable, Sendable {
    public var kcal: Double
    public var protein: Double
    public var carbs: Double
    public var fat: Double
    public var fiber: Double

    public static let zero: Macros = Macros(kcal: 0, protein: 0, carbs: 0, fat: 0, fiber: 0)

    public init(kcal: Double, protein: Double, carbs: Double, fat: Double, fiber: Double = 0) {
        self.kcal = kcal
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.fiber = fiber
    }

    private enum CodingKeys: String, CodingKey { case kcal, protein, carbs, fat, fiber }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        kcal = try c.decode(Double.self, forKey: .kcal)
        protein = try c.decode(Double.self, forKey: .protein)
        carbs = try c.decode(Double.self, forKey: .carbs)
        fat = try c.decode(Double.self, forKey: .fat)
        fiber = try c.decodeIfPresent(Double.self, forKey: .fiber) ?? 0
    }

    public func scaled(by factor: Double) -> Macros {
        Macros(kcal: kcal * factor, protein: protein * factor, carbs: carbs * factor, fat: fat * factor, fiber: fiber * factor)
    }

    public static func + (lhs: Macros, rhs: Macros) -> Macros {
        Macros(kcal: lhs.kcal + rhs.kcal, protein: lhs.protein + rhs.protein, carbs: lhs.carbs + rhs.carbs, fat: lhs.fat + rhs.fat, fiber: lhs.fiber + rhs.fiber)
    }

    public static func += (lhs: inout Macros, rhs: Macros) {
        lhs = lhs + rhs
    }
}

public struct DietFlags: Codable, Hashable, Sendable {
    public let isMeat: Bool
    public let isFish: Bool
    public let isAnimalProduct: Bool

    public init(isMeat: Bool, isFish: Bool, isAnimalProduct: Bool) {
        self.isMeat = isMeat
        self.isFish = isFish
        self.isAnimalProduct = isAnimalProduct
    }
}

public struct Pack: Codable, Hashable, Sendable {
    /// Amount in the ingredient's base unit.
    public let amount: Double
    /// Metric display, e.g. "400 g tin".
    public let display: String
    /// Imperial display, e.g. "14.5 oz can".
    public let displayImperial: String
    public let noun: String
    public let nounPlural: String

    public init(amount: Double, display: String, displayImperial: String, noun: String, nounPlural: String) {
        self.amount = amount
        self.display = display
        self.displayImperial = displayImperial
        self.noun = noun
        self.nounPlural = nounPlural
    }

    public func display(for system: UnitSystem) -> String {
        system == .imperial ? displayImperial : display
    }
}

public struct Ingredient: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let pluralName: String
    /// British/European name (aubergine, coriander...). Shown with the metric unit system.
    public let ukName: String?
    public let aisle: Aisle
    public let allergens: [Allergen]
    public let dietFlags: DietFlags
    public let per100g: Macros
    public let baseUnit: BaseUnit
    /// Grams per unit for "piece", "clove", "tbsp", "tsp", "cup", "slice", "bunch".
    public let gramsPerUnit: [String: Double]?
    /// Density for ml-based ingredients (defaults to 1).
    public let gramsPerMl: Double?
    public let pack: Pack
    public let isPantryStaple: Bool
    public let emoji: String
    public let proteinGroup: ProteinGroup?
    public let tags: [String]

    public init(id: String, name: String, pluralName: String, ukName: String? = nil, aisle: Aisle, allergens: [Allergen] = [], dietFlags: DietFlags, per100g: Macros, baseUnit: BaseUnit, gramsPerUnit: [String: Double]? = nil, gramsPerMl: Double? = nil, pack: Pack, isPantryStaple: Bool = false, emoji: String, proteinGroup: ProteinGroup? = nil, tags: [String] = []) {
        self.id = id
        self.name = name
        self.pluralName = pluralName
        self.ukName = ukName
        self.aisle = aisle
        self.allergens = allergens
        self.dietFlags = dietFlags
        self.per100g = per100g
        self.baseUnit = baseUnit
        self.gramsPerUnit = gramsPerUnit
        self.gramsPerMl = gramsPerMl
        self.pack = pack
        self.isPantryStaple = isPantryStaple
        self.emoji = emoji
        self.proteinGroup = proteinGroup
        self.tags = tags
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, pluralName, ukName, aisle, allergens, dietFlags, per100g, baseUnit, gramsPerUnit, gramsPerMl, pack, isPantryStaple, emoji, proteinGroup, tags
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        pluralName = try c.decodeIfPresent(String.self, forKey: .pluralName) ?? name
        ukName = try c.decodeIfPresent(String.self, forKey: .ukName)
        aisle = try c.decode(Aisle.self, forKey: .aisle)
        allergens = try c.decodeIfPresent([Allergen].self, forKey: .allergens) ?? []
        dietFlags = try c.decode(DietFlags.self, forKey: .dietFlags)
        per100g = try c.decode(Macros.self, forKey: .per100g)
        baseUnit = try c.decode(BaseUnit.self, forKey: .baseUnit)
        gramsPerUnit = try c.decodeIfPresent([String: Double].self, forKey: .gramsPerUnit)
        gramsPerMl = try c.decodeIfPresent(Double.self, forKey: .gramsPerMl)
        pack = try c.decode(Pack.self, forKey: .pack)
        isPantryStaple = try c.decodeIfPresent(Bool.self, forKey: .isPantryStaple) ?? false
        emoji = try c.decodeIfPresent(String.self, forKey: .emoji) ?? "🛒"
        proteinGroup = try c.decodeIfPresent(ProteinGroup.self, forKey: .proteinGroup)
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
    }

    /// Name for the user's unit system (US names for imperial, UK/EU names for metric).
    public func displayName(for system: UnitSystem, plural: Bool = false) -> String {
        if system == .metric, let ukName {
            return ukName
        }
        return plural ? pluralName : name
    }

    public func grams(perUnit unit: MeasureUnit) -> Double? {
        gramsPerUnit?[unit.rawValue]
    }

    public var isSpicy: Bool { tags.contains("spicy") }
}

/// Price per pack, per region, at the `standard` tier.
public struct PriceTable: Codable, Hashable, Sendable {
    public let entries: [String: [String: Double]]

    public init(entries: [String: [String: Double]]) {
        self.entries = entries
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        entries = try c.decode([String: [String: Double]].self)
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        try c.encode(entries)
    }

    public func standardPackPrice(ingredientId: String, region: RegionPriceKey) -> Double? {
        entries[ingredientId]?[region.rawValue]
    }
}

/// Everything needed to price a basket for one user.
public struct PriceContext: Hashable, Sendable {
    public let region: RegionPriceKey
    public let tier: StoreTier
    /// Country multiplier (e.g. CAD from the US table).
    public let countryMultiplier: Double

    public init(region: RegionPriceKey, tier: StoreTier, countryMultiplier: Double = 1) {
        self.region = region
        self.tier = tier
        self.countryMultiplier = countryMultiplier
    }

    public init(country: Country, store: Store?) {
        self.region = country.regionPriceKey
        self.tier = store?.tier ?? .standard
        self.countryMultiplier = country.priceMultiplier
    }

    public var multiplier: Double { tier.multiplier * countryMultiplier }
}
