import SwiftUI

struct SearchView: View {
    @Environment(AppModel.self) private var model
    @State private var query = ""
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var error: Error?

    var body: some View {
        List {
            if products.isEmpty, !isLoading {
                ContentUnavailableView("Search pet foods", systemImage: "magnifyingglass", description: Text("Search by product, brand, or ingredient."))
                    .listRowBackground(AppTheme.cream)
            }
            ForEach(products) { ProductCardView(product: $0).listRowSeparator(.hidden).listRowBackground(AppTheme.cream) }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(AppTheme.cream)
        .navigationTitle("Search")
        .searchable(text: $query, prompt: "Food, brand, ingredient")
        .navigationDestination(for: String.self) { ProductSnapshotView(productID: $0) }
        .overlay { if isLoading { ProgressView() } }
        .task(id: query) {
            guard query.count >= 2 else { products = []; return }
            try? await Task.sleep(for: .milliseconds(250))
            await search()
        }
        .alert("Search unavailable", isPresented: .constant(error != nil)) {
            Button("OK") { error = nil }
        } message: {
            Text(error?.localizedDescription ?? "")
        }
    }

    private func search() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await model.api.products(ProductQuery(q: query))
        } catch {
            self.error = error
        }
    }
}
