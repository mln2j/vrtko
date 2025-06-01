import Foundation
import SwiftUI

enum UserRole: String, Codable, CaseIterable {
    case gardener
    case buyer
}

struct User: Identifiable, Codable {
    var id: String
    var profileCompleted: Bool
    let name: String
    let email: String
    let role: UserRole
    let avatar: String
    let location: String
    let phoneNumber: String?
    let joinDate: Date
    let rating: Double
    let totalSales: Int
    let isVerified: Bool
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
