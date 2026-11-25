import Foundation

enum FeatureFlags {
    #if DEBUG
    /// Flip to true to skip the paywall entirely in debug builds.
    static let bypassPaywall: Bool = false
    #else
    static let bypassPaywall: Bool = false
    #endif

    /// UserDefaults key for the hidden debug menu's "Toggle Pro" switch.
    static let debugProOverrideKey: String = "debug.proOverride"

    static var debugProOverride: Bool {
        #if DEBUG
        return UserDefaults.standard.bool(forKey: debugProOverrideKey)
        #else
        return false
        #endif
    }
}

/// Public pages (GitHub Pages, served from /docs in this repo).
enum AppLinks {
    static let website: URL = URL(string: "https://tomasbeja2007.github.io/Tommo-meal-planner/")!
    static let privacyPolicy: URL = URL(string: "https://tomasbeja2007.github.io/Tommo-meal-planner/privacy.html")!
    static let terms: URL = URL(string: "https://tomasbeja2007.github.io/Tommo-meal-planner/terms.html")!
    static let support: URL = URL(string: "https://tomasbeja2007.github.io/Tommo-meal-planner/support.html")!
    /// Placeholder: replace with the real support inbox before launch.
    static let supportEmail: String = "hello@forkcast.app"

    static func mail(subject: String) -> URL? {
        let encoded: String = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "mailto:\(supportEmail)?subject=\(encoded)")
    }
}
