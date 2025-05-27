import Foundation
import SwiftUI

struct Product: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let unit: ProductUnit
    let category: ProductCategory
    let images: [String]
    let seller: User
    let location: ProductLocation
    let availability: ProductAvailability
    let quality: ProductQuality
    let isOrganic: Bool
    let harvestDate: Date?
    let createdAt: Date
    let rating: Double
    let reviewCount: Int
    
    init(name: String, description: String, price: Double, unit: ProductUnit, category: ProductCategory, images: [String] = [], seller: User, location: ProductLocation, availability: ProductAvailability = .available, quality: ProductQuality = .good, isOrganic: Bool = false, harvestDate: Date? = nil, createdAt: Date = Date(), rating: Double = 0.0, reviewCount: Int = 0) {
        self.name = name
        self.description = description
        self.price = price
        self.unit = unit
        self.category = category
        self.images = images
        self.seller = seller
        self.location = location
        self.availability = availability
        self.quality = quality
        self.isOrganic = isOrganic
        self.harvestDate = harvestDate
        self.createdAt = createdAt
        self.rating = rating
        self.reviewCount = reviewCount
    }
}

enum ProductUnit: String, CaseIterable, Codable {
    case kg = "kg"
    case piece = "kom"
    case bunch = "vezak"
    case liter = "l"
    case gram = "g"
    case euro = "€"  // ← Ako trebate
    
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

enum ProductCategory: String, CaseIterable, Codable {
    case vegetables = "vegetables"
    case fruits = "fruits"
    case herbs = "herbs"
    case seeds = "seeds"
    case flowers = "flowers"
    case other = "other"
    
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
    
    var icon: String {
        switch self {
        case .vegetables: return "🥕"
        case .fruits: return "🍎"
        case .herbs: return "🌿"
        case .seeds: return "🌱"
        case .flowers: return "🌸"
        case .other: return "📦"
        }
    }
}

enum ProductAvailability: String, Codable {
    case available = "available"
    case reserved = "reserved"
    case sold = "sold"
    
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
    case excellent = "excellent"
    case good = "good"
    case fair = "fair"
    
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

struct ProductLocation: Codable {
    let address: String
    let city: String
    let postalCode: String
    let latitude: Double?
    let longitude: Double?
    let distanceFromUser: Double? // u kilometrima
    
    var displayLocation: String {
        return "\(address), \(city)"
    }
    
    var distanceText: String {
        guard let distance = distanceFromUser else { return "" }
        return String(format: "%.1f km", distance)
    }
}

// Extension za formatiranje
extension Product {
    var priceText: String {
            return String(format: "%.2f €/%@", price, unit.rawValue)  // ← Promjena iz "kn" u "€"
    }
    
    var localizedPriceText: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "hr_HR")  // Hrvatski locale za euro
            formatter.currencyCode = "EUR"
            
            if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
                return "\(formattedPrice)/\(unit.rawValue)"
            } else {
                return priceText  // fallback
            }
    }
    
    var primaryImage: String {
        return images.first ?? category.icon
    }
    
    var isNew: Bool {
        let daysSinceCreated = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        return daysSinceCreated <= 3
    }
    
    var ratingText: String {
        guard reviewCount > 0 else { return "Nema ocjena" }
        return String(format: "⭐ %.1f (%d)", rating, reviewCount)
    }
}
