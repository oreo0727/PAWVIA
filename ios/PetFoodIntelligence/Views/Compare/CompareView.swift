import SwiftUI

struct CompareView: View {
    @Environment(AppModel.self) private var model
    @State private var products: [Product] = []
    @State private var isLoading = false

    var body: some View {
        List {
            if model.compareStore.items.count < 2 {
                ContentUnavailableView("Add two foods to compare their nutrition and ingredients.", systemImage: "rectangle.split.3x1")
            }
            ForEach(model.compareStore.items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                        Text(item.brand ?? "Unknown brand").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Remove") { model.compareStore.remove(id: item.id) }
                }
            }
            Section("Factual comparison") {
                comparisonRow("Protein", \.nutrition?.protein)
                comparisonRow("Fat", \.nutrition?.fat)
                comparisonRow("Fiber", \.nutrition?.fiber)
                comparisonRow("Moisture", \.nutrition?.moisture)
            }
        }
        .navigationTitle("Compare")
        .toolbar { Button("Clear") { model.compareStore.clear() } }
        .task(id: model.compareStore.items) { await load() }
        .overlay { if isLoading { ProgressView() } }
    }

    private func comparisonRow(_ title: String, _ keyPath: KeyPath<Product, Double?>) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            ForEach(products) { product in
                HStack {
                    Text(product.name ?? "Unnamed")
                    Spacer()
                    Text(product[keyPath: keyPath].map { "\($0.formatted())%" } ?? "Not available")
                }
                .font(.subheadline)
            }
        }
    }

    private func load() async {
        guard model.compareStore.items.count >= 2 else { products = []; return }
        isLoading = true
        products = (try? await model.api.compare(model.compareStore.items.map(\.id))) ?? []
        isLoading = false
    }
}
