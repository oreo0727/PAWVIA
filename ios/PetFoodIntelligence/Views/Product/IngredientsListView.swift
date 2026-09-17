import SwiftUI

struct IngredientsListView: View {
    let product: Product

    var body: some View {
        List {
            if let ingredients = product.ingredients, !ingredients.isEmpty {
                ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                    VStack(alignment: .leading) {
                        Text("\(index + 1). \(ingredient.name ?? ingredient.sourceText ?? "Unnamed ingredient")")
                        if let category = ingredient.category {
                            Text(category).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            } else {
                Text(product.ingredientText ?? "Not available")
            }
        }
        .navigationTitle("Ingredients")
    }
}
