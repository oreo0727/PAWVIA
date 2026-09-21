struct Nutrition: Codable, Hashable {
    let protein: Double?
    let fat: Double?
    let fiber: Double?
    let moisture: Double?
    let dryMatterProtein: Double?
    let dryMatterFat: Double?
    let dryMatterFiber: Double?

    enum CodingKeys: String, CodingKey {
        case protein, crudeProtein, proteinPercent, proteinMin
        case fat, crudeFat, fatPercent, fatMin
        case fiber, crudeFiber, fiberPercent, fiberMax
        case moisture, moisturePercent, moistureMax
        case dryMatterProtein, proteinDryMatter
        case dryMatterFat, fatDryMatter
        case dryMatterFiber, fiberDryMatter
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        protein = try c.decodeFirstDouble(keys: [.protein, .crudeProtein, .proteinPercent, .proteinMin])
        fat = try c.decodeFirstDouble(keys: [.fat, .crudeFat, .fatPercent, .fatMin])
        fiber = try c.decodeFirstDouble(keys: [.fiber, .crudeFiber, .fiberPercent, .fiberMax])
        moisture = try c.decodeFirstDouble(keys: [.moisture, .moisturePercent, .moistureMax])
        dryMatterProtein = try c.decodeFirstDouble(keys: [.dryMatterProtein, .proteinDryMatter])
        dryMatterFat = try c.decodeFirstDouble(keys: [.dryMatterFat, .fatDryMatter])
        dryMatterFiber = try c.decodeFirstDouble(keys: [.dryMatterFiber, .fiberDryMatter])
    }

    init(guaranteed: Nutrition?, calculated: Nutrition?) {
        self.protein = guaranteed?.protein
        self.fat = guaranteed?.fat
        self.fiber = guaranteed?.fiber
        self.moisture = guaranteed?.moisture
        self.dryMatterProtein = calculated?.dryMatterProtein ?? guaranteed?.dryMatterProtein
        self.dryMatterFat = calculated?.dryMatterFat ?? guaranteed?.dryMatterFat
        self.dryMatterFiber = calculated?.dryMatterFiber ?? guaranteed?.dryMatterFiber
    }

    var hasValues: Bool {
        [
            protein,
            fat,
            fiber,
            moisture,
            dryMatterProtein,
            dryMatterFat,
            dryMatterFiber
        ].contains { $0 != nil }
    }

    func encode(to encoder: Encoder) throws {}
}
