import Foundation

/// Lightweight data the app writes to the App Group for the widget.
/// The widget never touches SwiftData.
public struct WidgetSnapshot: Codable, Hashable, Sendable {
    public struct Day: Codable, Hashable, Sendable {
        public let date: Date
        public let recipeId: String?
        public let title: String?
        public let emoji: String?
        public let colorHex: String?
        public let minutes: Int?
        public let servings: Int?
        public let macrosLine: String?

        public init(date: Date, recipeId: String?, title: String?, emoji: String?, colorHex: String?, minutes: Int?, servings: Int?, macrosLine: String?) {
            self.date = date
            self.recipeId = recipeId
            self.title = title
            self.emoji = emoji
            self.colorHex = colorHex
            self.minutes = minutes
            self.servings = servings
            self.macrosLine = macrosLine
        }

        public var hasDinner: Bool { recipeId != nil }
    }

    public let generatedAt: Date
    public let days: [Day]

    public init(generatedAt: Date, days: [Day]) {
        self.generatedAt = generatedAt
        self.days = days
    }

    public static let empty: WidgetSnapshot = WidgetSnapshot(generatedAt: Date(timeIntervalSince1970: 0), days: [])

    public func day(for date: Date, calendar: Calendar = WeekMath.gregorian) -> Day? {
        days.first { calendar.isDate($0.date, inSameDayAs: date) }
    }

    public static func encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    public static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    /// Reads the snapshot from the App Group container (nil if absent).
    public static func load(from directory: URL? = SharedConstants.appGroupContainerURL()) -> WidgetSnapshot? {
        guard let directory else { return nil }
        let url: URL = directory.appendingPathComponent(SharedConstants.widgetSnapshotFileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder().decode(WidgetSnapshot.self, from: data)
    }

    public func write(to directory: URL? = SharedConstants.appGroupContainerURL()) throws {
        guard let directory else { return }
        let url: URL = directory.appendingPathComponent(SharedConstants.widgetSnapshotFileName)
        let data: Data = try WidgetSnapshot.encoder().encode(self)
        try data.write(to: url, options: [.atomic])
    }
}

/// Payload the Share Extension leaves for the main app.
public struct PendingImport: Codable, Hashable, Sendable {
    public let url: String?
    public let text: String?
    public let createdAt: Date

    public init(url: String?, text: String?, createdAt: Date = Date()) {
        self.url = url
        self.text = text
        self.createdAt = createdAt
    }

    public static func fileURL(in directory: URL? = SharedConstants.appGroupContainerURL()) -> URL? {
        directory?.appendingPathComponent(SharedConstants.pendingImportFileName)
    }

    public func write(to directory: URL? = SharedConstants.appGroupContainerURL()) throws {
        guard let url = PendingImport.fileURL(in: directory) else { return }
        let data: Data = try WidgetSnapshot.encoder().encode(self)
        try data.write(to: url, options: [.atomic])
    }

    /// Reads and deletes the pending import, if any.
    public static func consume(from directory: URL? = SharedConstants.appGroupContainerURL()) -> PendingImport? {
        guard let url = fileURL(in: directory), let data = try? Data(contentsOf: url) else { return nil }
        try? FileManager.default.removeItem(at: url)
        return try? WidgetSnapshot.decoder().decode(PendingImport.self, from: data)
    }
}
