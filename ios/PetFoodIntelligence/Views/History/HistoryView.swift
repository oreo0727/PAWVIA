import SwiftUI

struct HistoryView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        List {
            if model.historyStore.items.isEmpty {
                ContentUnavailableView("Your scans will appear here.", systemImage: "clock.arrow.circlepath")
                    .foregroundStyle(AppTheme.ink)
                    .listRowBackground(AppTheme.cream)
            }
            ForEach(model.historyStore.items) { item in
                NavigationLink(value: item.productID) {
                    VStack(alignment: .leading) {
                        Text(item.productName)
                            .font(.headline)
                            .foregroundStyle(AppTheme.ink)
                        Text(item.brand ?? "Unknown brand")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                }
                .listRowBackground(AppTheme.surface)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.backgroundGradient)
        .navigationTitle("History")
        .navigationDestination(for: String.self) { ProductSnapshotView(productID: $0) }
    }
}
