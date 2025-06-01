//
//  GardenListView.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 31.05.2025..
//


import SwiftUIstruct GardenListView: View {    @StateObject private var gardenRepo = GardenRepository()    @EnvironmentObject var authService: AuthService    @State private var showingAddGarden = false    var body: some View {        NavigationView {            List(gardenRepo.gardens) { garden in                VStack(alignment: .leading) {                    Text(garden.name)                        .font(.headline)                    Text(garden.description)                        .font(.subheadline)                        .foregroundColor(.secondary)                }            }            .navigationTitle("Moji vrtovi")            .toolbar {                ToolbarItem(placement: .navigationBarTrailing) {                    Button(action: { showingAddGarden = true }) {                        Image(systemName: "plus")                    }                }            }            .sheet(isPresented: $showingAddGarden) {                AddGardenView(gardenRepo: gardenRepo)                    .environmentObject(authService)            }            .onAppear {                if let userId = authService.user?.id {                    gardenRepo.fetchGardens(for: userId)                }            }        }    }}