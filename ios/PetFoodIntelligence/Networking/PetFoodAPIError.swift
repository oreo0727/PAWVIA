import Foundation

enum PetFoodAPIError: Error, LocalizedError, Equatable {
    case missingConfiguration
    case invalidResponse
    case network
    case unauthorized
    case rateLimited
    case notFound
    case server(Int)
    case decoding

    var errorDescription: String? {
        switch self {
        case .missingConfiguration: "API credentials are not configured."
        case .invalidResponse: "The service returned an unexpected response."
        case .network: "The service is unavailable."
        case .unauthorized: "API access was not authorized."
        case .rateLimited: "The service is receiving too many requests right now."
        case .notFound: "We could not find that record."
        case .server: "The service had a problem."
        case .decoding: "The response could not be read."
        }
    }
}
