import SwiftUI

/// Formats money in the user's currency, optionally counting up from zero.
/// Uses monospaced digits so the number never jiggles while animating.
struct MoneyText: View {
    let amount: Double
    let currencyCode: String
    var font: Font = .system(.title, design: .rounded).weight(.bold)
    var color: Color = Theme.aubergine
    var prefix: String = ""
    var countUp: Bool = false
    var fractionDigits: Int = 2

    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @State private var displayed: Double = 0
    @State private var hasAppeared: Bool = false

    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .modifier(CountingTextModifier(
                value: countUp ? displayed : amount,
                currencyCode: currencyCode,
                prefix: prefix,
                fractionDigits: fractionDigits
            ))
            .font(font)
            .monospacedDigit()
            .foregroundStyle(color)
            .onAppear {
                guard countUp, !hasAppeared else { return }
                hasAppeared = true
                if reduceMotion {
                    displayed = amount
                } else {
                    withAnimation(Animation.open(1.1)) { displayed = amount }
                }
            }
            .onChange(of: amount) { _, newValue in
                guard countUp else { return }
                if reduceMotion {
                    displayed = newValue
                } else {
                    withAnimation(Animation.open(0.6)) { displayed = newValue }
                }
            }
            .accessibilityElement()
            .accessibilityLabel(Text(prefix + MoneyFormat.string(amount, currencyCode: currencyCode, fractionDigits: fractionDigits)))
    }
}

/// Animatable modifier that renders the interpolated value as currency text.
private struct CountingTextModifier: ViewModifier, Animatable {
    var value: Double
    let currencyCode: String
    let prefix: String
    let fractionDigits: Int

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        Text(prefix + MoneyFormat.string(value, currencyCode: currencyCode, fractionDigits: fractionDigits))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .fixedSize(horizontal: false, vertical: true)
    }
}

/// Currency formatting helpers (always via the country's currency code).
enum MoneyFormat {
    static func string(_ amount: Double, currencyCode: String, fractionDigits: Int = 2) -> String {
        amount.formatted(
            .currency(code: currencyCode)
                .precision(.fractionLength(fractionDigits))
        )
    }

    /// "+$1.20" / "−$0.80"
    static func delta(_ amount: Double, currencyCode: String) -> String {
        let magnitude: String = string(abs(amount), currencyCode: currencyCode)
        if abs(amount) < 0.005 { return "±" + magnitude }
        return (amount > 0 ? "+" : "−") + magnitude
    }
}

#Preview("Money") {
    VStack(spacing: Theme.Spacing.m) {
        MoneyText(amount: 71.4, currencyCode: "USD", prefix: "~", countUp: true)
        MoneyText(amount: 52, currencyCode: "GBP", font: .headline)
        MoneyText(amount: 64.2, currencyCode: "EUR", font: .headline, color: Theme.herb)
    }
    .padding()
    .creamBackground()
}
