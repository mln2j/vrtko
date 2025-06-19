//
//  GardenPlant.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 01.06.2025..
//

import Foundation
import SwiftUI
import FirebaseFirestore
import CoreGraphics

// MARK: - Model za biljku u vrtu

struct GardenPlant: Identifiable, Codable {
    @DocumentID var id: String?
    let gardenId: String // Referenca na Garden
    let plantType: PlantType
    let variety: String
    var status: PlantStatus
    var plantedDate: Date
    let expectedHarvestDate: Date?
    let actualHarvestDate: Date?
    let notes: String
    let photos: [PlantPhoto]
    let location: PlantLocation? // pozicija u vrtu
    
    // Izračun starosti biljke u danima
    var age: Int {
        Calendar.current.dateComponents([.day], from: plantedDate, to: Date()).day ?? 0
    }
    
    // Provjera je li biljka spremna za berbu
    var isReadyForHarvest: Bool {
        guard let expectedDate = expectedHarvestDate else { return false }
        return Date() >= expectedDate && status == .growing
    }
}

// MARK: - Tip biljke (katalog)

struct PlantType: Identifiable, Codable, Equatable, Hashable {
    var id: String? // Firestore document ID ili UUID (za katalog može biti nil)
    let name: String
    let category: ProductCategory
    let scientificName: String?
    let daysToMaturity: Int
    let plantingMonths: [Int]    // npr. [3,4,5] za ožujak, travanj, svibanj
    let harvestMonths: [Int]     // npr. [7,8,9] za srpanj, kolovoz, rujan
    let difficulty: GrowingDifficulty
    let sunRequirement: SunRequirement
    let waterRequirement: WaterRequirement
    let spaceRequirement: Double // m2 po biljci
    let icon: String             // emoji ili SF Symbol

    // Prikaz mjeseci sadnje kao tekst
    var plantingSeasonText: String {
        let monthNames = ["", "Sij", "Velj", "Ožu", "Tra", "Svi", "Lip", "Srp", "Kol", "Ruj", "Lis", "Stu", "Pro"]
        let plantingNames = plantingMonths.compactMap { monthNames.indices.contains($0) ? monthNames[$0] : nil }
        return plantingNames.joined(separator: ", ")
    }
}

// MARK: - Fotografija biljke

struct PlantPhoto: Identifiable, Codable {
    var id: String?
    let imageUrl: String
    let dateTaken: Date
    let notes: String?
    let plantAge: Int

    var ageText: String {
        switch plantAge {
        case 0: return "Dan sadnje"
        case 1: return "1 dan"
        default: return "\(plantAge) dana"
        }
    }
}

// MARK: - Lokacija biljke u vrtu

struct PlantLocation: Codable {
    let section: String
    let row: Int?
    let position: Int?
    let coordinates: CGPoint?
}
