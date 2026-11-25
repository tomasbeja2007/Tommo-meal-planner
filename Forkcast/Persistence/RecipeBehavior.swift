import Foundation
import SwiftData
import ForkcastCore

/// Append-only observations, except when undoing a meal's cooked checkbox.
@Model
final class RecipeBehavior {
    var recipeId: String = ""
    var kindRaw: String = ""
    var occurredAt: Date = Date()
    var stars: Int? = nil
    var mealID: UUID? = nil

    init(recipeId: String, kind: TasteEvent.Kind, date: Date, stars: Int? = nil, mealID: UUID? = nil) {
        self.recipeId = recipeId
        kindRaw = kind.rawValue
        occurredAt = date
        self.stars = stars
        self.mealID = mealID
    }

    var event: TasteEvent? {
        guard let kind = TasteEvent.Kind(rawValue: kindRaw), !recipeId.isEmpty else { return nil }
        return TasteEvent(recipeId: recipeId, kind: kind, date: occurredAt, stars: stars)
    }
}

@MainActor
enum RecipeBehaviorLog {
    static func record(_ kind: TasteEvent.Kind, recipeId: String, in context: ModelContext,
                       date: Date = Date(), stars: Int? = nil, mealID: UUID? = nil) {
        context.insert(RecipeBehavior(recipeId: recipeId, kind: kind, date: date, stars: stars, mealID: mealID))
    }

    static func matchingMeal(_ id: UUID, in context: ModelContext) -> [RecipeBehavior] {
        let target: UUID? = id
        let descriptor = FetchDescriptor<RecipeBehavior>(predicate: #Predicate { $0.mealID == target })
        return (try? context.fetch(descriptor)) ?? []
    }

    static func recordCook(recipeId: String, in context: ModelContext, date: Date, mealID: UUID?) {
        let cooked = TasteEvent.Kind.cooked.rawValue
        let repeated = TasteEvent.Kind.cookedAgain.rawValue
        var descriptor = FetchDescriptor<RecipeBehavior>(predicate: #Predicate {
            $0.recipeId == recipeId && ($0.kindRaw == cooked || $0.kindRaw == repeated)
        })
        descriptor.fetchLimit = 1
        let count = (try? context.fetchCount(descriptor)) ?? 0
        record(count > 0 ? .cookedAgain : .cooked, recipeId: recipeId, in: context, date: date, mealID: mealID)
    }

    static func events(in context: ModelContext, asOf: Date) -> [TasteEvent] {
        let stored = (try? context.fetch(FetchDescriptor<RecipeBehavior>())) ?? []
        var events = stored.compactMap(\.event)
        let calendar = WeekMath.gregorian
        let cutoff = asOf.addingTimeInterval(-26 * 7 * 24 * 3600)
        let plans = (try? context.fetch(FetchDescriptor<WeekPlan>(sortBy: [
            SortDescriptor(\WeekPlan.createdAt, order: .reverse)
        ]))) ?? []
        let recordedSkips = Set(stored.filter { $0.kindRaw == TasteEvent.Kind.skipped.rawValue }.compactMap(\.mealID))
        let recordedCooks = Set(stored.filter {
            $0.kindRaw == TasteEvent.Kind.cooked.rawValue || $0.kindRaw == TasteEvent.Kind.cookedAgain.rawValue
        }.compactMap(\.mealID))
        var seenWeeks: Set<Date> = []
        var writes = false
        for plan in plans where seenWeeks.insert(calendar.startOfDay(for: plan.weekStartDate)).inserted {
            guard let end = calendar.date(byAdding: .day, value: 7, to: plan.weekStartDate) else { continue }
            for meal in plan.sortedMeals {
                if plan.createdAt <= asOf {
                    events.append(TasteEvent(recipeId: meal.recipeId, kind: .planned, date: plan.createdAt))
                }
                // Leftovers are a second serving of a cook, so they carry no separate learning signal.
                guard meal.leftoversFromMealID == nil else { continue }
                if let cookedAt = meal.cookedAt, meal.plannerMealID.map(recordedCooks.contains) != true {
                    events.append(TasteEvent(recipeId: meal.recipeId, kind: .cooked, date: cookedAt))
                }
                guard !meal.isCooked, end <= asOf, end >= cutoff else { continue }
                let id = meal.ensurePlannerMealID()
                guard !recordedSkips.contains(id) else { continue }
                record(.skipped, recipeId: meal.recipeId, in: context, date: end, mealID: id)
                events.append(TasteEvent(recipeId: meal.recipeId, kind: .skipped, date: end))
                writes = true
            }
        }
        if writes { try? context.save() }

        let ratingKinds: Set<TasteEvent.Kind> = [.liked, .notForMe, .ratingCleared]
        let recordedRatings = Set(events.filter { ratingKinds.contains($0.kind) }.map(\.recipeId))
        let recordedStars = Set(events.filter { $0.kind == .stars }.map(\.recipeId))
        for row in (try? context.fetch(FetchDescriptor<RecipeFeedback>())) ?? [] {
            if let rating = row.rating, !recordedRatings.contains(row.recipeId) {
                events.append(TasteEvent(recipeId: row.recipeId, kind: rating == .like ? .liked : .notForMe, date: row.date))
            }
            if row.stars > 0 && !recordedStars.contains(row.recipeId) {
                events.append(TasteEvent(recipeId: row.recipeId, kind: .stars, date: row.date, stars: row.stars))
            }
        }
        for row in (try? context.fetch(FetchDescriptor<SavedRecipe>())) ?? [] {
            events.append(TasteEvent(recipeId: row.recipeId, kind: .saved, date: row.savedAt))
        }
        return events
    }
}
