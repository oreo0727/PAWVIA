struct HealthResponse: Codable, Equatable {
    let status: String?
    let database: String?
    let applicationVersion: String?
}
