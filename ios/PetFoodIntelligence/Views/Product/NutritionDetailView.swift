import SwiftUI

struct NutritionDetailView: View {
    let product: Product

    var body: some View {
        List {
            Section("Guaranteed Analysis") {
                row("Protein", product.nutrition?.protein)
                row("Fat", product.nutrition?.fat)
                row("Fiber", product.nutrition?.fiber)
                row("Moisture", product.nutrition?.moisture)
            }
            Section("Dry Matter Analysis") {
                Text("Calculated values. These are not laboratory measurements.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                row("Protein", product.nutrition?.dryMatterProtein)
                row("Fat", product.nutrition?.dryMatterFat)
                row("Fiber", product.nutrition?.dryMatterFiber)
            }
            Section("Calories") {
                Text(product.calories ?? "Not available")
            }
            Section("Nutritional Adequacy") {
                Text(product.nutritionalAdequacy ?? "Not available")
            }
        }
        .navigationTitle("Nutrition")
    }

    private func row(_ label: String, _ value: Double?) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value.map { "\($0.formatted())%" } ?? "Not available")
                .foregroundStyle(.secondary)
        }
    }
}
