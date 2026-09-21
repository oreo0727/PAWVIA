import SwiftUI

struct IngredientExplorerView: View {
    @Environment(AppModel.self) private var model
    @State private var ingredients: [Ingredient] = []

    var body: some View {
        List(ingredients) { ingredient in
            VStack(alignment: .leading) {
                Text(ingredient.name ?? "Unnamed ingredient")
                    .foregroundStyle(AppTheme.ink)
                if let category = ingredient.category {
                    Text(category).font(.caption).foregroundStyle(AppTheme.muted)
                }
            }
            .listRowBackground(AppTheme.surface)
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.backgroundGradient)
        .navigationTitle("Ingredients")
        .task { ingredients = (try? await model.api.ingredients()) ?? [] }
    }
}
