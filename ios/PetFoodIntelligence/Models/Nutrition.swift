struct Nutrition: Codable, Hashable {
    let protein: Double?
    let fat: Double?
    let fiber: Double?
    let moisture: Double?
    let dryMatterProtein: Double?
    let dryMatterFat: Double?
    let dryMatterFiber: Double?

    enum CodingKeys: String, CodingKey {
        case protein, crudeProtein, proteinPercent
        case fat, crudeFat, fatPercent
        case fiber, crudeFiber, fiberPercent
        case moisture, moisturePercent
        case dryMatterProtein, proteinDryMatter
        case dryMatterFat, fatDryMatter
        case dryMatterFiber, fiberDryMatter
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        protein = try c.decodeFirstDouble(keys: [.protein, .crudeProtein, .proteinPercent])
        fat = try c.decodeFirstDouble(keys: [.fat, .crudeFat, .fatPercent])
        fiber = try c.decodeFirstDouble(keys: [.fiber, .crudeFiber, .fiberPercent])
        moisture = try c.decodeFirstDouble(keys: [.moisture, .moisturePercent])
        dryMatterProtein = try c.decodeFirstDouble(keys: [.dryMatterProtein, .proteinDryMatter])
        dryMatterFat = try c.decodeFirstDouble(keys: [.dryMatterFat, .fatDryMatter])
        dryMatterFiber = try c.decodeFirstDouble(keys: [.dryMatterFiber, .fiberDryMatter])
    }

    init(fromProduct c: KeyedDecodingContainer<Product.CodingKeys>) {
        self.protein = nil
        self.fat = nil
        self.fiber = nil
        self.moisture = nil
        self.dryMatterProtein = nil
        self.dryMatterFat = nil
        self.dryMatterFiber = nil
    }

    func encode(to encoder: Encoder) throws {}
}
