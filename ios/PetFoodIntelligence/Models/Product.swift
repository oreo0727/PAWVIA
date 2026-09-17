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

    enum CodingKeys: String, CodingKey {
        case id, productId, name, productName, title, brandName, brand, species, foodForm, form
        case imageURL, imageUrl, image, barcode, upc, ean, gtin
        case verificationStatus, sourceStatus, ingredientText, ingredientsText, ingredients
        case nutrition, guaranteedAnalysis, calories, kcal, nutritionalAdequacy, aafcoStatement
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeFlexibleString(keys: [.id, .productId])
        name = try c.decodeFirstString(keys: [.name, .productName, .title])
        if let brandObject = try? c.decode(Brand.self, forKey: .brand) {
            brandName = brandObject.name
        } else {
            brandName = try c.decodeFirstString(keys: [.brandName, .brand])
        }
        species = try c.decodeFirstString(keys: [.species])
        foodForm = try c.decodeFirstString(keys: [.foodForm, .form])
        imageURL = try c.decodeFirstURL(keys: [.imageURL, .imageUrl, .image])
        barcode = try c.decodeFirstString(keys: [.barcode, .upc, .ean, .gtin])
        verificationStatus = try c.decodeFirstEnum(keys: [.verificationStatus, .sourceStatus])
        ingredientText = try c.decodeFirstString(keys: [.ingredientText, .ingredientsText])
        ingredients = try? c.decode([Ingredient].self, forKey: .ingredients)
        nutrition = (try? c.decode(Nutrition.self, forKey: .nutrition)) ?? (try? c.decode(Nutrition.self, forKey: .guaranteedAnalysis)) ?? Nutrition(fromProduct: c)
        calories = try c.decodeFirstString(keys: [.calories, .kcal])
        nutritionalAdequacy = try c.decodeFirstString(keys: [.nutritionalAdequacy, .aafcoStatement])
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
    }

    func encode(to encoder: Encoder) throws {}
}
