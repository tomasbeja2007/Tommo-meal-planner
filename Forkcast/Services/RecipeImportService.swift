import Foundation
import ForkcastCore

/// Turns a TikTok / Instagram link or pasted caption into a pre-filled draft.
///
/// 1. TikTok links: fetch the public oEmbed endpoint for the caption.
///    Instagram links: captions can't be read without a key, so ask for a paste.
/// 2. Parse: Apple's on-device model when available (iOS 26+), else heuristics.
/// 3. The Create screen opens pre-filled for review.
enum RecipeImportService {
    enum Outcome {
        case draft(RecipeDraft)
        /// Instagram link with no caption text: ask the user to paste it.
        case needsCaption(message: String)
        case failed(message: String)
    }

    struct TikTokOEmbed: Decodable {
        let title: String?
        let author_name: String?
    }

    static func detectURL(in text: String) -> URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        let ns: NSString = text as NSString
        let match = detector.firstMatch(in: text, options: [], range: NSRange(location: 0, length: ns.length))
        return match?.url
    }

    static func kind(for url: URL?) -> RecipeSourceKind {
        guard let host = url?.host?.lowercased() else { return .pasted }
        if host.contains("tiktok.com") { return .tiktok }
        if host.contains("instagram.com") { return .instagram }
        return .pasted
    }

    static func fetchTikTokCaption(for url: URL) async -> TikTokOEmbed? {
        var components = URLComponents(string: "https://www.tiktok.com/oembed")
        components?.queryItems = [URLQueryItem(name: "url", value: url.absoluteString)]
        guard let endpoint = components?.url else { return nil }
        var request = URLRequest(url: endpoint)
        request.timeoutInterval = 12
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { return nil }
            return try JSONDecoder().decode(TikTokOEmbed.self, from: data)
        } catch {
            return nil
        }
    }

    @MainActor
    static func importRecipe(from input: String, catalog: FoodCatalog) async -> Outcome {
        let trimmed: String = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return .failed(message: String(localized: "Paste a link or the recipe text first."))
        }
        let url: URL? = detectURL(in: trimmed)
        let sourceKind: RecipeSourceKind = kind(for: url)
        // Everything that isn't the link itself.
        var text: String = trimmed
        if let url {
            text = text.replacingOccurrences(of: url.absoluteString, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var author: String? = nil
        if sourceKind == .tiktok, let url, let embed = await fetchTikTokCaption(for: url) {
            if let caption = embed.title, !caption.isEmpty {
                text = text.isEmpty ? caption : caption + "\n" + text
            }
            author = embed.author_name
        }
        if sourceKind == .instagram && text.isEmpty {
            return .needsCaption(message: String(localized: "Instagram doesn't let apps read captions. Paste the caption text below"))
        }

        let parsed: ParsedRecipe = await parse(text)
        var draft = RecipeDraft(parsed: parsed, sourceURL: url?.absoluteString, kind: sourceKind, catalog: catalog)
        if draft.title.isEmpty {
            if let author {
                draft.title = String(localized: "Recipe from @\(author)")
            } else {
                draft.title = String(localized: "Imported recipe")
            }
        }
        return .draft(draft)
    }

    /// On-device model when available, otherwise the heuristic parser.
    static func parse(_ text: String) async -> ParsedRecipe {
        if text.isEmpty { return ParsedRecipe() }
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            if FoundationModelRecipeExtractor.isAvailable,
               let result = try? await FoundationModelRecipeExtractor.extract(from: text),
               result.hasContent {
                return result
            }
        }
        #endif
        return RecipeTextParser.parse(text)
    }
}
