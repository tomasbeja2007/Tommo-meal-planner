import SwiftUI
import SwiftData
import ForkcastCore

@main
struct ForkcastApp: App {
    @State private var services: AppServices = AppServices()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(services: services)
                .fontDesign(.rounded)
                .preferredColorScheme(.light)
                .tint(Theme.tomato)
                .onOpenURL { url in
                    services.router.handle(url: url)
                }
                .task {
                    await services.subscriptions.start()
                    await services.notifications.refreshStatus()
                }
        }
    }
}
