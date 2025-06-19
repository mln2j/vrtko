import SwiftUI
import FirebaseFirestore

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authService: AuthService

    @State private var name: String
    @State private var location: String
    @State private var phoneNumber: String
    @State private var role: UserRole
    @State private var errorMessage: String = ""
    @State private var isSaving = false

    // Inicijalizator koji puni polja iz trenutnog korisnika
    init(authService: AuthService) {
        _authService = ObservedObject(wrappedValue: authService)
        let user = authService.user!
        _name = State(initialValue: user.name)
        _location = State(initialValue: user.location)
        _phoneNumber = State(initialValue: user.phoneNumber ?? "")
        _role = State(initialValue: user.role)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Form {
                    Section(header: Text("Osnovne informacije")) {
                        TextField("Ime i prezime", text: $name)
                        TextField("Grad", text: $location)
                        TextField("Broj telefona", text: $phoneNumber)
                            .keyboardType(.phonePad)
                    }
                    Section(header: Text("Uloga")) {
                        Picker("Uloga", selection: $role) {
                            Text("Sadnja i praćenje vrta").tag(UserRole.gardener)
                            Text("Razgledavanje/kupovinu").tag(UserRole.buyer)
                        }
                        .pickerStyle(.segmented)
                    }
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .navigationTitle("Uredi profil")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Odustani") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        if isSaving {
                            ProgressView()
                        } else {
                            Button("Spremi") {
                                saveProfile()
                            }
                        }
                    }
                }
            }
        }
    }

    private func saveProfile() {
        guard let userId = authService.user?.id else { return }
        isSaving = true
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData([
            "name": name,
            "location": location,
            "phoneNumber": phoneNumber,
            "role": role.rawValue
        ]) { error in
            isSaving = false
            if let error = error {
                errorMessage = "Greška: \(error.localizedDescription)"
            } else {
                // Ako imaš refreshUser(), pozovi ga ovdje
                // authService.refreshUser()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
