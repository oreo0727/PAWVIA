import Foundation

struct Product: Codable, Identifiable, Hashable {
    let id: String
    let name: String?
    let brandName: String?
    let species: String?
    let foodForm: String?
    let imageURL: URL?
    let barcode: String?
    let verificationStatus: VerificationStatus?
    let ingredientText: String?
    let ingredients: [Ingredient]?
    let nutrition: Nutrition?
    let calories: String?
    let nutritionalAdequacy: String?
    let completenessScore: Int?

    enum CodingKeys: String, CodingKey {
        case id, productId, name, productName, title, brandName, brand, species, foodForm, form
        case imageURL, imageUrl, image, primaryImage, barcode, upc, ean, gtin
        case verificationStatus, sourceStatus, ingredientText, ingredientsText, ingredients
        case nutrition, guaranteedAnalysis, currentFormulation, calculatedNutrition
        case calories, kcal, nutritionalAdequacy, aafcoStatement, completenessScore
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let formulation = try? c.decode(CurrentFormulation.self, forKey: .currentFormulation)
        id = try c.decodeFlexibleString(keys: [.id, .productId])
        name = try c.decodeFirstString(keys: [.name, .productName, .title])
        if let brandObject = try? c.decode(Brand.self, forKey: .brand) {
            brandName = brandObject.name
        } else {
            brandName = try c.decodeFirstString(keys: [.brandName, .brand])
        }
        species = try c.decodeFirstString(keys: [.species])
        foodForm = try c.decodeFirstString(keys: [.foodForm, .form])
        imageURL = try c.decodeFirstURL(keys: [.imageURL, .imageUrl, .image, .primaryImage])
        barcode = try c.decodeFirstString(keys: [.barcode, .upc, .ean, .gtin])
        verificationStatus = try c.decodeFirstEnum(keys: [.verificationStatus, .sourceStatus])
        ingredientText = try c.decodeFirstString(keys: [.ingredientText, .ingredientsText]) ?? formulation?.ingredientStatementRaw
        ingredients = (try? c.decode([Ingredient].self, forKey: .ingredients)) ?? formulation?.ingredients
        let guaranteed = (try? c.decode(Nutrition.self, forKey: .nutrition)) ?? (try? c.decode(Nutrition.self, forKey: .guaranteedAnalysis)) ?? formulation?.guaranteedAnalysis
        let calculated = try? c.decode(Nutrition.self, forKey: .calculatedNutrition)
        let mergedNutrition = Nutrition(guaranteed: guaranteed, calculated: calculated)
        nutrition = mergedNutrition.hasValues ? mergedNutrition : nil
        calories = try c.decodeFirstString(keys: [.calories, .kcal]) ?? formulation?.calories
        nutritionalAdequacy = try c.decodeFirstString(keys: [.nutritionalAdequacy, .aafcoStatement]) ?? formulation?.nutritionalAdequacyStatement
        completenessScore = (try c.decodeFirstDouble(keys: [.completenessScore])).map(Int.init)
    }

    init(id: String, name: String, brandName: String? = nil) {
        self.id = id
        self.name = name
        self.brandName = brandName
        self.species = nil
        self.foodForm = nil
        self.imageURL = nil
        self.barcode = nil
        self.verificationStatus = nil
        self.ingredientText = nil
        self.ingredients = nil
        self.nutrition = nil
        self.calories = nil
        self.nutritionalAdequacy = nil
        self.completenessScore = nil
    }

    func encode(to encoder: Encoder) throws {}
}

private struct CurrentFormulation: Decodable {
    let ingredients: [Ingredient]?
    let guaranteedAnalysis: Nutrition?
    let calories: String?
    let nutritionalAdequacyStatement: String?
    let ingredientStatementRaw: String?
}
