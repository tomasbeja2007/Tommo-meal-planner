import SwiftUI
import UIKit
import ForkcastCore

/// Intentional-looking photo placeholder: a warm colour chosen deterministically
/// from the recipe id, a big emoji, and a soft highlight + diagonal texture.
/// If `imageName` names a real asset, that image is shown instead.
struct DishTileView: View {
    let seed: String
    let emoji: String
    var imageName: String? = nil
    var size: CGFloat = 72
    /// Height override for hero tiles; defaults to a square.
    var height: CGFloat? = nil
    var cornerRadius: CGFloat? = nil

    init(seed: String, emoji: String, imageName: String? = nil, size: CGFloat = 72, height: CGFloat? = nil, cornerRadius: CGFloat? = nil) {
        self.seed = seed
        self.emoji = emoji
        self.imageName = imageName
        self.size = size
        self.height = height
        self.cornerRadius = cornerRadius
    }

    init(recipe: Recipe, size: CGFloat = 72, height: CGFloat? = nil, cornerRadius: CGFloat? = nil) {
        self.init(seed: recipe.id, emoji: recipe.emoji, imageName: recipe.imageName, size: size, height: height, cornerRadius: cornerRadius)
    }

    private var tileColor: Color {
        Color(hexString: DishPalette.hex(for: seed))
    }

    private var radius: CGFloat {
        cornerRadius ?? min(Theme.Radius.card, size * 0.28)
    }

    private var resolvedHeight: CGFloat { height ?? size }

    /// Use supplied photography first, then bundled illustrative artwork.
    var photoName: String? {
        if let imageName, AssetImage.exists(imageName) { return imageName }
        let conventional = "recipe-" + seed
        if AssetImage.exists(conventional) { return conventional }
        let illustrative = "illustrative-recipe-" + seed
        return AssetImage.exists(illustrative) ? illustrative : nil
    }

    var body: some View {
        ZStack {
            if let photo = photoName {
                Image(photo)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(width: size, height: resolvedHeight)
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        .accessibilityHidden(true)
    }

    private var placeholder: some View {
        ZStack {
            tileColor
            DiagonalStripes(spacing: max(8, size * 0.09))
                .stroke(Color.white.opacity(0.07), lineWidth: max(1, size * 0.02))
            RadialGradient(
                colors: [Color.white.opacity(0.35), Color.white.opacity(0)],
                center: UnitPoint(x: 0.3, y: 0.25),
                startRadius: 0,
                endRadius: max(size, resolvedHeight) * 0.8
            )
            Text(emoji)
                .font(.system(size: min(size, resolvedHeight) * 0.5))
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }
}

/// A full-bleed variant for hero headers (stretches to the available width).
struct DishHeroView: View {
    let recipe: Recipe
    var height: CGFloat = 260

    var body: some View {
        GeometryReader { proxy in
            let tile = DishTileView(recipe: recipe, size: proxy.size.width, height: height, cornerRadius: 0)
            tile.overlay(alignment: .bottomTrailing) {
                if tile.photoName?.hasPrefix("illustrative-recipe-") == true {
                    Text("Illustrative photo")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.aubergine)
                        .padding(.horizontal, Theme.Spacing.s)
                        .padding(.vertical, Theme.Spacing.xs)
                        .background(Theme.card, in: Capsule())
                        .padding(Theme.Spacing.s)
                }
            }
        }
        .frame(height: height)
    }
}

/// Diagonal hairline pattern for tile texture.
struct DiagonalStripes: Shape {
    var spacing: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let total: CGFloat = rect.width + rect.height
        var x: CGFloat = -rect.height
        while x < total {
            path.move(to: CGPoint(x: x, y: rect.maxY))
            path.addLine(to: CGPoint(x: x + rect.height, y: rect.minY))
            x += spacing
        }
        return path
    }
}

/// Catalog entries share the same bundled photo across all ingredient surfaces.
struct IngredientThumbnail: View {
    let ingredientID: String?
    var size: CGFloat = 36
    var showsBackground: Bool = true

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
        .background(showsBackground ? Theme.creamDeep : Color.clear, in: RoundedRectangle(cornerRadius: size * 0.25))
        .accessibilityHidden(true)
    }
}

#Preview("Dish tiles") {
    HStack(spacing: Theme.Spacing.m) {
        DishTileView(seed: "creamy-tomato-pasta", emoji: "🍝", size: 72)
        DishTileView(seed: "black-bean-tacos", emoji: "🌮", size: 72)
        DishTileView(seed: "chickpea-curry", emoji: "🍛", size: 72)
        DishTileView(seed: "miso-salmon", emoji: "🍣", size: 72)
    }
    .padding()
    .creamBackground()
}
