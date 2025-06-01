//
//  Garden.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 31.05.2025..
//

import Foundation
import SwiftUI

struct Garden: Identifiable, Codable {
    var id: String? // Firestore document ID
    let name: String
    let description: String
    let ownerId: String // Referenca na korisnika (User ID)
    let location: ProductLocation
    let isPublic: Bool
    let createdAt: Date
    let photos: [String]
    
    // Helper property (nije za Firestore)
    var plantCount: Int = 0
}
