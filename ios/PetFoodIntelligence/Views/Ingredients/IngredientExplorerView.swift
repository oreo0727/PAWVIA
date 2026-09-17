import SwiftUI

struct IngredientExplorerView: View {
    @Environment(AppModel.self) private var model
    @State private var ingredients: [Ingredient] = []

    var body: some View {
        List(ingredients) { ingredient in
            VStack(alignment: .leading) {
                Text(ingredient.name ?? "Unnamed ingredient")
                if let category = ingredient.category {
                    Text(category).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Ingredients")
        .task { ingredients = (try? await model.api.ingredients()) ?? [] }
    }
}
