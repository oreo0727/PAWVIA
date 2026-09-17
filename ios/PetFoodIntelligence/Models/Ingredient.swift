struct Ingredient: Codable, Identifiable, Hashable {
    let id: String
    let name: String?
    let category: String?
    let description: String?
    let sourceText: String?
}
