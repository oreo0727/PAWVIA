import SwiftUI

struct ProductSnapshotView: View {
    @Environment(AppModel.self) private var model
    let productID: String
    @State private var product: Product?
    @State private var isLoading = true
    @State private var error: Error?

    var body: some View {
        AsyncStateView(isLoading: isLoading, error: error) {
            if let product {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        ProductImageView(url: product.imageURL)
                            .frame(height: 240)
                        VStack(alignment: .leading, spacing: 8) {
                            Text(product.brandName ?? "Unknown brand")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text(product.name ?? "Unnamed food")
                                .font(.largeTitle.bold())
                            Text([product.species, product.foodForm].compactMap { $0 }.joined(separator: " / "))
                                .foregroundStyle(.secondary)
                            ConfidenceBadge(status: product.verificationStatus)
                        }
                        ProductActions(product: product)
                        FoodSnapshotGrid(nutrition: product.nutrition)
                        DryMatterCard(nutrition: product.nutrition)
                        TopIngredientsView(product: product)
                        NavigationLink("Nutrition details") { NutritionDetailView(product: product) }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Food Snapshot")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        do {
            product = try await model.api.product(productID)
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

struct ProductActions: View {
    @Environment(AppModel.self) private var model
    let product: Product

    var body: some View {
        HStack {
            Button {
                model.favoritesStore.toggle(product)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Label(model.favoritesStore.contains(product) ? "Favorited" : "Favorite", systemImage: model.favoritesStore.contains(product) ? "heart.fill" : "heart")
            }
            Button {
                model.compareStore.add(product)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Label("Compare", systemImage: "rectangle.split.3x1")
            }
        }
        .buttonStyle(.bordered)
    }
}

struct FoodSnapshotGrid: View {
    let nutrition: Nutrition?
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Food Snapshot").font(.title2.bold())
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SnapshotValue(title: "Protein", value: nutrition?.protein)
                SnapshotValue(title: "Fat", value: nutrition?.fat)
                SnapshotValue(title: "Fiber", value: nutrition?.fiber)
                SnapshotValue(title: "Moisture", value: nutrition?.moisture)
            }
        }
    }
}

struct SnapshotValue: View {
    let title: String
    let value: Double?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline).foregroundStyle(.secondary)
            Text(value.map { "\($0.formatted())%" } ?? "Not available")
                .font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct DryMatterCard: View {
    let nutrition: Nutrition?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Compare on Dry Matter").font(.title3.bold())
                Text("Calculated").font(.caption.bold()).padding(6).background(.teal.opacity(0.15), in: Capsule())
            }
            Text("Dry matter removes moisture from the calculation so foods with different moisture levels are easier to compare.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            SnapshotValue(title: "Protein", value: nutrition?.dryMatterProtein)
            SnapshotValue(title: "Fat", value: nutrition?.dryMatterFat)
            SnapshotValue(title: "Fiber", value: nutrition?.dryMatterFiber)
        }
    }
}

struct TopIngredientsView: View {
    let product: Product
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Ingredients").font(.title2.bold())
            let ingredients = product.ingredients?.prefix(5).map { $0.name ?? $0.sourceText ?? "Unnamed ingredient" } ?? []
            if ingredients.isEmpty {
                Text(product.ingredientText ?? "Not available").foregroundStyle(.secondary)
            } else {
                ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                    Text("\(index + 1). \(ingredient)")
                }
            }
            NavigationLink("See all ingredients") { IngredientsListView(product: product) }
        }
    }
}
