import SwiftUI

struct ProductSnapshotView: View {
    @Environment(AppModel.self) private var model
    let productID: String
    @State private var product: Product?
    @State private var isLoading = true
    @State private var error: Error?
    @State private var reportMessage: String?

    var body: some View {
        AsyncStateView(isLoading: isLoading, error: error) {
            if let product {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        ProductHeroCard(product: product)
                        ProductActions(product: product)
                        DataConfidenceCard(product: product)
                        FoodSnapshotGrid(nutrition: product.nutrition)
                        DryMatterCard(nutrition: product.nutrition)
                        TopIngredientsView(product: product)
                        MissingDataCard(product: product)
                        ReportDataCard(product: product) { message in
                            reportMessage = message
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        }
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
        .alert("Feedback noted", isPresented: .constant(reportMessage != nil)) {
            Button("OK") { reportMessage = nil }
        } message: {
            Text(reportMessage ?? "")
        }
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

private struct ProductHeroCard: View {
    let product: Product

    var body: some View {
        VStack(spacing: 18) {
            ProductImageView(url: product.imageURL)
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            HStack(alignment: .center, spacing: 18) {
                ProductScoreBadge(score: product.displayScore, size: 92)
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.brandName ?? "Unknown brand")
                        .font(.headline)
                        .foregroundStyle(AppTheme.muted)
                    Text(product.name ?? "Unnamed food")
                        .font(.system(.title, design: .rounded).weight(.black))
                        .foregroundStyle(AppTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(product.productTypeText)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(AppTheme.muted)
                    HStack(spacing: 8) {
                        ConfidenceBadge(status: product.verificationStatus)
                        ProductStatusPill(text: product.dataCompletenessLabel, icon: "checklist")
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .padding()
        .futuristicCard(cornerRadius: 24)
    }
}

struct ProductActions: View {
    @Environment(AppModel.self) private var model
    let product: Product

    var body: some View {
        HStack(spacing: 10) {
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
        .font(.system(.headline, design: .rounded).weight(.bold))
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}

private struct DataConfidenceCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Data Confidence")
                    .font(.system(.title3, design: .rounded).weight(.black))
                    .foregroundStyle(AppTheme.ink)
                Spacer()
                ProductStatusPill(text: product.verificationStatus?.label ?? "Needs Review", icon: "shield.lefthalf.filled")
            }

            VStack(spacing: 10) {
                ConfidenceRow(title: "Barcode match", value: product.barcode == nil ? "Not provided" : "Available", isGood: product.barcode != nil)
                ConfidenceRow(title: "Nutrition", value: product.nutrition == nil ? "Missing" : "Available", isGood: product.nutrition != nil)
                ConfidenceRow(title: "Ingredients", value: product.hasIngredientData ? "Available" : "Missing", isGood: product.hasIngredientData)
                ConfidenceRow(title: "Verification", value: product.verificationStatus?.label ?? "Unverified", isGood: product.verificationStatus == .manufacturerVerified || product.verificationStatus == .packageVerified)
            }
        }
        .padding()
        .futuristicCard()
    }
}

private struct ConfidenceRow: View {
    let title: String
    let value: String
    let isGood: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isGood ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .foregroundStyle(isGood ? AppTheme.primary : AppTheme.orange)
            Text(title)
                .font(.system(.subheadline, design: .rounded).weight(.heavy))
                .foregroundStyle(AppTheme.ink)
            Spacer()
            Text(value)
                .font(.system(.caption, design: .rounded).weight(.bold))
                .foregroundStyle(isGood ? AppTheme.primary : AppTheme.muted)
        }
        .padding(10)
        .background(AppTheme.surface.opacity(0.78), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
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
            if nutrition?.dryMatterProtein == nil, nutrition?.dryMatterFat == nil, nutrition?.dryMatterFiber == nil {
                Text("Dry matter values need more complete guaranteed analysis data.")
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.surface.opacity(0.78), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            } else {
                SnapshotValue(title: "Protein", value: nutrition?.dryMatterProtein)
                SnapshotValue(title: "Fat", value: nutrition?.dryMatterFat)
                SnapshotValue(title: "Fiber", value: nutrition?.dryMatterFiber)
            }
        }
        .padding()
        .futuristicCard()
    }
}

private struct MissingDataCard: View {
    let product: Product

    var body: some View {
        let missing = product.missingDataLabels
        if !missing.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "sparkle.magnifyingglass")
                        .foregroundStyle(AppTheme.orange)
                    Text("Help Improve This Food")
                        .font(.system(.title3, design: .rounded).weight(.black))
                        .foregroundStyle(AppTheme.ink)
                }
                Text("PAWVIA can get smarter when missing label data is reported and verified.")
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
                FlowPills(values: missing)
            }
            .padding()
            .futuristicCard()
        }
    }
}

private struct ReportDataCard: View {
    let product: Product
    let onReport: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Report or Correct Data")
                .font(.system(.title3, design: .rounded).weight(.black))
                .foregroundStyle(AppTheme.ink)
            Text("These controls are ready for the correction workflow. For now, they mark the issue locally for tester feedback.")
                .font(.system(.footnote, design: .rounded).weight(.semibold))
                .foregroundStyle(AppTheme.muted)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ReportButton(title: "Wrong match", icon: "barcode.viewfinder") {
                    onReport("Thanks. This barcode match was marked for review.")
                }
                ReportButton(title: "Missing nutrition", icon: "chart.bar.doc.horizontal") {
                    onReport("Thanks. Nutrition data was marked as missing.")
                }
                ReportButton(title: "Wrong ingredients", icon: "leaf") {
                    onReport("Thanks. Ingredients were marked for review.")
                }
                ReportButton(title: "Submit label", icon: "camera") {
                    onReport("Label photo submission will connect to the backend correction queue next.")
                }
            }
        }
        .padding()
        .futuristicCard()
    }
}

private struct ReportButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .font(.system(.caption, design: .rounded).weight(.heavy))
                    .lineLimit(2)
                Spacer(minLength: 0)
            }
            .foregroundStyle(AppTheme.primary)
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            .background(AppTheme.techMint.opacity(0.72), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct ProductStatusPill: View {
    let text: String
    let icon: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(.caption2, design: .rounded).weight(.black))
            .foregroundStyle(AppTheme.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(AppTheme.techMint.opacity(0.74), in: Capsule())
    }
}

private struct FlowPills: View {
    let values: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 132), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(values, id: \.self) { value in
                Text(value)
                    .font(.system(.caption, design: .rounded).weight(.heavy))
                    .foregroundStyle(AppTheme.ink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(AppTheme.surface.opacity(0.86), in: Capsule())
            }
        }
    }
}

private extension Product {
    var productTypeText: String {
        let text = [species, foodForm].compactMap { $0 }.joined(separator: " / ")
        return text.isEmpty ? "Pet food" : text
    }

    var hasIngredientData: Bool {
        !(ingredients?.isEmpty ?? true) || !(ingredientText?.isEmpty ?? true)
    }

    var displayScore: Int? {
        completenessScore ?? inferredCompletenessScore
    }

    var inferredCompletenessScore: Int {
        var score = 20
        if nutrition != nil { score += 30 }
        if hasIngredientData { score += 25 }
        if barcode != nil { score += 10 }
        if verificationStatus == .manufacturerVerified || verificationStatus == .packageVerified { score += 15 }
        return min(score, 100)
    }

    var dataCompletenessLabel: String {
        switch displayScore ?? 0 {
        case 80...100: "High Coverage"
        case 55..<80: "Partial Data"
        default: "Needs Data"
        }
    }

    var missingDataLabels: [String] {
        var values: [String] = []
        if nutrition == nil {
            values.append("Guaranteed analysis")
        } else {
            if nutrition?.fiber == nil { values.append("Fiber") }
            if nutrition?.moisture == nil { values.append("Moisture") }
            if nutrition?.dryMatterProtein == nil || nutrition?.dryMatterFat == nil { values.append("Dry matter") }
        }
        if !hasIngredientData { values.append("Ingredient list") }
        if barcode == nil { values.append("Barcode package") }
        if verificationStatus != .manufacturerVerified && verificationStatus != .packageVerified { values.append("Manufacturer verification") }
        return values
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
