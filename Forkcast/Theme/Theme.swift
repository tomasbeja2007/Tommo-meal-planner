import SwiftUI

/// Forkcast design tokens: "warm kitchen, food first". The rules for using them: Design/STYLE_GUIDE.md.
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

    /// Illustration-only colours (the globe). Never used for interface chrome.
    enum Illustration {
        static let oceanLight = Color(hex: 0x5B9CE8)
        static let oceanDeep = Color(hex: 0x1D4E9E)
        static let landLight = Color(hex: 0x9AD872)
        static let landDeep = Color(hex: 0x4F9A43)
        static let coast = Color(hex: 0x3D7F34)
        static let atmosphere = Color(hex: 0x9CC8F5)
    }

    /// Muted macro bar colours (protein / carbs / fat).
    static let macroProtein = Color(hex: 0xE8553D).opacity(0.75)
    static let macroCarbs = Color(hex: 0xF2B544).opacity(0.85)
    static let macroFat = Color(hex: 0x7A5C7E).opacity(0.8)

    // MARK: Shape
    /// Corner radii (always `style: .continuous`). Pills and avatars use `Capsule()` / `Circle()`.
    enum Radius {
        /// Small thumbnails (≤ 48 pt), badges, small fields.
        static let small: CGFloat = 10
        /// Day pills, mid-size tiles inside cards.
        static let medium: CGFloat = 14
        /// Buttons, inputs, option tiles, list tiles.
        static let button: CGFloat = 16
        static let input: CGFloat = 16
        /// Cards and sheets' inner cards.
        static let card: CGFloat = 20
        /// Large dish photos (≥ 100 pt).
        static let large: CGFloat = 24
        /// Hero dish photos (≥ 130 pt).
        static let hero: CGFloat = 32
    }

    /// The spacing scale. Every gap, padding and stack spacing is one of these.
    enum Spacing {
        /// Hairline gaps: a title and its caption in a tight stack.
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        /// Icon-to-label gaps, chip rows, compact grids.
        static let inline: CGFloat = 6
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        /// Card padding, gaps between related blocks.
        static let l: CGFloat = 16
        /// Horizontal screen gutter.
        static let gutter: CGFloat = 20
        /// Gaps between sections.
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        /// Hero breathing room (top of celebration screens).
        static let xxxl: CGFloat = 48
    }

    /// Fixed sizes that keep controls consistent and tappable.
    enum Size {
        /// Minimum tap target (Apple HIG).
        static let tapTarget: CGFloat = 44
        static let primaryButton: CGFloat = 56
        static let secondaryButton: CGFloat = 50
        /// Round icon buttons (bell, swap).
        static let iconButton: CGFloat = 44
        /// Corner mascot reactions on question screens.
        static let mascotCorner: CGFloat = 48
    }

    /// The only shadows in the app.
    enum Elevation {
        /// Cards: the single soft Forkcast shadow.
        static let card = (color: Color.black.opacity(0.06), radius: CGFloat(12), y: CGFloat(4))
        /// Things that float above a card: dealt dish photos, the welcome hero dish.
        static let lifted = (color: Color(hex: 0x2B1E2E).opacity(0.16), radius: CGFloat(10), y: CGFloat(6))
        /// Small pieces on cream: ingredient cut-outs, logo capsules.
        static let subtle = (color: Color(hex: 0x2B1E2E).opacity(0.10), radius: CGFloat(5), y: CGFloat(3))
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
    /// Question titles on onboarding screens (lower case, a question mark when it's a question).
    static let questionFont: Font = Typography.title

    /// The type scale. SF Pro Rounded everywhere (set once at the root with `.fontDesign(.rounded)`).
    /// Text uses Dynamic Type styles so it scales; only the display and number styles are fixed sizes.
    enum Typography {
        /// The welcome headline ("Dinner, sorted."). Scale it with `@ScaledMetric` where it's used.
        static let display: Font = .system(size: 44, weight: .heavy, design: .rounded)
        /// Screen and question titles.
        static let title: Font = .system(size: 30, weight: .bold, design: .rounded)
        /// Large screen titles on the main tabs ("Meal Plan").
        static let largeTitle: Font = .system(.largeTitle, design: .rounded).weight(.bold)
        /// Big statements inside a screen ("a year!", "here's your week" sub-blocks).
        static let title2: Font = .system(.title2, design: .rounded).weight(.bold)
        static let title3: Font = .system(.title3, design: .rounded).weight(.bold)
        /// Card titles, recipe names, button labels.
        static let headline: Font = .system(.headline, design: .rounded)
        static let body: Font = .system(.body, design: .rounded)
        /// Secondary copy, list detail, subtitles.
        static let subheadline: Font = .system(.subheadline, design: .rounded)
        /// Meta (time, cost), helper text.
        static let caption: Font = .system(.caption, design: .rounded)
        /// Eyebrows: small bold caps above a title ("TONIGHT", "FIRST UP, MONDAY"). Use with `.textCase(.uppercase)`.
        static let eyebrow: Font = .system(.caption, design: .rounded).weight(.bold)
        static let footnote: Font = .system(.footnote, design: .rounded)
        /// Hero numbers (the yearly saving). Always `.monospacedDigit()`.
        static let heroNumber: Font = .system(size: 72, weight: .black, design: .rounded)
        /// Big numbers (the weekly saving, the recipes-checked counter). Always `.monospacedDigit()`.
        static let bigNumber: Font = .system(size: 44, weight: .black, design: .rounded)
    }
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
                    .elevation(Theme.Elevation.card)
            )
    }
}

extension View {
    /// One of the app's three shadows (`Theme.Elevation`).
    func elevation(_ level: (color: Color, radius: CGFloat, y: CGFloat)) -> some View {
        shadow(color: level.color, radius: level.radius, x: 0, y: level.y)
    }

    /// White card with the single soft Forkcast shadow.
    func cardStyle(padding: CGFloat = Theme.Spacing.l) -> some View {
        modifier(CardBackground(padding: padding))
    }

    /// The cream app background, edge to edge.
    func creamBackground() -> some View {
        background(Theme.cream.ignoresSafeArea())
    }
}
