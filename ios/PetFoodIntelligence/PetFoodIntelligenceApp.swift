import SwiftUI

@main
struct PetFoodIntelligenceApp: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(appModel)
                .tint(.teal)
        }
    }
}
