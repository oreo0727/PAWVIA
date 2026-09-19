import SwiftUI

struct SearchView: View {
    @Environment(AppModel.self) private var model
    @State private var query = ""
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var error: Error?

    init(initialQuery: String = "") {
        _query = State(initialValue: initialQuery)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                if query.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
                    SearchStarterView()
                        .padding(.top, 18)
                } else if isLoading, products.isEmpty {
                    SearchLoadingView()
                        .padding(.top, 120)
                } else if products.isEmpty {
                    ContentUnavailableView(
                        "No matches",
                        systemImage: "magnifyingglass",
                        description: Text("Try a brand, product name, ingredient, or a shorter phrase.")
                    )
                    .foregroundStyle(AppTheme.ink)
                    .padding(.top, 96)
                } else {
                    ForEach(products) { product in
                        ProductCardView(product: product)
                    }
                    .padding(.top, 6)

                    if isLoading {
                        ProgressView()
                            .padding(.vertical, 14)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(AppTheme.cream)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $query, prompt: "Food, brand, ingredient")
        .navigationDestination(for: String.self) { ProductSnapshotView(productID: $0) }
        .task(id: query) {
            let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard term.count >= 2 else {
                products = []
                isLoading = false
                return
            }
            try? await Task.sleep(for: .milliseconds(250))
            guard !Task.isCancelled else { return }
            await search(term)
        }
        .alert("Search unavailable", isPresented: .constant(error != nil)) {
            Button("OK") { error = nil }
        } message: {
            Text(error?.localizedDescription ?? "")
        }
    }

    @MainActor
    private func search(_ term: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let results = try await model.api.products(ProductQuery(q: term))
            guard term == query.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            products = results
        } catch {
            guard term == query.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            self.error = error
        }
    }
}

private struct SearchStarterView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(AppTheme.orange)

                Text("Find a better food")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(AppTheme.ink)

                Text("Search by product, brand, ingredient, or life stage.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 10) {
                SearchHintRow(icon: "tag", title: "Brand names", detail: "Purina, Royal Canin, Hill's")
                SearchHintRow(icon: "leaf", title: "Ingredients", detail: "Chicken, salmon, rice")
                SearchHintRow(icon: "pawprint", title: "Food types", detail: "Puppy, wet food, grain free")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.softLine)
        }
    }
}

private struct SearchHintRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(AppTheme.orange)
                .frame(width: 30, height: 30)
                .background(AppTheme.orange.opacity(0.10), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)
        }
    }
}

private struct SearchLoadingView: View {
    var body: some View {
        VStack(spacing: 14) {
            ProgressView()
                .controlSize(.large)
            Text("Searching foods")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
