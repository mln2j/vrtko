//
//  AddProductView.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 19.06.2025..
//

import SwiftUI

struct AddProductView: View {
    @ObservedObject var plantRepo: PlantRepository
    @ObservedObject var productRepo: ProductRepository
    @ObservedObject var gardenRepo: GardenRepository
    
    let userId: String
    var onComplete: () -> Void

    @State private var selectedPlantId: String = ""
    @State private var quantity: Int = 1
    @State private var priceString: String = ""
    @State private var description: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Picker("Biljka", selection: $selectedPlantId) {
                    ForEach(plantRepo.plants) { plant in
                        Text(plant.plantType.name)
                            .tag(plant.id ?? "")
                    }
                }
                Stepper("Količina: \(quantity)", value: $quantity, in: 1...100)
                TextField("Cijena", text: $priceString)
                    .keyboardType(.decimalPad)
                TextField("Opis", text: $description)
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                }
            }
            .navigationTitle("Novi oglas")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Objavi") {
                        addProduct()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Odustani") { onComplete() }
                }
            }
        }
        .onAppear {
            if selectedPlantId.isEmpty, let first = plantRepo.plants.first?.id {
                selectedPlantId = first
            }
            gardenRepo.fetchGardens(for: userId)
        }
    }
    private func addProduct() {
        
        guard let plant = plantRepo.plants.first(where: { $0.id == selectedPlantId }) else {
            errorMessage = "Odaberi biljku"
            return
        }
        
        
        guard let price = Double(priceString), price > 0 else {
            errorMessage = "Unesi cijenu"
            return
        }
        
        
        // Dohvati vrt iz memorije
        guard let garden = gardenRepo.gardens.first(where: { $0.id == plant.gardenId }) else {
            errorMessage = "Vrt nije pronađen"
            return
        }
        
        let gardenLocation = garden.location


        let newProduct = Product(
            id: nil,
            sellerId: userId,
            gardenId: plant.gardenId,
            plantId: selectedPlantId,
            icon: plant.plantType.icon,
            name: plant.plantType.name,
            description: description,
            price: price,
            unit: .kg,
            category: plant.plantType.category,
            images: [],
            location: ProductLocation(
                address: gardenLocation.address,
                city: gardenLocation.city,
                postalCode: gardenLocation.postalCode,
                latitude: gardenLocation.latitude,
                longitude: gardenLocation.longitude,
                distanceFromUser: nil
            ),
            availability: .available,
            quality: .good,
            isOrganic: false,
            harvestDate: plant.actualHarvestDate,
            createdAt: Date(),
            rating: 0,
            reviewCount: 0,
            isActive: true,
            quantity: quantity
        )

        Task {
            do {
                try await productRepo.addProduct(newProduct)
                onComplete()
            } catch {
                errorMessage = "Greška pri spremanju oglasa."
            }
        }
    }
}
