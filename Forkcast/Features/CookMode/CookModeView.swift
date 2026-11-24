import SwiftUI
import UIKit
import ForkcastCore

/// Full-screen step-by-step cooking. Keeps the screen awake.
struct CookModeView: View {
    let recipe: Recipe
    let servings: Double
    @Binding var index: Int
    let timer: CountdownTimer
    let isPlanned: Bool
    let onCooked: (Int) -> Void

    @Environment(\.dismiss) private var dismiss: DismissAction
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @Environment(LibraryStore.self) private var library: LibraryStore
    @State private var stars: Int = 0

    private var stepCount: Int { recipe.steps.count }
    private var isFinished: Bool { index >= stepCount }

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            CookModeHeader(index: index, stepCount: stepCount) { dismiss() }
            TabView(selection: $index) {
                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { position, step in
                    CookStepPage(number: position + 1, text: step, recipe: recipe, servings: servings, timer: timer)
                        .tag(position)
                }
                CookFinishedPage(stars: $stars, isPlanned: isPlanned) {
                    onCooked(stars)
                    dismiss()
                }
                .tag(stepCount)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(Theme.motion(reduceMotion), value: index)
            if stepCount > 0 {
                HStack {
                    Button {
                        index -= 1
                    } label: {
                        Label("Previous", systemImage: "chevron.left")
                            .frame(minHeight: 44)
                    }
                    .disabled(index == 0)
                    Spacer()
                    if !isFinished {
                        Button(action: advance) {
                            Label(index == stepCount - 1 ? "Finish" : "Next", systemImage: "chevron.right")
                                .frame(minHeight: 44)
                        }
                    }
                }
                .buttonStyle(.bordered)
                .tint(Theme.tomatoDeep)
                .padding(.horizontal, Theme.Spacing.gutter)
            }
            if timer.isActive {
                TimerPill(timer: timer)
                    .padding(.horizontal, Theme.Spacing.gutter)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.bottom, Theme.Spacing.s)
        .background(Theme.cream.ignoresSafeArea())
        .animation(Theme.spring, value: timer.isActive)
        .sensoryFeedback(.selection, trigger: index)
        .onAppear {
            stars = library.stars[recipe.id] ?? 0
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
    }

    private func advance() {
        guard index < stepCount else { return }
        index += 1
    }
}

private struct CookModeHeader: View {
    let index: Int
    let stepCount: Int
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            ZStack {
                Text(index < stepCount ? String(localized: "STEP \(index + 1) OF \(stepCount)") : String(localized: "DONE"))
                    .font(.system(.subheadline, design: .rounded).weight(.heavy))
                    .tracking(1.2)
                    .foregroundStyle(Theme.tomato)
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Theme.aubergine)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Theme.card))
                    }
                    .accessibilityLabel(Text("Close cook mode"))
                    Spacer()
                }
            }
            HStack(spacing: 4) {
                ForEach(0..<max(1, stepCount), id: \.self) { position in
                    Capsule()
                        .fill(position <= index ? Theme.tomato : Theme.creamDeep)
                        .frame(height: 5)
                }
            }
            .accessibilityHidden(true)
        }
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.top, Theme.Spacing.s)
    }
}

private struct CookStepPage: View {
    let number: Int
    let text: String
    let recipe: Recipe
    let servings: Double
    let timer: CountdownTimer

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.xl) {
                Text("\(number)")
                    .font(.system(.title2, design: .rounded).weight(.heavy))
                    .foregroundStyle(Color.white)
                    .frame(width: 52, height: 52)
                    .background(Circle().fill(Theme.tomato))
                    .accessibilityHidden(true)
                Text(text)
                    .font(.system(.title2, design: .rounded).weight(.medium))
                    .foregroundStyle(Theme.aubergine)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                StepChips(text: text, recipe: recipe, servings: servings, timer: timer)
            }
            .padding(Theme.Spacing.xl)
            .frame(maxWidth: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                .fill(Theme.card)
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, Theme.Spacing.gutter)
        .padding(.vertical, Theme.Spacing.s)
    }
}

private struct CookFinishedPage: View {
    @Binding var stars: Int
    let isPlanned: Bool
    let onMarkCooked: () -> Void

    private var completionTitle: String {
        if isPlanned { return String(localized: "Mark as cooked") }
        return stars > 0 ? String(localized: "Save rating") : String(localized: "Done")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.l) {
                MascotView(size: 110, mood: .cheer)
                Text("Dinner’s ready!")
                    .font(.system(.largeTitle, design: .rounded).weight(.heavy))
                    .foregroundStyle(Theme.aubergine)
                Text("Rate this meal (optional)")
                    .font(.body)
                    .foregroundStyle(Theme.aubergineMuted)
                StarPicker(stars: $stars)
                PrimaryButton(completionTitle, systemImage: "checkmark", action: onMarkCooked)
            }
            .padding(Theme.Spacing.gutter)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    CookModeView(recipe: PreviewData.sampleRecipe, servings: 2, index: .constant(0), timer: CountdownTimer(), isPlanned: true) { _ in }
        .previewEnvironment()
}
