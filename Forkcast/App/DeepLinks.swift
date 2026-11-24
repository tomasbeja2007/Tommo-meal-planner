import Foundation
import ForkcastCore

/// forkcast://recipe/<id>, forkcast://import, forkcast://plan, forkcast://groceries
enum DeepLink: Equatable {
    case recipe(String)
    case importRecipe
    case plan
    case groceries

    init?(url: URL) {
        guard url.scheme?.lowercased() == SharedConstants.urlScheme else { return nil }
        let host: String = url.host?.lowercased() ?? ""
        let parts: [String] = url.pathComponents.filter { $0 != "/" }
        switch host {
        case "recipe":
            guard let id = parts.first, !id.isEmpty else { return nil }
            self = .recipe(id.removingPercentEncoding ?? id)
        case "import":
            self = .importRecipe
        case "plan":
            self = .plan
        case "groceries":
            self = .groceries
        default:
            return nil
        }
    }

    static func recipeURL(_ id: String) -> URL? {
        let encoded: String = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
        return URL(string: "\(SharedConstants.urlScheme)://recipe/\(encoded)")
    }
}
