import Foundation

struct PetFoodAPIClient {
    var health: @Sendable () async throws -> HealthResponse
    var products: @Sendable (_ query: ProductQuery) async throws -> [Product]
    var product: @Sendable (_ id: String) async throws -> Product
    var productByBarcode: @Sendable (_ barcode: String) async throws -> Product
    var compare: @Sendable (_ ids: [String]) async throws -> [Product]
    var brands: @Sendable () async throws -> [Brand]
    var ingredients: @Sendable () async throws -> [Ingredient]

    static var live: PetFoodAPIClient {
        do {
            return PetFoodAPIClient(transport: URLSessionTransport(configuration: try .fromBundle()))
        } catch {
            return PetFoodAPIClient.failing(error)
        }
    }

    init(transport: URLSessionTransport) {
        self.health = { try await transport.get("/health") }
        self.products = { query in try await transport.getList("/api/v1/products", query: query.parameters) }
        self.product = { id in try await transport.get("/api/v1/products/\(id)") }
        self.productByBarcode = { barcode in try await transport.get("/api/v1/products/barcode/\(barcode.normalizedBarcode)") }
        self.compare = { ids in try await transport.get("/api/v1/products/compare", query: ["ids": ids.joined(separator: ",")]) }
        self.brands = { try await transport.getList("/api/v1/brands") }
        self.ingredients = { try await transport.getList("/api/v1/ingredients") }
    }

    static func failing(_ error: Error) -> PetFoodAPIClient {
        PetFoodAPIClient(
            health: { throw error },
            products: { _ in throw error },
            product: { _ in throw error },
            productByBarcode: { _ in throw error },
            compare: { _ in throw error },
            brands: { throw error },
            ingredients: { throw error }
        )
    }
}

private extension PetFoodAPIClient {
    init(
        health: @escaping @Sendable () async throws -> HealthResponse,
        products: @escaping @Sendable (ProductQuery) async throws -> [Product],
        product: @escaping @Sendable (String) async throws -> Product,
        productByBarcode: @escaping @Sendable (String) async throws -> Product,
        compare: @escaping @Sendable ([String]) async throws -> [Product],
        brands: @escaping @Sendable () async throws -> [Brand],
        ingredients: @escaping @Sendable () async throws -> [Ingredient]
    ) {
        self.health = health
        self.products = products
        self.product = product
        self.productByBarcode = productByBarcode
        self.compare = compare
        self.brands = brands
        self.ingredients = ingredients
    }
}
