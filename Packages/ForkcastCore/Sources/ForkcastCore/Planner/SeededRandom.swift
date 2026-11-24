import Foundation

/// Deterministic SplitMix64 generator: same seed, same plan (great for tests).
public struct SeededRandom: RandomNumberGenerator, Sendable {
    private var state: UInt64

    public init(seed: UInt64) {
        self.state = seed &+ 0x9E3779B97F4A7C15
    }

    public mutating func next() -> UInt64 {
        state = state &+ 0x9E3779B97F4A7C15
        var z: UInt64 = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }

    /// Uniform double in [0, 1).
    public mutating func nextUnit() -> Double {
        Double(next() >> 11) / Double(UInt64(1) << 53)
    }

    /// Seed derived from the week start and how many times the user regenerated.
    public static func seed(weekStart: Date, regeneration: Int) -> UInt64 {
        let days: Int64 = Int64((weekStart.timeIntervalSince1970 / 86_400).rounded(.down))
        return UInt64(bitPattern: days) &* 1_000_003 &+ UInt64(max(0, regeneration))
    }
}
