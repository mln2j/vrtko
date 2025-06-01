//
//  Enums.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 31.05.2025..
//

import Foundation
import SwiftUI

// MARK: - Plant & Garden Enums

enum PlantStatus: String, CaseIterable, Codable {
    case planning
    case planted
    case growing
    case flowering
    case fruiting
    case ready
    case harvested
    case finished
    
    var displayName: String {
        switch self {
        case .planning: return "Planiranje"
        case .planted: return "Posađeno"
        case .growing: return "Raste"
        case .flowering: return "Cvjeta"
        case .fruiting: return "Plodonosi"
        case .ready: return "Spremno za berbu"
        case .harvested: return "Obrano"
        case .finished: return "Završeno"
        }
    }
    
    var icon: String {
        switch self {
        case .planning: return "📝"
        case .planted: return "🌱"
        case .growing: return "🌿"
        case .flowering: return "🌸"
        case .fruiting: return "🍎"
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

enum GrowingDifficulty: String, CaseIterable, Codable {
    case easy
    case medium
    case hard
    
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
    case fullSun
    case partialSun
    case shade
    
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
    case low
    case medium
    case high
    
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

// MARK: - Product Enums

enum ProductCategory: String, CaseIterable, Codable {
    case vegetables
    case fruits
    case herbs
    case seeds
    case flowers
    case other
    
    var displayName: String {
        switch self {
        case .vegetables: return "Povrće"
        case .fruits: return "Voće"
        case .herbs: return "Začini"
        case .seeds: return "Sjemenke"
        case .flowers: return "Cvijeće"
        case .other: return "Ostalo"
        }
    }
}

enum ProductUnit: String, CaseIterable, Codable {
    case kg
    case piece
    case bunch
    case liter
    case gram
    case euro
    
    var displayName: String {
        switch self {
        case .kg: return "kilogram"
        case .piece: return "komad"
        case .bunch: return "vezak"
        case .liter: return "litar"
        case .gram: return "gram"
        case .euro: return "euro"
        }
    }
}

enum ProductAvailability: String, Codable {
    case available
    case reserved
    case sold
    
    var displayName: String {
        switch self {
        case .available: return "Dostupno"
        case .reserved: return "Rezervirano"
        case .sold: return "Prodano"
        }
    }
    
    var color: Color {
        switch self {
        case .available: return .green
        case .reserved: return .orange
        case .sold: return .gray
        }
    }
}

enum ProductQuality: String, CaseIterable, Codable {
    case excellent
    case good
    case fair
    
    var displayName: String {
        switch self {
        case .excellent: return "Izvrsno"
        case .good: return "Dobro"
        case .fair: return "Zadovoljavajuće"
        }
    }
    
    var stars: Int {
        switch self {
        case .excellent: return 5
        case .good: return 4
        case .fair: return 3
        }
    }
}

// MARK: - Task/Planner Enums

enum TaskType: String, CaseIterable, Codable {
    case watering
    case planting
    case harvesting
    case fertilizing
    case pruning
    case weeding
    case pestControl
    case soilPrep
    case monitoring
    case other
    
    var displayName: String {
        switch self {
        case .watering: return "Zalijevanje"
        case .planting: return "Sadnja"
        case .harvesting: return "Berba"
        case .fertilizing: return "Gnojidba"
        case .pruning: return "Obrezivanje"
        case .weeding: return "Uklanjanje korova"
        case .pestControl: return "Zaštita od štetnika"
        case .soilPrep: return "Priprema tla"
        case .monitoring: return "Praćenje"
        case .other: return "Ostalo"
        }
    }
    
    var icon: String {
        switch self {
        case .watering: return "💧"
        case .planting: return "🌱"
        case .harvesting: return "🧺"
        case .fertilizing: return "🌾"
        case .pruning: return "✂️"
        case .weeding: return "🌾"
        case .pestControl: return "🐛"
        case .soilPrep: return "🪱"
        case .monitoring: return "🔍"
        case .other: return "🔧"
        }
    }
    
    var color: Color {
        switch self {
        case .watering: return .blue
        case .planting: return .green
        case .harvesting: return .orange
        case .fertilizing: return .brown
        case .pruning: return .purple
        case .weeding: return .yellow
        case .pestControl: return .red
        case .soilPrep: return .gray
        case .monitoring: return .cyan
        case .other: return .black
        }
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low
    case medium
    case high
    case urgent
    
    var displayName: String {
        switch self {
        case .low: return "Nizak"
        case .medium: return "Srednji"
        case .high: return "Visok"
        case .urgent: return "Hitno"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .urgent: return 4
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
}
