import Foundation
import SwiftData
import Observation
import ForkcastCore

/// Saved recipes and like / not-for-me / star feedback.
@MainActor
@Observable
final class LibraryStore {
    let context: ModelContext
    private(set) var savedIds: [String] = []
    private(set) var ratings: [String: FeedbackRating] = [:]
    private(set) var cookedIds: Set<String> = []
    private(set) var favorites: Set<String> = []
    private(set) var collections: [RecipeCollection] = []
    private(set) var stars: [String: Int] = [:]

    init(context: ModelContext) {
        self.context = context
        reload()
    }

    func reload() {
        let saved: [SavedRecipe] = (try? context.fetch(FetchDescriptor<SavedRecipe>(sortBy: [SortDescriptor(\SavedRecipe.savedAt, order: .reverse)]))) ?? []
        var seen: Set<String> = []
        savedIds = saved.compactMap { item in
            if seen.contains(item.recipeId) { return nil }
            seen.insert(item.recipeId)
            return item.recipeId
        }
        let feedback: [RecipeFeedback] = (try? context.fetch(FetchDescriptor<RecipeFeedback>(sortBy: [SortDescriptor(\RecipeFeedback.date, order: .forward)]))) ?? []
        var newRatings: [String: FeedbackRating] = [:]
        var newStars: [String: Int] = [:]
        var newFavorites: Set<String> = []
        for item in feedback {
            // Latest wins.
            newRatings[item.recipeId] = item.rating
            newStars[item.recipeId] = item.stars > 0 ? item.stars : nil
            if item.isFavorite { newFavorites.insert(item.recipeId) }
            else { newFavorites.remove(item.recipeId) }
        }
        ratings = newRatings
        stars = newStars
        favorites = newFavorites
        cookedIds = Set(feedback.filter { $0.cookedAt != nil }.map(\.recipeId))
        collections = (try? context.fetch(FetchDescriptor<RecipeCollection>(
            sortBy: [SortDescriptor(\.createdAt)]
        ))) ?? []
    }

    var summary: FeedbackSummary {
        FeedbackSummary(
            liked: Set(ratings.filter { $0.value == .like }.map { $0.key }),
            notForMe: Set(ratings.filter { $0.value == .notForMe }.map { $0.key }),
            stars: stars
        )
    }

    var notForMeIds: Set<String> { summary.notForMe }

    func isSaved(_ recipeId: String) -> Bool { savedIds.contains(recipeId) }

    func toggleSaved(_ recipeId: String) {
        let existing: [SavedRecipe] = fetchSaved(recipeId)
        if existing.isEmpty {
            let item = SavedRecipe(recipeId: recipeId)
            context.insert(item)
            RecipeBehaviorLog.record(.saved, recipeId: recipeId, in: context, date: item.savedAt)
        } else {
            for item in existing { context.delete(item) }
            RecipeBehaviorLog.record(.unsaved, recipeId: recipeId, in: context)
        }
        persist()
    }

    func recordCooked(_ recipeId: String) {
        let record = feedbackRecord(for: recipeId)
        record.cookedAt = Date()
        record.date = Date()
        persist()
    }

    func photo(for recipeId: String) -> Data? {
        fetchFeedback(recipeId)?.photoData
    }

    func savePhoto(_ photo: Data?, for recipeId: String) throws {
        let record = feedbackRecord(for: recipeId)
        let previous = record.photoData
        record.photoData = photo
        do {
            try context.save()
        } catch {
            record.photoData = previous
            throw error
        }
    }

    func toggleFavorite(_ recipeId: String) {
        let record = feedbackRecord(for: recipeId)
        record.isFavorite.toggle()
        record.date = Date()
        persist()
    }

    func createCollection(_ title: String) -> String? {
        let name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }
        let collection = RecipeCollection(title: name)
        context.insert(collection)
        do {
            try context.save()
        } catch {
            context.delete(collection)
            return nil
        }
        reload()
        return collection.id
    }

    func toggleRecipe(_ recipeId: String, in collection: RecipeCollection) {
        var ids = collection.recipeIDs
        if let index = ids.firstIndex(of: recipeId) { ids.remove(at: index) }
        else { ids.append(recipeId) }
        collection.recipeIDs = ids
        persist()
    }

    func rating(for recipeId: String) -> FeedbackRating? { ratings[recipeId] }

    /// Tapping the active rating again clears it.
    func setRating(_ rating: FeedbackRating?, for recipeId: String) {
        let effective: FeedbackRating? = (ratings[recipeId] == rating) ? nil : rating
        let record: RecipeFeedback = feedbackRecord(for: recipeId)
        record.rating = effective
        record.date = Date()
        let kind: TasteEvent.Kind
        switch effective {
        case .like: kind = .liked
        case .notForMe: kind = .notForMe
        case nil: kind = .ratingCleared
        }
        RecipeBehaviorLog.record(kind, recipeId: recipeId, in: context, date: record.date)
        persist()
    }

    func setStars(_ value: Int, for recipeId: String) {
        let record: RecipeFeedback = feedbackRecord(for: recipeId)
        record.stars = min(5, max(0, value))
        record.date = Date()
        RecipeBehaviorLog.record(.stars, recipeId: recipeId, in: context, date: record.date, stars: record.stars)
        persist()
    }

    private func feedbackRecord(for recipeId: String) -> RecipeFeedback {
        if let existing = fetchFeedback(recipeId) { return existing }
        let created = RecipeFeedback(recipeId: recipeId, rating: nil)
        context.insert(created)
        return created
    }

    private func fetchFeedback(_ recipeId: String) -> RecipeFeedback? {
        var descriptor = FetchDescriptor<RecipeFeedback>(
            predicate: #Predicate<RecipeFeedback> { item in item.recipeId == recipeId },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first
    }

    private func fetchSaved(_ recipeId: String) -> [SavedRecipe] {
        let descriptor = FetchDescriptor<SavedRecipe>(predicate: #Predicate<SavedRecipe> { item in item.recipeId == recipeId })
        return (try? context.fetch(descriptor)) ?? []
    }

    private func persist() {
        try? context.save()
        reload()
    }
}
