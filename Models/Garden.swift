import Foundation
import SwiftUI

struct Garden: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let owner: User
    let location: ProductLocation
    let size: Double // u m²
    let isPublic: Bool
    let plants: [GardenPlant]
    let createdAt: Date
    let photos: [String]
    
    var plantCount: Int {
        plants.count
    }
    
    var activeGrowingCount: Int {
        plants.filter { $0.status == .growing }.count
    }
}

struct GardenPlant: Identifiable, Codable {
    let id = UUID()
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

enum PlantStatus: String, CaseIterable, Codable {
    case planning = "planning"
    case planted = "planted"
    case growing = "growing"
    case flowering = "flowering"
    case fruiting = "fruiting"
    case ready = "ready"
    case harvested = "harvested"
    case finished = "finished"
    
    var displayName: String {
        switch self {
        case .planning: return "Planiranje"
        case .planted: return "Posađeno"
        case .growing: return "Raste"
        case .flowering: return "Cvjeta"
        case .fruiting: return "Plodonosi"
        case .ready: return "Spremo za berbu"
        case .harvested: return "Obrano"
        case .finished: return "Završeno"
        }
    }
    
    var icon: String {
        switch self {
        case .planning: return "📋"
        case .planted: return "🌱"
        case .growing: return "🌿"
        case .flowering: return "🌸"
        case .fruiting: return "🍅"
        case .ready: return "✅"
        case .harvested: return "🧺"
        case .finished: return "🏁"
        }
    }
    
    var color: Color {
        switch self {
        case .planning: return .gray
        case .planted, .growing: return .green
        case .flowering: return .pink
        case .fruiting: return .orange
        case .ready: return .blue
        case .harvested: return .purple
        case .finished: return .brown
        }
    }
}

struct PlantType: Identifiable, Codable {
    let id = UUID()
    let name: String
    let category: ProductCategory
    let scientificName: String?
    let daysToMaturity: Int
    let plantingMonths: [Int] // mjeseci kad se može saditi
    let harvestMonths: [Int] // mjeseci kad se može brati
    let difficulty: GrowingDifficulty
    let sunRequirement: SunRequirement
    let waterRequirement: WaterRequirement
    let spaceRequirement: Double // cm između biljaka
    let icon: String
    
    var plantingSeasonText: String {
        let monthNames = ["", "Sij", "Velj", "Ozuj", "Trav", "Svi", "Lip", "Srp", "Kol", "Ruj", "Lis", "Stud", "Pros"]
        let plantingNames = plantingMonths.compactMap { monthNames[$0] }
        return plantingNames.joined(separator: ", ")
    }
}

enum GrowingDifficulty: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var displayName: String {
        switch self {
        case .easy: return "Lako"
        case .medium: return "Srednje"
        case .hard: return "Teško"
        }
    }
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var stars: Int {
        switch self {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        }
    }
}

enum SunRequirement: String, CaseIterable, Codable {
    case fullSun = "fullSun"
    case partialSun = "partialSun"
    case shade = "shade"
    
    var displayName: String {
        switch self {
        case .fullSun: return "Puno sunce"
        case .partialSun: return "Djelomično sunce"
        case .shade: return "Sjena"
        }
    }
    
    var icon: String {
        switch self {
        case .fullSun: return "☀️"
        case .partialSun: return "⛅"
        case .shade: return "☁️"
        }
    }
}

enum WaterRequirement: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var displayName: String {
        switch self {
        case .low: return "Malo vode"
        case .medium: return "Umjereno"
        case .high: return "Puno vode"
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "💧"
        case .medium: return "💧💧"
        case .high: return "💧💧💧"
        }
    }
}

struct PlantLocation: Codable {
    let section: String // dio vrta
    let row: Int?
    let position: Int?
    let coordinates: CGPoint? // x, y pozicija na mapi vrta
}

struct PlantPhoto: Identifiable, Codable {
    let id = UUID()
    let imageUrl: String
    let dateTaken: Date
    let notes: String?
    let plantAge: Int // broj dana od sadnje
    
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
