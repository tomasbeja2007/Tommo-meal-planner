import SwiftUI
import ForkcastCore

/// Paste a link or caption → review the pre-filled recipe.
struct ImportRecipeView: View {
    var initialText: String? = nil

    @Environment(RecipeRepository.self) private var repository: RecipeRepository
    @Environment(AppRouter.self) private var router: AppRouter
    @Environment(\.dismiss) private var dismiss: DismissAction

    @State private var text: String = ""
    @State private var isWorking: Bool = false
    @State private var message: String? = nil
    @State private var draft: RecipeDraft? = nil
    @State private var didPrefill: Bool = false
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    Text("Paste a TikTok or Instagram link, or the recipe text itself. You can also share straight to Forkcast from those apps.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.aubergineMuted)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                        Text("Link or caption")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(Theme.aubergine)
                        TextField(String(localized: "Paste a link or the recipe text…"), text: $text, axis: .vertical)
                            .lineLimit(5...12)
                            .focused($focused)
                            .textInputAutocapitalization(.sentences)
                            .padding(Theme.Spacing.m)
                            .background(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).fill(Theme.cream))
                            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.input, style: .continuous).stroke(focused ? Theme.tomato : Theme.line, lineWidth: focused ? 2 : 1))
                        HStack {
                            PasteButton(payloadType: String.self) { strings in
                                if let first = strings.first {
                                    text = first
                                }
                            }
                            .buttonBorderShape(.capsule)
                            .tint(Theme.tomato)
                            Spacer()
                        }
                        if let message {
                            Label(message, systemImage: "info.circle")
                                .font(.subheadline)
                                .foregroundStyle(Theme.tomatoDeep)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .cardStyle()
                    VStack(alignment: .leading, spacing: Theme.Spacing.m) {
                        Text("Share from TikTok or Instagram")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(Theme.aubergine)
                        ImportStepRow(number: 1, text: String(localized: "Open the recipe video"))
                        ImportStepRow(number: 2, text: String(localized: "Tap Share, then Forkcast (you may need to tap More first)"))
                        ImportStepRow(number: 3, text: String(localized: "Come back here to check and save it"))
                    }
                    .cardStyle()
                }
                .padding(Theme.Spacing.gutter)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(String(localized: "Import recipe"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { close() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: runImport) {
                    HStack(spacing: Theme.Spacing.s) {
                        if isWorking { ProgressView().tint(Color.white) }
                        Text(isWorking ? String(localized: "Reading the recipe…") : String(localized: "Import"))
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isWorking || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal, Theme.Spacing.gutter)
                .padding(.vertical, Theme.Spacing.s)
                .background(Theme.cream.opacity(0.97).ignoresSafeArea())
            }
            .fullScreenCover(item: $draft) { item in
                CreateRecipeView(draft: item) { recipeId in
                    close()
                    router.selectedTab = .recipes
                    router.recipesPath.append(RecipeRoute(recipeId: recipeId))
                }
            }
        }
        .onAppear {
            guard !didPrefill else { return }
            didPrefill = true
            if let initialText, !initialText.isEmpty {
                text = initialText
                runImport()
            } else {
                focused = true
            }
        }
    }

    private func runImport() {
        isWorking = true
        message = nil
        Task {
            let outcome = await RecipeImportService.importRecipe(from: text, catalog: repository.catalog)
            isWorking = false
            switch outcome {
            case .draft(let result):
                draft = result
            case .needsCaption(let note):
                message = note
                text += "\n\n"
                focused = true
            case .failed(let note):
                message = note
            }
        }
    }

    private func close() {
        router.pendingImportText = nil
        router.isImportPresented = false
        dismiss()
    }
}

#Preview { ImportRecipeView().previewEnvironment() }
