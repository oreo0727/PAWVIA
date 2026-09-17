import SwiftUI

struct HomeView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Know what's in their bowl.")
                        .font(.largeTitle.bold())
                    Text("Scan pet food to explore ingredients, nutrition, and data confidence in seconds.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                NavigationLink {
                    ScannerHostView()
                } label: {
                    Label("Scan a Food", systemImage: "barcode.viewfinder")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                NavigationLink("Search foods instead", destination: SearchView())
                    .font(.headline)

                SectionHeader("Recent Scans")
                if model.historyStore.items.isEmpty {
                    ContentUnavailableView("Your scans will appear here.", systemImage: "clock.arrow.circlepath", description: Text("Start with a barcode scan while shopping or at home."))
                } else {
                    ForEach(model.historyStore.items.prefix(5)) { item in
                        NavigationLink(item.productName, value: item.productID)
                    }
                }
            }
            .padding()
        }
        .navigationDestination(for: String.self) { ProductSnapshotView(productID: $0) }
    }
}

struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
