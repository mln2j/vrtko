import Foundation
import SwiftUI
import CoreGraphics

struct GardenPlant: Identifiable, Codable {
    var id: String? // Firestore document ID
    let gardenId: String // Referenca na Garden
    let plantType: PlantType
    let variety: String
    let status: PlantStatus
    let plantedDate: Date
    let expectedHarvestDate: Date?
    let actualHarvestDate: Date?
    let notes: String
    let photos: [PlantPhoto]
    let location: PlantLocation? // pozicija u vrtu
    
    var age: Int {
        Calendar.current.dateComponents([.day], from: plantedDate, to: Date()).day ?? 0
    }
    
    var isReadyForHarvest: Bool {
        guard let expectedDate = expectedHarvestDate else { return false }
        return Date() >= expectedDate && status == .growing
    }
}

struct PlantType: Identifiable, Codable {
    var id: String? // Firestore document ID ili UUID
    let name: String
    let category: ProductCategory
    let scientificName: String?
    let daysToMaturity: Int
    let plantingMonths: [Int]
    let harvestMonths: [Int]
    let difficulty: GrowingDifficulty
    let sunRequirement: SunRequirement
    let waterRequirement: WaterRequirement
    let spaceRequirement: Double
    let icon: String
    
    var plantingSeasonText: String {
        let monthNames = ["", "Sij", "Velj", "Ozuj", "Trav", "Svi", "Lip", "Srp", "Kol", "Ruj", "Lis", "Stud", "Pros"]
        let plantingNames = plantingMonths.compactMap { monthNames[$0] }
        return plantingNames.joined(separator: ", ")
    }
}

struct PlantPhoto: Identifiable, Codable {
    var id: String?
    let imageUrl: String
    let dateTaken: Date
    let notes: String?
    let plantAge: Int
    
    var ageText: String {
        if plantAge == 0 {
            return "Dan sadnje"
        } else if plantAge == 1 {
            return "1 dan"
        } else {
            return "\(plantAge) dana"
        }
    }
}

struct PlantLocation: Codable {
    let section: String
    let row: Int?
    let position: Int?
    let coordinates: CGPoint?
}

