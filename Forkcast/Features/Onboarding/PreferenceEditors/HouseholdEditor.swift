import SwiftUI
import ForkcastCore

struct HouseholdEditor: View {
    @Binding var adults: Int
    @Binding var kids: Int

    private var portions: Double { BudgetMath.portions(adults: adults, kids: kids) }

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            CountStepperRow(title: String(localized: "Adults"), subtitle: String(localized: "13 and over"), systemImage: "person.fill", value: $adults, range: 1...10)
            CountStepperRow(title: String(localized: "Kids"), subtitle: String(localized: "count as half portions"), systemImage: "figure.child", value: $kids, range: 0...10)
            HStack(spacing: Theme.Spacing.s) {
                Image(systemName: "fork.knife").foregroundStyle(Theme.tomato)
                Text(portionsText)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.aubergine)
                    .contentTransition(.numericText())
                    .monospacedDigit()
            }
            .padding(Theme.Spacing.l)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(Theme.saffronSoft))
            .animation(Theme.spring, value: portions)
        }
    }

    private var portionsText: String {
        let value: String = FractionFormatter.string(portions)
        return portions == 1 ? String(localized: "1 portion per meal") : String(localized: "\(value) portions per meal")
    }
}

/// "−  2  +" stepper row with 44 pt buttons.
struct CountStepperRow: View {
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.tomato)
                    .frame(width: 32)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(.body, design: .rounded).weight(.semibold)).foregroundStyle(Theme.aubergine)
                if let subtitle {
                    Text(subtitle).font(.caption).foregroundStyle(Theme.aubergineMuted)
                }
            }
            Spacer(minLength: 8)
            RoundStepper(value: $value, range: range)
        }
        .padding(Theme.Spacing.l)
        .background(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).fill(Theme.card))
        .overlay(RoundedRectangle(cornerRadius: Theme.Radius.button, style: .continuous).stroke(Theme.line, lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text("\(value)"))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: if value < range.upperBound { value += 1 }
            case .decrement: if value > range.lowerBound { value -= 1 }
            @unknown default: break
            }
        }
    }
}

/// Compact "− n +" control.
struct RoundStepper: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    var suffix: String = ""

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            stepButton(systemImage: "minus", enabled: value > range.lowerBound) { value -= 1 }
            Text("\(value)\(suffix)")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .monospacedDigit()
                .foregroundStyle(Theme.aubergine)
                .frame(minWidth: 32)
                .contentTransition(.numericText())
                .animation(Theme.spring, value: value)
            stepButton(systemImage: "plus", enabled: value < range.upperBound) { value += 1 }
        }
        .sensoryFeedback(.selection, trigger: value)
    }

    private func stepButton(systemImage: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(enabled ? Theme.tomato : Theme.aubergineFaint)
                .frame(width: 44, height: 44)
                .background(Circle().fill(enabled ? Theme.tomatoSoft : Theme.creamDeep))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(Text(systemImage == "plus" ? "Increase" : "Decrease"))
    }
}

#Preview {
    HouseholdEditor(adults: .constant(2), kids: .constant(1)).padding().creamBackground()
}
