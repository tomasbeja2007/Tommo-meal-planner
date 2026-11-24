import Foundation
import WidgetKit
import ForkcastCore

/// Writes today + the next 6 days to the App Group for the widget,
/// then asks WidgetKit to reload. The widget never touches SwiftData.
@MainActor
enum WidgetSnapshotWriter {
    static func write(meals: [PlannedMeal], repository: RecipeRepository, now: Date = Date()) {
        let calendar: Calendar = WeekMath.gregorian
        let days: [Date] = WeekMath.days(from: now)
        var entries: [WidgetSnapshot.Day] = []
        for day in days {
            if let meal = meals.first(where: { calendar.isDate($0.date, inSameDayAs: day) }),
               let recipe = repository.recipe(id: meal.recipeId) {
                let macros = repository.nutrition(for: recipe).macros
                entries.append(WidgetSnapshot.Day(
                    date: day,
                    recipeId: recipe.id,
                    title: recipe.title,
                    emoji: recipe.emoji,
                    colorHex: DishPalette.hex(for: recipe.id),
                    minutes: recipe.totalMinutes,
                    servings: Int(meal.servings.rounded()),
                    macrosLine: MacrosText.compact(macros)
                ))
            } else {
                entries.append(WidgetSnapshot.Day(date: day, recipeId: nil, title: nil, emoji: nil, colorHex: nil, minutes: nil, servings: nil, macrosLine: nil))
            }
        }
        let snapshot = WidgetSnapshot(generatedAt: now, days: entries)
        do {
            try snapshot.write()
        } catch {
            PersistenceController.logger.error("Widget snapshot write failed: \(String(describing: error), privacy: .public)")
        }
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func clear() {
        try? WidgetSnapshot.empty.write()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
