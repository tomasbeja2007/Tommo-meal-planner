import Foundation

/// Deterministic dish-tile colours, shared by the app and the widget.
public enum DishPalette {
    /// tomato, saffron, paprika, olive, beetroot, aubergine-light, butter, cinnamon
    /// (each slightly desaturated, about 85%).
    public static let hexes: [String] = [
        "#E35E48", // tomato
        "#EBB552", // saffron
        "#D27845", // paprika
        "#888C52", // olive
        "#A14C64", // beetroot
        "#7A6080", // aubergine-light
        "#E3C474", // butter
        "#AF7956"  // cinnamon
    ]

    public static func index(for seed: String) -> Int {
        Int(StableHash.fnv1a(seed) % UInt64(hexes.count))
    }

    public static func hex(for seed: String) -> String {
        hexes[index(for: seed)]
    }
}

/// Stable (process-independent) string hashing. Swift's `hashValue` is
/// randomly seeded per launch, so we never use it for persisted decisions.
public enum StableHash {
    public static func fnv1a(_ string: String) -> UInt64 {
        var hash: UInt64 = 0xcbf29ce484222325
        for byte in string.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 0x100000001b3
        }
        return hash
    }
}
