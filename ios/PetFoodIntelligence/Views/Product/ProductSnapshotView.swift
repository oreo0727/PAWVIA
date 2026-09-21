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
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 18) {
                            ProductImageView(url: product.imageURL)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            HStack(alignment: .center, spacing: 18) {
                                ProductScoreBadge(score: product.completenessScore, size: 92)
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(product.brandName ?? "Unknown brand")
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.muted)
                                    Text(product.name ?? "Unnamed food")
                                        .font(.title.bold())
                                        .foregroundStyle(AppTheme.ink)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text([product.species, product.foodForm].compactMap { $0 }.joined(separator: " / "))
                                        .foregroundStyle(AppTheme.muted)
                                    ConfidenceBadge(status: product.verificationStatus)
                                }
                                Spacer(minLength: 0)
                            }
                        }
                        .padding()
                        .futuristicCard(cornerRadius: 24)
                        ProductActions(product: product)
                        FoodSnapshotGrid(nutrition: product.nutrition)
                        DryMatterCard(nutrition: product.nutrition)
                        TopIngredientsView(product: product)
                        NavigationLink {
                            NutritionDetailView(product: product)
                        } label: {
                            HStack {
                                Text("Nutrition")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption.bold())
                            }
                            .font(.headline)
                            .foregroundStyle(AppTheme.primary)
                            .padding()
                            .futuristicCard(cornerRadius: 16)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                }
                .background(AppTheme.backgroundGradient)
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
        .font(.headline)
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}

struct FoodSnapshotGrid: View {
    let nutrition: Nutrition?
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PAWVIA Snapshot").font(.title2.bold()).foregroundStyle(AppTheme.ink)
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
            Text(title).font(.subheadline).foregroundStyle(AppTheme.muted)
            Text(value.map { "\($0.formatted())%" } ?? "Not available")
                .font(.title3.bold())
                .foregroundStyle(AppTheme.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .futuristicCard(cornerRadius: 16)
    }
}

struct DryMatterCard: View {
    let nutrition: Nutrition?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Compare on Dry Matter").font(.title3.bold())
                    .foregroundStyle(AppTheme.ink)
                Text("Calculated").font(.caption.bold()).padding(6).foregroundStyle(.white).background(AppTheme.primary, in: Capsule())
            }
            Text("Dry matter removes moisture from the calculation so foods with different moisture levels are easier to compare.")
                .font(.footnote)
                .foregroundStyle(AppTheme.muted)
            SnapshotValue(title: "Protein", value: nutrition?.dryMatterProtein)
            SnapshotValue(title: "Fat", value: nutrition?.dryMatterFat)
            SnapshotValue(title: "Fiber", value: nutrition?.dryMatterFiber)
        }
        .padding()
        .futuristicCard()
    }
}

struct TopIngredientsView: View {
    let product: Product
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients").font(.title2.bold()).foregroundStyle(AppTheme.ink)
            let ingredients = product.ingredients?.prefix(5).map { $0.name ?? $0.sourceText ?? "Unnamed ingredient" } ?? []
            if ingredients.isEmpty {
                Text(product.ingredientText ?? "Not available").foregroundStyle(AppTheme.muted)
            } else {
                ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(AppTheme.primary, in: Circle())
                        Text(ingredient)
                            .font(.body)
                            .foregroundStyle(AppTheme.ink)
                    }
                }
            }
            NavigationLink("See all ingredients") { IngredientsListView(product: product) }
                .foregroundStyle(AppTheme.primary)
        }
        .padding()
        .futuristicCard()
    }
}
