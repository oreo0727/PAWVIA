import Foundation
import Observation

struct ScanHistoryItem: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    let productID: String
    let brand: String?
    let productName: String
    let imageURL: URL?
    let barcode: String?

    init(product: Product) {
        id = UUID()
        date = Date()
        productID = product.id
        brand = product.brandName
        productName = product.name ?? "Unnamed food"
        imageURL = product.imageURL
        barcode = product.barcode
    }
}

@Observable
final class ScanHistoryStore {
    private let key = "scanHistory"
    var items: [ScanHistoryItem] = []

    init() {
        load()
    }

    func add(product: Product) {
        items.removeAll { $0.productID == product.id }
        items.insert(ScanHistoryItem(product: product), at: 0)
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([ScanHistoryItem].self, from: data)
        else { return }
        items = decoded.sorted { $0.date > $1.date }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
