//
//  PlantDetailView.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 01.06.2025..
//


import SwiftUIstruct PlantDetailView: View {    let plant: GardenPlant    var body: some View {        NavigationView {            Form {                Section(header: Text("Vrsta")) {                    HStack {                        Text(plant.plantType.icon)                        Text(plant.plantType.name)                    }                    if let sci = plant.plantType.scientificName {                        Text("Latinski: \(sci)").font(.caption)                    }                }                Section(header: Text("Detalji")) {                    if !plant.variety.isEmpty {                        Text("Sorta: \(plant.variety)")                    }                    Text("Status: \(plant.status.displayName)")                    Text("Zasađeno: \(plant.plantedDate, formatter: dateFormatter)")                }                if !plant.notes.isEmpty {                    Section(header: Text("Napomena")) {                        Text(plant.notes)                    }                }            }            .navigationTitle("Detalji biljke")            .toolbar {                ToolbarItem(placement: .cancellationAction) {                    Button("Zatvori") { }                }            }        }    }    private var dateFormatter: DateFormatter {        let formatter = DateFormatter()        formatter.dateStyle = .medium        return formatter    }}