import Foundation
import Observation

@Observable
final class AppModel {
    let api: PetFoodAPIClient
    let historyStore: ScanHistoryStore
    let favoritesStore: FavoritesStore
    let compareStore: CompareStore
    let petStore: PetStore

    init(
        api: PetFoodAPIClient = .live,
        historyStore: ScanHistoryStore = ScanHistoryStore(),
        favoritesStore: FavoritesStore = FavoritesStore(),
        compareStore: CompareStore = CompareStore(),
        petStore: PetStore = PetStore()
    ) {
        self.api = api
        self.historyStore = historyStore
        self.favoritesStore = favoritesStore
        self.compareStore = compareStore
        self.petStore = petStore
    }
}
