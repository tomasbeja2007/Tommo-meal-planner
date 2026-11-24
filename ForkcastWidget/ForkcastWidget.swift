import WidgetKit
import SwiftUI
import ForkcastCore

// "Tonight's dinner". Reads widget-snapshot.json from the App Group (never SwiftData).

@main
struct ForkcastWidgetBundle: WidgetBundle {
    var body: some Widget {
        TonightsDinnerWidget()
    }
}

struct TonightsDinnerWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: SharedConstants.widgetKind, provider: DinnerProvider()) { entry in
            DinnerWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    WidgetPalette.cream
                }
        }
        .configurationDisplayName("Tonight's dinner")
        .description("See what's for dinner tonight, and tomorrow.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DinnerEntry: TimelineEntry {
    let date: Date
    let tonight: WidgetSnapshot.Day?
    let tomorrow: WidgetSnapshot.Day?

    static let placeholder = DinnerEntry(
        date: Date(),
        tonight: WidgetSnapshot.Day(date: Date(), recipeId: "chickpea-spinach-curry", title: "Chickpea & spinach coconut curry", emoji: "🍛", colorHex: "#E35E48", minutes: 30, servings: 2, macrosLine: "730 kcal · 20g P · 98g C · 30g F"),
        tomorrow: WidgetSnapshot.Day(date: Date().addingTimeInterval(86_400), recipeId: "black-bean-tacos", title: "Smoky black bean tacos", emoji: "🌮", colorHex: "#EBB552", minutes: 20, servings: 2, macrosLine: nil)
    )
}

struct DinnerProvider: TimelineProvider {
    func placeholder(in context: Context) -> DinnerEntry {
        DinnerEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (DinnerEntry) -> Void) {
        if context.isPreview {
            completion(DinnerEntry.placeholder)
        } else {
            completion(entry(for: Date(), snapshot: WidgetSnapshot.load()))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DinnerEntry>) -> Void) {
        let snapshot: WidgetSnapshot? = WidgetSnapshot.load()
        let calendar: Calendar = Calendar.current
        let now: Date = Date()
        var entries: [DinnerEntry] = [entry(for: now, snapshot: snapshot)]
        // A fresh entry at each of the next 6 midnights.
        var day: Date = calendar.startOfDay(for: now)
        for _ in 0..<6 {
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
            entries.append(entry(for: next, snapshot: snapshot))
        }
        let refresh: Date = calendar.date(byAdding: .day, value: 1, to: day) ?? now.addingTimeInterval(86_400)
        completion(Timeline(entries: entries, policy: .after(refresh)))
    }

    private func entry(for date: Date, snapshot: WidgetSnapshot?) -> DinnerEntry {
        let calendar: Calendar = Calendar.current
        let tonight: WidgetSnapshot.Day? = snapshot?.days.first { calendar.isDate($0.date, inSameDayAs: date) && $0.hasDinner }
        let tomorrowDate: Date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        let tomorrow: WidgetSnapshot.Day? = snapshot?.days.first { calendar.isDate($0.date, inSameDayAs: tomorrowDate) && $0.hasDinner }
        return DinnerEntry(date: date, tonight: tonight, tomorrow: tomorrow)
    }
}

enum WidgetPalette {
    static let cream = Color(red: 251 / 255, green: 246 / 255, blue: 238 / 255)
    static let tomato = Color(red: 232 / 255, green: 85 / 255, blue: 61 / 255)
    static let aubergine = Color(red: 43 / 255, green: 30 / 255, blue: 46 / 255)
    static let muted = Color(red: 110 / 255, green: 95 / 255, blue: 107 / 255)
    static let faint = Color(red: 168 / 255, green: 155 / 255, blue: 165 / 255)

    static func color(hex: String?) -> Color {
        guard var text = hex else { return tomato }
        if text.hasPrefix("#") { text.removeFirst() }
        guard let value = UInt32(text, radix: 16) else { return tomato }
        return Color(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}

struct DinnerWidgetView: View {
    let entry: DinnerEntry
    @Environment(\.widgetFamily) private var family: WidgetFamily

    var body: some View {
        Group {
            if let tonight = entry.tonight {
                switch family {
                case .systemMedium:
                    MediumDinnerView(tonight: tonight, tomorrow: entry.tomorrow)
                default:
                    SmallDinnerView(tonight: tonight)
                }
            } else {
                NoDinnerView(isMedium: family == .systemMedium, tomorrow: entry.tomorrow)
            }
        }
        .fontDesign(.rounded)
        .widgetURL(url)
    }

    private var url: URL? {
        if let id = entry.tonight?.recipeId {
            let encoded: String = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
            return URL(string: "\(SharedConstants.urlScheme)://recipe/\(encoded)")
        }
        return URL(string: "\(SharedConstants.urlScheme)://plan")
    }
}

private struct WidgetDishTile: View {
    let day: WidgetSnapshot.Day
    var size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.26, style: .continuous)
                .fill(WidgetPalette.color(hex: day.colorHex))
            RoundedRectangle(cornerRadius: size * 0.26, style: .continuous)
                .fill(RadialGradient(colors: [Color.white.opacity(0.35), Color.white.opacity(0)], center: UnitPoint(x: 0.3, y: 0.25), startRadius: 0, endRadius: size))
            Text(day.emoji ?? "🍽️")
                .font(.system(size: size * 0.5))
        }
        .frame(width: size, height: size)
    }
}

private struct SmallDinnerView: View {
    let tonight: WidgetSnapshot.Day

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            WidgetDishTile(day: tonight, size: 52)
            Spacer(minLength: 0)
            Text("tonight")
                .font(.caption2.weight(.heavy))
                .textCase(.uppercase)
                .foregroundStyle(WidgetPalette.tomato)
            Text(tonight.title ?? "")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(WidgetPalette.aubergine)
                .lineLimit(3)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

private struct MediumDinnerView: View {
    let tonight: WidgetSnapshot.Day
    let tomorrow: WidgetSnapshot.Day?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            WidgetDishTile(day: tonight, size: 84)
            VStack(alignment: .leading, spacing: 4) {
                Text("tonight")
                    .font(.caption2.weight(.heavy))
                    .textCase(.uppercase)
                    .foregroundStyle(WidgetPalette.tomato)
                Text(tonight.title ?? "")
                    .font(.headline)
                    .foregroundStyle(WidgetPalette.aubergine)
                    .lineLimit(2)
                HStack(spacing: 8) {
                    if let minutes = tonight.minutes {
                        Label("\(minutes) min", systemImage: "clock")
                    }
                    if let servings = tonight.servings {
                        Label("\(servings)", systemImage: "person.2")
                    }
                }
                .font(.caption)
                .foregroundStyle(WidgetPalette.muted)
                if let macros = tonight.macrosLine {
                    Text(macros)
                        .font(.caption2)
                        .monospacedDigit()
                        .foregroundStyle(WidgetPalette.faint)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                Spacer(minLength: 0)
                if let tomorrow, let title = tomorrow.title {
                    Text("tomorrow: \(title)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(WidgetPalette.muted)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 0)
        }
    }
}

private struct NoDinnerView: View {
    let isMedium: Bool
    let tomorrow: WidgetSnapshot.Day?

    var body: some View {
        HStack(spacing: 12) {
            Image("WidgetMascot")
                .resizable()
                .scaledToFit()
                .frame(width: isMedium ? 76 : 56, height: isMedium ? 76 : 56)
            VStack(alignment: .leading, spacing: 4) {
                Text("no dinner planned tonight")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(WidgetPalette.aubergine)
                    .lineLimit(3)
                if isMedium, let title = tomorrow?.title {
                    Text("tomorrow: \(title)")
                        .font(.caption)
                        .foregroundStyle(WidgetPalette.muted)
                        .lineLimit(2)
                }
            }
            if isMedium { Spacer(minLength: 0) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isMedium ? .leading : .center)
    }
}

#Preview(as: .systemSmall) {
    TonightsDinnerWidget()
} timeline: {
    DinnerEntry.placeholder
    DinnerEntry(date: Date(), tonight: nil, tomorrow: nil)
}

#Preview(as: .systemMedium) {
    TonightsDinnerWidget()
} timeline: {
    DinnerEntry.placeholder
}
