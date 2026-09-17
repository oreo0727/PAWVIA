import Foundation
import Observation

@Observable
final class AppModel {
    let api: PetFoodAPIClient
    let historyStore: ScanHistoryStore
    let favoritesStore: FavoritesStore
    let compareStore: CompareStore

    init(
        api: PetFoodAPIClient = .live,
        historyStore: ScanHistoryStore = ScanHistoryStore(),
        favoritesStore: FavoritesStore = FavoritesStore(),
        compareStore: CompareStore = CompareStore()
    ) {
        self.api = api
        self.historyStore = historyStore
        self.favoritesStore = favoritesStore
        self.compareStore = compareStore
    }
}
