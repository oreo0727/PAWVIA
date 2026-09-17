import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house") }

            NavigationStack { SearchView() }
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            NavigationStack { ScannerHostView() }
                .tabItem { Label("Scan", systemImage: "barcode.viewfinder") }

            NavigationStack { HistoryView() }
                .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }

            NavigationStack { CompareView() }
                .tabItem { Label("Compare", systemImage: "rectangle.split.3x1") }
        }
    }
}
