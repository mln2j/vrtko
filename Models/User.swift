import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    let id = UUID()
    let name: String
    let email: String
    let avatar: String
    let location: String
    let phoneNumber: String?
    let joinDate: Date
    let rating: Double
    let totalSales: Int
    let isVerified: Bool
    
    init(name: String, email: String, avatar: String = "person.circle.fill", location: String, phoneNumber: String? = nil, joinDate: Date = Date(), rating: Double = 0.0, totalSales: Int = 0, isVerified: Bool = false) {
        self.name = name
        self.email = email
        self.avatar = avatar
        self.location = location
        self.phoneNumber = phoneNumber
        self.joinDate = joinDate
        self.rating = rating
        self.totalSales = totalSales
        self.isVerified = isVerified
    }
}

// Extension za dodatne računalne properties
extension User {
    var firstName: String {
        name.components(separatedBy: " ").first ?? "User"
    }
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        return components.compactMap { $0.first }.map { String($0) }.joined()
    }
    
    var memberSince: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale(identifier: "hr_HR")
        return "Member since \(formatter.string(from: joinDate))"
    }
}
