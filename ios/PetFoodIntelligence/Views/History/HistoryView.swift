import SwiftUI

struct HistoryView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        List {
            if model.historyStore.items.isEmpty {
                ContentUnavailableView("Your scans will appear here.", systemImage: "clock.arrow.circlepath")
            }
            ForEach(model.historyStore.items) { item in
                NavigationLink(value: item.productID) {
                    VStack(alignment: .leading) {
                        Text(item.productName)
                            .font(.headline)
                        Text(item.brand ?? "Unknown brand")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("History")
        .navigationDestination(for: String.self) { ProductSnapshotView(productID: $0) }
    }
}
