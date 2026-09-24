import Foundation
import Observation

enum PetSpecies: String, Codable, CaseIterable, Identifiable {
    case dog = "Dog"
    case cat = "Cat"

    var id: String { rawValue }
}

struct PetProfile: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var species: PetSpecies
    var ageYears: Int?
    var weightPounds: Double?

    init(id: UUID = UUID(), name: String, species: PetSpecies, ageYears: Int? = nil, weightPounds: Double? = nil) {
        self.id = id
        self.name = name
        self.species = species
        self.ageYears = ageYears
        self.weightPounds = weightPounds
    }
}

@Observable
final class PetStore {
    private let key = "petProfiles"
    var pets: [PetProfile] = []

    init() {
        load()
    }

    func add(_ pet: PetProfile) {
        pets.insert(pet, at: 0)
        save()
    }

    func remove(id: UUID) {
        pets.removeAll { $0.id == id }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([PetProfile].self, from: data)
        else { return }
        pets = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(pets) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
