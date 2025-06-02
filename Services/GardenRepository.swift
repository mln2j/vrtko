import Foundation
import FirebaseFirestore

import Foundation
import FirebaseFirestore

class GardenRepository: ObservableObject {
    @Published var gardens: [Garden] = []
    private var listener: ListenerRegistration?
    
    func fetchGardens(for ownerId: String) {
        listener?.remove()
        listener = Firestore.firestore().collection("gardens")
            .whereField("ownerId", isEqualTo: ownerId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.gardens = documents.compactMap { try? $0.data(as: Garden.self) }
            }
    }
    
    func updateGarden(_ garden: Garden) async throws {
        let id = garden.id // sada je non-optional
        try Firestore.firestore().collection("gardens").document(id).setData(from: garden)
    }
    
    func deleteGarden(withId id: String) async throws {
        try await Firestore.firestore().collection("gardens").document(id).delete()
    }
    
    func addGarden(_ garden: Garden) async throws {
        var newGarden = garden
        newGarden.documentId = nil // Firestore će generirati novi ID
        try Firestore.firestore().collection("gardens").addDocument(from: newGarden)
    }
    
    deinit {
        listener?.remove()
    }
}

