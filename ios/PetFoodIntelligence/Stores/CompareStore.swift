import Foundation
import Observation

struct CompareItem: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let brand: String?
}

@Observable
final class CompareStore {
    private let key = "compareSelection"
    var items: [CompareItem] = []

    init() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([CompareItem].self, from: data)
        else { return }
        items = decoded
    }

    func contains(_ product: Product) -> Bool {
        items.contains { $0.id == product.id }
    }

    func add(_ product: Product) {
        guard !contains(product), items.count < 5 else { return }
        items.append(CompareItem(id: product.id, name: product.name ?? "Unnamed food", brand: product.brandName))
        save()
    }

    func remove(id: String) {
        items.removeAll { $0.id == id }
        save()
    }

    func clear() {
        items.removeAll()
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
