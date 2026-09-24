import SwiftUI

struct PetsView: View {
    @Environment(AppModel.self) private var model
    @State private var showingAddPet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        BrandMark(compact: true)
                        SignalPill(text: "PET PROFILES", icon: "pawprint.fill")
                        Spacer()
                    }

                    Text("Pets")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.ink)

                    Text("Build the bowl profile for each pet so scans can become more personal.")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(AppTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 18)

                Button {
                    showingAddPet = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                            .font(.headline.weight(.black))
                        Text("Add a pet")
                            .font(.system(.headline, design: .rounded).weight(.heavy))
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.primary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)

                if model.petStore.pets.isEmpty {
                    EmptyPetsCard()
                } else {
                    ForEach(model.petStore.pets) { pet in
                        PetProfileCard(pet: pet) {
                            model.petStore.remove(id: pet.id)
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 120)
        }
        .background(AppTheme.backgroundGradient)
        .navigationTitle("Pets")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddPet) {
            AddPetView { pet in
                model.petStore.add(pet)
            }
        }
    }
}

private struct PetProfileCard: View {
    let pet: PetProfile
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: pet.species == .dog ? "dog.fill" : "cat.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(AppTheme.primary)
                .frame(width: 54, height: 54)
                .background(AppTheme.techMint, in: Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(pet.name)
                    .font(.system(.title3, design: .rounded).weight(.black))
                    .foregroundStyle(AppTheme.ink)
                Text(detailText)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
            }

            Spacer()

            Button(role: .destructive, action: onRemove) {
                Image(systemName: "trash")
                    .font(.headline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(AppTheme.alert)
        }
        .padding()
        .futuristicCard(cornerRadius: 18)
    }

    private var detailText: String {
        var parts = [pet.species.rawValue]
        if let ageYears = pet.ageYears {
            parts.append("\(ageYears) yr")
        }
        if let weightPounds = pet.weightPounds {
            parts.append("\(weightPounds.formatted()) lb")
        }
        return parts.joined(separator: " / ")
    }
}

private struct EmptyPetsCard: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "pawprint.circle.fill")
                .font(.system(size: 52, weight: .semibold))
                .foregroundStyle(AppTheme.primary)
            Text("No pets yet")
                .font(.system(.title3, design: .rounded).weight(.black))
                .foregroundStyle(AppTheme.ink)
            Text("Add your dog or cat to start building a personalized bowl profile.")
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundStyle(AppTheme.muted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 42)
        .padding(.horizontal)
        .futuristicCard()
    }
}

private struct AddPetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var species: PetSpecies = .dog
    @State private var age = ""
    @State private var weight = ""
    let onSave: (PetProfile) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Name", text: $name)
                    Picker("Species", selection: $species) {
                        ForEach(PetSpecies.allCases) { species in
                            Text(species.rawValue).tag(species)
                        }
                    }
                }

                Section("Optional") {
                    TextField("Age in years", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Weight in pounds", text: $weight)
                        .keyboardType(.decimalPad)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.backgroundGradient)
            .navigationTitle("Add Pet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(
                            PetProfile(
                                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                species: species,
                                ageYears: Int(age),
                                weightPounds: Double(weight)
                            )
                        )
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
