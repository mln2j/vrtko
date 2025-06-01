//
//  PlantListView.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 31.05.2025..
//


import SwiftUIstruct PlantListView: View {    @ObservedObject var plantRepo: PlantRepository    let gardenId: String    @State private var showingAddPlant = false    var body: some View {        List(plantRepo.plants) { plant in            VStack(alignment: .leading) {                Text(plant.plantType.name)                    .font(.headline)                Text(plant.variety)                    .font(.subheadline)            }        }        .navigationTitle("Biljke u vrtu")        .toolbar {            ToolbarItem(placement: .navigationBarTrailing) {                Button(action: { showingAddPlant = true }) {                    Image(systemName: "plus")                }            }        }        .sheet(isPresented: $showingAddPlant) {            AddPlantView(plantRepo: plantRepo, gardenId: gardenId)        }        .onAppear {            plantRepo.fetchPlants(for: gardenId)        }    }}