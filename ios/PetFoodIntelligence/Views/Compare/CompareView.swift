import SwiftUI

struct CompareView: View {
    @Environment(AppModel.self) private var model
    @State private var products: [Product] = []
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if model.compareStore.items.count < 2 {
                    ContentUnavailableView("Add two foods to compare their nutrition and ingredients.", systemImage: "rectangle.split.3x1")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .padding(.vertical, 42)
                        .frame(maxWidth: .infinity)
                        .futuristicCard()
                }

                ForEach(model.compareStore.items) { item in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(AppTheme.primary)
                            .frame(width: 34, height: 34)
                            .background(AppTheme.techMint, in: Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.system(.headline, design: .rounded).weight(.heavy))
                                .foregroundStyle(AppTheme.ink)
                                .lineLimit(2)
                            Text(item.brand ?? "Unknown brand")
                                .font(.system(.caption, design: .rounded).weight(.semibold))
                                .foregroundStyle(AppTheme.muted)
                        }
                        Spacer()
                        Button("Remove") { model.compareStore.remove(id: item.id) }
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundStyle(AppTheme.alert)
                    }
                    .padding()
                    .futuristicCard(cornerRadius: 16)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Factual Comparison")
                        .font(.system(.title3, design: .rounded).weight(.black))
                        .foregroundStyle(AppTheme.ink)
                    comparisonRow("Protein", \.nutrition?.protein)
                    comparisonRow("Fat", \.nutrition?.fat)
                    comparisonRow("Fiber", \.nutrition?.fiber)
                    comparisonRow("Moisture", \.nutrition?.moisture)
                }
                .padding()
                .futuristicCard()
            }
            .padding()
            .padding(.bottom, 120)
        }
        .background(AppTheme.backgroundGradient)
        .navigationTitle("Compare")
        .toolbar { Button("Clear") { model.compareStore.clear() } }
        .task(id: model.compareStore.items) { await load() }
        .overlay { if isLoading { ProgressView() } }
    }

    private func comparisonRow(_ title: String, _ keyPath: KeyPath<Product, Double?>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .rounded).weight(.heavy))
                .foregroundStyle(AppTheme.ink)
            ForEach(products) { product in
                HStack {
                    Text(product.name ?? "Unnamed")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .lineLimit(2)
                    Spacer()
                    Text(product[keyPath: keyPath].map { "\($0.formatted())%" } ?? "Not available")
                        .font(.system(.subheadline, design: .monospaced).weight(.bold))
                        .foregroundStyle(product[keyPath: keyPath] == nil ? AppTheme.muted : AppTheme.primary)
                }
            }
        }
        .padding(12)
        .background(AppTheme.surface.opacity(0.78), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func load() async {
        guard model.compareStore.items.count >= 2 else { products = []; return }
        isLoading = true
        products = (try? await model.api.compare(model.compareStore.items.map(\.id))) ?? []
        isLoading = false
    }
}
