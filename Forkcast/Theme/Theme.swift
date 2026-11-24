import SwiftUI

/// Forkcast design tokens: "warm kitchen, food first".
/// Colours mirror the named colour sets in Assets.xcassets. They are defined
/// from hex here as well, so they also work in previews and never fail to load.
enum Theme {
    // MARK: Palette
    static let cream = Color(hex: 0xFBF6EE)
    static let card = Color(hex: 0xFFFFFF)
    static let creamDeep = Color(hex: 0xF3E9DA)
    static let tomato = Color(hex: 0xE8553D)
    static let tomatoDeep = Color(hex: 0xC9402B)
    static let tomatoSoft = Color(hex: 0xFBE3DC)
    static let aubergine = Color(hex: 0x2B1E2E)
    static let aubergineMuted = Color(hex: 0x6E5F6B)
    static let aubergineFaint = Color(hex: 0xA89BA5)
    static let saffron = Color(hex: 0xF2B544)
    static let saffronSoft = Color(hex: 0xFCEFD3)
    static let herb = Color(hex: 0x5B8C5A)
    static let herbSoft = Color(hex: 0xE3EEDF)
    static let line = Color(hex: 0xEADFCF)

    /// Muted macro bar colours (protein / carbs / fat).
    static let macroProtein = Color(hex: 0xE8553D).opacity(0.75)
    static let macroCarbs = Color(hex: 0xF2B544).opacity(0.85)
    static let macroFat = Color(hex: 0x7A5C7E).opacity(0.8)

    // MARK: Shape
    enum Radius {
        static let card: CGFloat = 20
        static let button: CGFloat = 16
        static let input: CGFloat = 16
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        /// Horizontal screen gutter.
        static let gutter: CGFloat = 20
    }

    // MARK: Motion
    static let spring = Motion.selection

    enum Motion {
        static let press = Animation.easeOut(duration: 0.10)
        static let release = Animation.spring(response: 0.18, dampingFraction: 0.9)
        static let selection = Animation.spring(response: 0.35, dampingFraction: 0.8)
        static let update = Animation.spring(response: 0.24, dampingFraction: 0.9)
        static let fadeIn = Animation.easeOut(duration: 0.18)
        static let fadeOut = Animation.easeIn(duration: 0.15)
        static let reveal = Animation.open(0.36)
        static let stagger: Double = 0.05
        static let ambientDuration: Double = 60_000
    }

    /// Returns the spring, or nil when Reduce Motion is on.
    static func motion(_ reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : spring
    }

    // MARK: Type
    static let questionFont: Font = .system(size: 30, weight: .bold, design: .rounded)
}

extension Color {
    /// Creates a colour from a 0xRRGGBB integer.
    init(hex: UInt32, opacity: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }

    /// Creates a colour from a "#RRGGBB" or "RRGGBB" string. Falls back to tomato.
    init(hexString: String) {
        var cleaned = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("#") { cleaned.removeFirst() }
        let value = UInt32(cleaned, radix: 16) ?? 0xE8553D
        self.init(hex: value)
    }
}

// MARK: - Card style

struct CardBackground: ViewModifier {
    var padding: CGFloat = Theme.Spacing.l

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                    .fill(Theme.card)
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            )
    }
}

extension View {
    /// White card with the single soft Forkcast shadow.
    func cardStyle(padding: CGFloat = Theme.Spacing.l) -> some View {
        modifier(CardBackground(padding: padding))
    }

    /// The cream app background, edge to edge.
    func creamBackground() -> some View {
        background(Theme.cream.ignoresSafeArea())
    }
}
