import SwiftUI
import UIKit

/// Catalog entries share the same bundled photo across all ingredient surfaces.
struct IngredientThumbnail: View {
    let ingredientID: String?
    var size: CGFloat = 36

    private var photo: UIImage? {
        ingredientID.flatMap { UIImage(named: "ingredient-\($0)") }
    }

    var body: some View {
        Group {
            if let photo {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "basket")
                    .font(.system(size: size * 0.46, weight: .medium))
                    .foregroundStyle(Theme.aubergineMuted)
            }
        }
        .frame(width: size, height: size)
        .background(Theme.creamDeep, in: RoundedRectangle(cornerRadius: size * 0.25))
        .accessibilityHidden(true)
    }
}
