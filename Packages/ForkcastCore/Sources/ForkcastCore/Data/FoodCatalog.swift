import Foundation

public enum CatalogError: Error, CustomStringConvertible {
    case missingResource(String)
    case decodingFailed(String, Error)

    public var description: String {
        switch self {
        case .missingResource(let name): return "Bundled resource \(name) is missing from ForkcastCore."
        case .decodingFailed(let name, let error): return "Failed to decode \(name): \(error)"
        }
    }
}

/// All bundled reference data: countries, stores, ingredients, prices and recipes.
/// Immutable after loading, so it is safe to share across threads.
public struct FoodCatalog: Sendable {
    public let countries: [Country]
    public let stores: [Store]
    public let ingredients: [Ingredient]
    public let prices: PriceTable
    public let recipes: [Recipe]

    public let ingredientsById: [String: Ingredient]
    public let recipesById: [String: Recipe]
    private let countriesById: [String: Country]
    private let storesById: [String: Store]

    public init(countries: [Country], stores: [Store], ingredients: [Ingredient], prices: PriceTable, recipes: [Recipe]) {
        self.countries = countries
        self.stores = stores
        self.ingredients = ingredients
        self.prices = prices
        self.recipes = recipes
        var ing: [String: Ingredient] = [:]
        for item in ingredients { ing[item.id] = item }
        self.ingredientsById = ing
        var rec: [String: Recipe] = [:]
        for item in recipes { rec[item.id] = item }
        self.recipesById = rec
        var cty: [String: Country] = [:]
        for item in countries { cty[item.id] = item }
        self.countriesById = cty
        var sto: [String: Store] = [:]
        for item in stores { sto[item.id] = item }
        self.storesById = sto
    }

    // MARK: Loading

    public static let resourceNames: [String] = ["countries", "stores", "ingredients", "prices", "recipes"]

    /// Loads the JSON shipped inside the ForkcastCore resource bundle.
    public static func loadBundled() throws -> FoodCatalog {
        try load(from: Bundle.module)
    }

    public static func load(from bundle: Bundle) throws -> FoodCatalog {
        func data(_ name: String) throws -> Data {
            guard let url = bundle.url(forResource: name, withExtension: "json") else {
                throw CatalogError.missingResource("\(name).json")
            }
            return try Data(contentsOf: url)
        }
        return try load(
            countries: data("countries"),
            stores: data("stores"),
            ingredients: data("ingredients"),
            prices: data("prices"),
            recipes: data("recipes")
        )
    }

    public static func load(countries: Data, stores: Data, ingredients: Data, prices: Data, recipes: Data) throws -> FoodCatalog {
        let decoder = JSONDecoder()
        func decode<T: Decodable>(_ type: T.Type, _ data: Data, _ name: String) throws -> T {
            do {
                return try decoder.decode(type, from: data)
            } catch {
                throw CatalogError.decodingFailed(name, error)
            }
        }
        return FoodCatalog(
            countries: try decode([Country].self, countries, "countries.json"),
            stores: try decode([Store].self, stores, "stores.json"),
            ingredients: try decode([Ingredient].self, ingredients, "ingredients.json"),
            prices: try decode(PriceTable.self, prices, "prices.json"),
            recipes: try decode([Recipe].self, recipes, "recipes.json")
        )
    }

    /// Shared instance. A missing or broken bundled file is a programmer error,
    /// so we crash loudly in development rather than limp along.
    public static let bundled: FoodCatalog = {
        do {
            return try FoodCatalog.loadBundled()
        } catch {
            fatalError("ForkcastCore: could not load bundled catalog. \(error)")
        }
    }()

    // MARK: Lookups

    public func country(id: String) -> Country? { countriesById[id] }
    public func store(id: String) -> Store? { storesById[id] }
    public func ingredient(id: String) -> Ingredient? { ingredientsById[id] }
    public func recipe(id: String) -> Recipe? { recipesById[id] }

    /// Default country: United States (first in every list).
    public var defaultCountry: Country {
        countries.first ?? Country(id: "us", name: "United States", flagEmoji: "🇺🇸", currencyCode: "USD", unitSystem: .imperial, regionPriceKey: .US)
    }

    /// Stores for a country in file order, with "My local store" last.
    public func stores(forCountry countryId: String) -> [Store] {
        let matching: [Store] = stores.filter { $0.countryIds.contains(countryId) }
        let named: [Store] = matching.filter { !$0.isLocalStore }
        let local: [Store] = matching.filter { $0.isLocalStore }
        return named + local
    }

    /// Price for one pack of an ingredient at this store, in the country currency.
    public func packPrice(ingredientId: String, context: PriceContext) -> Double? {
        guard let base = prices.standardPackPrice(ingredientId: ingredientId, region: context.region) else { return nil }
        return base * context.multiplier
    }
}
