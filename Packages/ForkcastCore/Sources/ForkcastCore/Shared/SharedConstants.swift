import Foundation

/// Identifiers shared by the app, the widget and the share extension.
/// Keep in sync with project.yml entitlements.
public enum SharedConstants {
    public static let appGroupId: String = "group.com.tomasbeja.tommo"
    public static let cloudKitContainerId: String = "iCloud.com.tomasbeja.tommo"
    public static let urlScheme: String = "forkcast"
    public static let widgetSnapshotFileName: String = "widget-snapshot.json"
    public static let pendingImportFileName: String = "pending-import.json"
    public static let widgetKind: String = "TonightsDinnerWidget"

    /// The shared App Group container, or nil when the entitlement is missing
    /// (e.g. unsigned builds or unit tests).
    public static func appGroupContainerURL() -> URL? {
        #if os(iOS) || os(macOS)
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        #else
        return nil
        #endif
    }
}
