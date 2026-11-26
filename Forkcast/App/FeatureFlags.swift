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
    static let reviewRequestedKey: String = "review.askedAfterFirstCook"

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
    static let licenseAgreement: URL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    static let appleAccount: URL = URL(string: "https://account.apple.com/")!
    static let support: URL = URL(string: "https://tomasbeja2007.github.io/Tommo-meal-planner/support.html")!
    static let supportEmail: String = "tomasbeja2007@icloud.com"

    /// The numeric Apple ID from App Store Connect (App Information → Apple ID). Set it to show "Rate Tommo".
    static let appStoreId: String? = nil
    static var writeReview: URL? {
        appStoreId.flatMap { URL(string: "https://apps.apple.com/app/id\($0)?action=write-review") }
    }

    static func mail(subject: String) -> URL? {
        let encoded: String = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "mailto:\(supportEmail)?subject=\(encoded)")
    }
}
