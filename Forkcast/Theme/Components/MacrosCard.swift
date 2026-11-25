import SwiftUI
import ForkcastCore

struct MacrosCard: View {
    let macros: Macros
    var caption: String = String(localized: "Per serving · estimated")
    var note: String? = nil
    var title: String = String(localized: "Macros · your portion")
    var goal: Int? = nil

    private var segments: [(label: String, grams: Double, calories: Double, color: Color)] {
        [
            (String(localized: "Protein"), macros.protein, max(0, macros.protein * 4), Theme.macroProtein),
            (String(localized: "Carbs"), macros.carbs, max(0, macros.carbs * 4), Theme.macroCarbs),
            (String(localized: "Fat"), macros.fat, max(0, macros.fat * 9), Theme.macroFat)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            Text(title)
                .font(.caption.weight(.bold))
                .textCase(.uppercase)
                .foregroundStyle(Theme.aubergineMuted)
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline) { calories; Spacer(); summary }
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) { calories; summary }
            }
            GeometryReader { proxy in
                let total = segments.reduce(0) { $0 + $1.calories }
                HStack(spacing: 0) {
                    ForEach(segments, id: \.label) { segment in
                        Rectangle()
                            .fill(segment.color)
                            .frame(width: total > 0 ? proxy.size.width * segment.calories / total : 0)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(Theme.creamDeep)
                .clipShape(Capsule())
            }
            .frame(height: 8)
            .accessibilityHidden(true)
            FlowLayout(spacing: Theme.Spacing.m) {
                ForEach(segments, id: \.label) { segment in
                    HStack(spacing: Theme.Spacing.xs) {
                        Circle().fill(segment.color).frame(width: 7, height: 7)
                        Text("\(Int(segment.grams.rounded())) g \(segment.label)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.aubergine)
                    }
                }
            }
            if let note {
                Text(note).font(.caption).foregroundStyle(Theme.aubergineMuted)
            }
        }
        .cardStyle()
        .accessibilityElement(children: .combine)
    }

    private var calories: some View {
        HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.xs) {
            Text(Int(macros.kcal.rounded()).formatted())
                .font(.system(.title, design: .rounded).weight(.bold))
                .monospacedDigit()
                .foregroundStyle(Theme.aubergine)
                .contentTransition(.numericText())
            if let goal {
                Text("/ \(goal.formatted()) kcal")
            } else {
                Text("kcal")
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .foregroundStyle(Theme.aubergineMuted)
    }

    private var summary: some View {
        Text(caption)
            .font(.caption)
            .foregroundStyle(Theme.aubergineMuted)
    }
}

#Preview {
    MacrosCard(macros: Macros(kcal: 540, protein: 34, carbs: 52, fat: 19, fiber: 7))
        .padding()
        .creamBackground()
}
