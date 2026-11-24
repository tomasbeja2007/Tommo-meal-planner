import SwiftUI
import ForkcastCore

/// The quiet macros line on every meal card: `520 kcal · 32g P · 45g C · 18g F`.
struct MacrosLine: View {
    let macros: Macros
    var font: Font = .caption

    var body: some View {
        Text(MacrosText.compact(macros))
            .font(font)
            .monospacedDigit()
            .foregroundStyle(Theme.aubergineFaint)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .accessibilityLabel(Text(MacrosText.spoken(macros)))
    }
}

enum MacrosText {
    static func compact(_ m: Macros) -> String {
        "\(Int(m.kcal.rounded())) kcal · \(Int(m.protein.rounded()))g P · \(Int(m.carbs.rounded()))g C · \(Int(m.fat.rounded()))g F"
    }

    static func spoken(_ m: Macros) -> String {
        "\(Int(m.kcal.rounded())) calories, \(Int(m.protein.rounded())) grams protein, \(Int(m.carbs.rounded())) grams carbs, \(Int(m.fat.rounded())) grams fat"
    }
}

#Preview("Macros line") {
    MacrosLine(macros: Macros(kcal: 520, protein: 32, carbs: 45, fat: 18, fiber: 6))
        .padding()
        .creamBackground()
}
