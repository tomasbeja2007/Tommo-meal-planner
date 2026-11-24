import SwiftUI
import ForkcastCore

/// Compact, quiet nutrition card: big kcal, then three slim proportional bars.
struct MacrosCard: View {
    let macros: Macros
    var caption: String = String(localized: "per serving · estimated")
    var note: String? = nil

    private var totalGrams: Double {
        max(1, macros.protein + macros.carbs + macros.fat)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(Int(macros.kcal.rounded()))")
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(Theme.aubergine)
                    .contentTransition(.numericText())
                Text("kcal")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.aubergineMuted)
                Spacer()
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineFaint)
            }
            MacroBarRow(label: String(localized: "Protein"), grams: macros.protein, fraction: macros.protein / totalGrams, tint: Theme.macroProtein, delay: 0)
            MacroBarRow(label: String(localized: "Carbs"), grams: macros.carbs, fraction: macros.carbs / totalGrams, tint: Theme.macroCarbs, delay: 0.06)
            MacroBarRow(label: String(localized: "Fat"), grams: macros.fat, fraction: macros.fat / totalGrams, tint: Theme.macroFat, delay: 0.12)
            if let note {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(Theme.aubergineFaint)
            }
        }
        .cardStyle()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(MacrosText.spoken(macros) + ", " + caption))
    }
}

private struct MacroBarRow: View {
    let label: String
    let grams: Double
    let fraction: Double
    let tint: Color
    /// Draw-on stagger, in seconds.
    let delay: Double

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.aubergineMuted)
                .frame(width: 58, alignment: .leading)
            ProgressBar(value: fraction, tint: tint, height: 6, drawOnDelay: delay)
            Text("\(Int(grams.rounded())) g")
                .font(.caption)
                .monospacedDigit()
                .foregroundStyle(Theme.aubergineMuted)
                .frame(minWidth: 40, alignment: .trailing)
        }
    }
}

#Preview("Macros card") {
    MacrosCard(macros: Macros(kcal: 540, protein: 34, carbs: 52, fat: 19, fiber: 7))
        .padding()
        .creamBackground()
}
