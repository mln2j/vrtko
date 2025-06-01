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
    
    func addGarden(_ garden: Garden) async throws {
        var newGarden = garden
        newGarden.id = nil // Firestore će generirati ID
        try Firestore.firestore().collection("gardens").addDocument(from: newGarden)
    }
    
    deinit {
        listener?.remove()
    }
}

