import Foundation
import SwiftData
import OSLog
import ForkcastCore

enum PersistenceController {
    static let logger = Logger(subsystem: "com.tomasbeja.tommo", category: "Persistence")

    static let schema = Schema([
        UserProfile.self,
        WeekPlan.self,
        PlannedMeal.self,
        GroceryCheck.self,
        ExtraGroceryItem.self,
        GroceryCollection.self,
        RecipeFeedback.self,
        RecipeBehavior.self,
        SavedRecipe.self,
        RecipeCollection.self,
        UserRecipe.self,
        UserRecipeIngredient.self
    ])

    /// True when the CloudKit store failed and we fell back to a local store.
    private(set) static var isUsingLocalFallback: Bool = false

    /// CloudKit first; if that fails (no iCloud account, simulator, missing
    /// entitlement) fall back to a local-only store instead of crashing.
    static func makeContainer(inMemory: Bool = false) -> ModelContainer {
        if inMemory {
            return makeInMemory()
        }
        do {
            let cloud = ModelConfiguration(
                "Forkcast",
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                cloudKitDatabase: .private(SharedConstants.cloudKitContainerId)
            )
            let container = try ModelContainer(for: schema, configurations: [cloud])
            logger.info("Using CloudKit-backed SwiftData store.")
            return container
        } catch {
            logger.error("CloudKit store unavailable, falling back to local store: \(String(describing: error), privacy: .public)")
        }
        do {
            let local = ModelConfiguration(
                "Forkcast",
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                cloudKitDatabase: .none
            )
            isUsingLocalFallback = true
            return try ModelContainer(for: schema, configurations: [local])
        } catch {
            logger.fault("Local store failed too, using in-memory store: \(String(describing: error), privacy: .public)")
            isUsingLocalFallback = true
            return makeInMemory()
        }
    }

    private static func makeInMemory() -> ModelContainer {
        let memory = ModelConfiguration("ForkcastMemory", schema: schema, isStoredInMemoryOnly: true, allowsSave: true, cloudKitDatabase: .none)
        do {
            return try ModelContainer(for: schema, configurations: [memory])
        } catch {
            fatalError("Could not create even an in-memory SwiftData container: \(error)")
        }
    }

    /// Deletes every Forkcast record (used by "Delete all my data").
    @MainActor
    static func deleteAll(in context: ModelContext) throws {
        try context.save()
        do {
            try delete(PlannedMeal.self, in: context)
            try delete(GroceryCheck.self, in: context)
            try delete(WeekPlan.self, in: context)
            try delete(ExtraGroceryItem.self, in: context)
            try delete(GroceryCollection.self, in: context)
            try delete(RecipeBehavior.self, in: context)
            try delete(RecipeFeedback.self, in: context)
            try delete(SavedRecipe.self, in: context)
            try delete(RecipeCollection.self, in: context)
            try delete(UserRecipeIngredient.self, in: context)
            try delete(UserRecipe.self, in: context)
            try delete(UserProfile.self, in: context)
            try context.save()
        } catch {
            context.rollback()
            logger.error("Delete all failed: \(String(describing: error), privacy: .private)")
            throw error
        }
    }

    @MainActor
    private static func delete<Model: PersistentModel>(_ type: Model.Type, in context: ModelContext) throws {
        for record in try context.fetch(FetchDescriptor<Model>()) {
            context.delete(record)
        }
    }
}
