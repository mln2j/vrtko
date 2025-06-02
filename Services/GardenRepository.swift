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
        let id = garden.id
        try Firestore.firestore().collection("gardens").document(id).setData(from: garden)
    }

    func deleteGarden(_ garden: Garden) async throws {
        // Prvo obriši sve biljke povezane s ovim vrtom
        try await deleteAllPlants(forGardenId: garden.id)
        // Zatim obriši vrt
        try await Firestore.firestore().collection("gardens").document(garden.id).delete()
    }

    func addGarden(_ garden: Garden) async throws {
        var newGarden = garden
        newGarden.documentId = nil // Firestore će generirati novi ID
        try Firestore.firestore().collection("gardens").addDocument(from: newGarden)
    }

    /// Kaskadno brisanje biljaka za vrt
    func deleteAllPlants(forGardenId gardenId: String) async throws {
        let query = Firestore.firestore().collection("plants").whereField("gardenId", isEqualTo: gardenId)
        let snapshot = try await query.getDocuments()
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }

    deinit {
        listener?.remove()
    }
}

