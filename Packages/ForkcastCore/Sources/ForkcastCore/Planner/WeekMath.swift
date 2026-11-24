import Foundation

public enum WeekMath {
    public static let englishShortWeekdays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    public static let englishInitials: [String] = ["M", "T", "W", "T", "F", "S", "S"]

    public static var gregorian: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }

    /// ISO weekday for a date: 1 = Monday ... 7 = Sunday.
    public static func isoWeekday(_ date: Date, calendar: Calendar = WeekMath.gregorian) -> Int {
        let weekday: Int = calendar.component(.weekday, from: date) // 1 = Sunday
        return ((weekday + 5) % 7) + 1
    }

    /// The 7 days starting at `start` (start of day).
    public static func days(from start: Date, calendar: Calendar = WeekMath.gregorian) -> [Date] {
        let first: Date = calendar.startOfDay(for: start)
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: first)
        }
    }

    /// Slots for the cooking days within the 7-day window starting at `start`.
    public static func slots(from start: Date, cookingDays: Set<Int>, calendar: Calendar = WeekMath.gregorian) -> [PlanSlot] {
        let dates: [Date] = days(from: start, calendar: calendar)
        var result: [PlanSlot] = []
        for date in dates {
            let weekday: Int = isoWeekday(date, calendar: calendar)
            if cookingDays.contains(weekday) {
                result.append(PlanSlot(index: result.count, date: date, weekday: weekday))
            }
        }
        return result
    }

    /// Whole weeks between two dates (>= 0).
    public static func weeksBetween(_ earlier: Date, _ later: Date) -> Int {
        let seconds: TimeInterval = later.timeIntervalSince(earlier)
        return max(0, Int((seconds / (7 * 24 * 3600)).rounded(.down)))
    }
}
