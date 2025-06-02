//
//  Garden.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 31.05.2025..
//

import Foundation
import FirebaseFirestore

struct Garden: Identifiable, Codable {
    @DocumentID var documentId: String?
    var name: String
    var description: String
    let ownerId: String
    var location: ProductLocation
    var isPublic: Bool
    let createdAt: Date
    var photos: [String]
    var plantCount: Int = 0

    var id: String { documentId ?? UUID().uuidString }
}


