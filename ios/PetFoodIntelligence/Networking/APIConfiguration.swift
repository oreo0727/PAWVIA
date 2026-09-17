import Foundation

struct APIConfiguration {
    let baseURL: URL
    let apiKey: String

    static func fromBundle() throws -> APIConfiguration {
        let info = Bundle.main.infoDictionary ?? [:]
        guard
            let base = info["PETFOOD_API_BASE_URL"] as? String,
            let baseURL = URL(string: base),
            let key = info["PETFOOD_API_KEY"] as? String,
            !key.isEmpty,
            key != "REPLACE_ME"
        else {
            throw PetFoodAPIError.missingConfiguration
        }
        return APIConfiguration(baseURL: baseURL, apiKey: key)
    }
}
