import Foundation

struct URLSessionTransport {
    let configuration: APIConfiguration
    var session: URLSession = .shared
    private let decoder = JSONDecoder.petFood

    func get<T: Decodable>(_ path: String, query: [String: String] = [:]) async throws -> T {
        let data = try await request(path, query: query)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw PetFoodAPIError.decoding
        }
    }

    func getList<T: Decodable>(_ path: String, query: [String: String] = [:]) async throws -> [T] {
        let data = try await request(path, query: query)
        if let direct = try? decoder.decode([T].self, from: data) {
            return direct
        }
        if let envelope = try? decoder.decode(ListEnvelope<T>.self, from: data) {
            return envelope.items ?? envelope.data ?? envelope.results ?? []
        }
        throw PetFoodAPIError.decoding
    }

    private func request(_ path: String, query: [String: String]) async throws -> Data {
        var components = URLComponents(url: configuration.baseURL.appending(path: path), resolvingAgainstBaseURL: false)
        components?.queryItems = query.isEmpty ? nil : query.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else { throw PetFoodAPIError.invalidResponse }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(configuration.apiKey, forHTTPHeaderField: "X-Api-Key")

        let response: (Data, URLResponse)
        do {
            response = try await session.data(for: request)
        } catch {
            throw PetFoodAPIError.network
        }
        guard let http = response.1 as? HTTPURLResponse else { throw PetFoodAPIError.invalidResponse }
        switch http.statusCode {
        case 200..<300: return response.0
        case 401, 403: throw PetFoodAPIError.unauthorized
        case 404: throw PetFoodAPIError.notFound
        case 429: throw PetFoodAPIError.rateLimited
        case 500...599: throw PetFoodAPIError.server(http.statusCode)
        default: throw PetFoodAPIError.invalidResponse
        }
    }
}

struct ListEnvelope<T: Decodable>: Decodable {
    let items: [T]?
    let data: [T]?
    let results: [T]?
}
