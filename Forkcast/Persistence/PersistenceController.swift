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
        RecipeFeedback.self,
        RecipeBehavior.self,
        SavedRecipe.self,
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
    static func deleteAll(in context: ModelContext) {
        do {
            try context.delete(model: PlannedMeal.self)
            try context.delete(model: GroceryCheck.self)
            try context.delete(model: WeekPlan.self)
            try context.delete(model: ExtraGroceryItem.self)
            try context.delete(model: RecipeBehavior.self)
            try context.delete(model: RecipeFeedback.self)
            try context.delete(model: SavedRecipe.self)
            try context.delete(model: UserRecipeIngredient.self)
            try context.delete(model: UserRecipe.self)
            try context.delete(model: UserProfile.self)
            try context.save()
        } catch {
            logger.error("Delete all failed: \(String(describing: error), privacy: .public)")
        }
    }
}
