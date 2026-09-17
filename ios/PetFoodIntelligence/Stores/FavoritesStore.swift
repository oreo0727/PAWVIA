import Foundation
import Observation

@Observable
final class FavoritesStore {
    private let key = "favorites"
    var productIDs: Set<String> = []

    init() {
        productIDs = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }

    func contains(_ product: Product) -> Bool {
        productIDs.contains(product.id)
    }

    func toggle(_ product: Product) {
        if productIDs.contains(product.id) {
            productIDs.remove(product.id)
        } else {
            productIDs.insert(product.id)
        }
        UserDefaults.standard.set(Array(productIDs), forKey: key)
    }
}
