import SwiftUI
import SwiftData
import ForkcastCore

/// Builds and owns every long-lived service, and injects them into the view tree.
@MainActor
final class AppServices {
    let container: ModelContainer
    let catalog: FoodCatalog
    let profileStore: ProfileStore
    let repository: RecipeRepository
    let library: LibraryStore
    let planStore: PlanStore
    let subscriptions: SubscriptionManager
    let notifications: NotificationManager
    let router: AppRouter
    let appleSignIn: AppleSignInManager

    /// The live instance (for the few places that need app-wide actions, e.g. "Delete all my data").
    static weak var current: AppServices?

    init(inMemory: Bool = false) {
        let container: ModelContainer = PersistenceController.makeContainer(inMemory: inMemory)
        let context: ModelContext = container.mainContext
        let catalog: FoodCatalog = FoodCatalog.bundled
        let profileStore = ProfileStore(context: context, catalog: catalog)
        let repository = RecipeRepository(catalog: catalog, context: context)
        let library = LibraryStore(context: context)
        self.container = container
        self.catalog = catalog
        self.profileStore = profileStore
        self.repository = repository
        self.library = library
        self.planStore = PlanStore(context: context, catalog: catalog, repository: repository, library: library, profileStore: profileStore)
        self.subscriptions = SubscriptionManager()
        self.notifications = NotificationManager()
        self.router = AppRouter()
        self.appleSignIn = AppleSignInManager()
        if !inMemory {
            AppServices.current = self
        }
    }

    /// Reloads everything from the store (after CloudKit sync, reset, etc.).
    func reloadAll() {
        profileStore.reload()
        repository.refresh()
        library.reload()
        planStore.reload()
    }

    /// Danger zone: wipe SwiftData and the App Group.
    func deleteAllData() {
        PersistenceController.deleteAll(in: container.mainContext)
        if let directory = SharedConstants.appGroupContainerURL() {
            for name in [SharedConstants.widgetSnapshotFileName, "pending-import.json"] {  // also clears any file left by the old share extension
                try? FileManager.default.removeItem(at: directory.appendingPathComponent(name))
            }
        }
        WidgetSnapshotWriter.clear()
        notifications.removeAll()
        UserDefaults.standard.removeObject(forKey: FeatureFlags.debugProOverrideKey)
        reloadAll()
        router.popToRoot()
        router.selectedTab = .plan
    }
}

extension View {
    /// Injects every service into the environment.
    func environment(services: AppServices) -> some View {
        self
            .environment(services.profileStore)
            .environment(services.repository)
            .environment(services.library)
            .environment(services.planStore)
            .environment(services.subscriptions)
            .environment(services.notifications)
            .environment(services.router)
            .environment(services.appleSignIn)
            .modelContainer(services.container)
    }
}
