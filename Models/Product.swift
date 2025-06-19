import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    let sellerId: String        // User ID (prodavač)
    let gardenId: String        // Garden ID (vrt iz kojeg dolazi proizvod)
    let plantId: String?        // Opcionalno: Plant ID ako je vezano na biljku
    let icon: String
    let name: String
    let description: String
    let price: Double
    let unit: ProductUnit
    let category: ProductCategory
    let images: [String]        // URL-ovi slika
    let location: ProductLocation
    let availability: ProductAvailability
    let quality: ProductQuality
    let isOrganic: Bool
    let harvestDate: Date?
    let createdAt: Date
    let rating: Double
    let reviewCount: Int
    let isActive: Bool
}

// MARK: - ProductLocation

struct ProductLocation: Codable {
    var address: String
    var city: String
    var postalCode: String
    var latitude: Double?
    var longitude: Double?
    var distanceFromUser: Double?
    
    var displayLocation: String {
        return "\(address), \(city)"
    }
    
    var distanceText: String {
        guard let distance = distanceFromUser else { return "" }
        return String(format: "%.1f km", distance)
    }
}

extension Product {
    var primaryImage: String {
        images.first ?? "🍎"
    }
}

extension Product {
    var priceText: String {
        String(format: "%.2f €/%@", price, unit.rawValue)
    }
}

