import Foundation
import FirebaseAuth
import Combine
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

@MainActor
class AuthService: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isAuthenticated = false
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        checkAuthStatus()
        addAuthStateListener()
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func addAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user = user {
                    await self?.fetchUserFromFirestore(user)
                } else {
                    self?.user = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    private func checkAuthStatus() {
        if let currentUser = Auth.auth().currentUser {
            Task { @MainActor in
                await fetchUserFromFirestore(currentUser)
            }
        }
    }
    
    // Dohvati usera iz Firestore-a prema UID-u
    private func fetchUserFromFirestore(_ firebaseUser: FirebaseAuth.User) async {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(firebaseUser.uid)
                .getDocument()
            if let data = snapshot.data() {
                let user = User(
                    id: data["id"] as? String ?? firebaseUser.uid,
                    profileCompleted: data["profileCompleted"] as? Bool ?? false,
                    name: data["name"] as? String ?? (firebaseUser.displayName ?? "User"),
                    email: data["email"] as? String ?? (firebaseUser.email ?? ""),
                    role: UserRole(rawValue: data["role"] as? String ?? "buyer") ?? .buyer,
                    avatar: data["avatar"] as? String ?? "person.circle.fill",
                    location: data["location"] as? String ?? "Zagreb",
                    phoneNumber: data["phoneNumber"] as? String,
                    joinDate: (data["joinDate"] as? Timestamp)?.dateValue() ?? (firebaseUser.metadata.creationDate ?? Date()),
                    rating: data["rating"] as? Double ?? 0.0,
                    totalSales: data["totalSales"] as? Int ?? 0,
                    isVerified: data["isVerified"] as? Bool ?? firebaseUser.isEmailVerified,
                )
                self.user = user
                self.isAuthenticated = true
            }
        } catch {
            print("Error fetching user from Firestore: \(error)")
        }
    }
    
    // Registracija i spremanje usera u Firestore
    func signUp(email: String, password: String) async throws {
        isLoading = true
        errorMessage = ""
        
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // Samo email i password, ostalo korisnik unosi kasnije
            let user = User(
                id: result.user.uid,
                profileCompleted: false, // NOVO
                name: "", // Prazno, korisnik unosi kasnije
                email: email,
                role: .buyer, // Default, korisnik bira kasnije
                avatar: "person.circle.fill",
                location: "",
                phoneNumber: nil,
                joinDate: Date(),
                rating: 0.0,
                totalSales: 0,
                isVerified: false,
            )
            let db = Firestore.firestore()
            try await db.collection("users").document(user.id).setData([
                "id": user.id,
                "name": user.name,
                "email": user.email,
                "role": user.role.rawValue,
                "avatar": user.avatar,
                "location": user.location,
                "phoneNumber": user.phoneNumber as Any,
                "joinDate": Timestamp(date: user.joinDate),
                "rating": user.rating,
                "totalSales": user.totalSales,
                "isVerified": user.isVerified,
                "profileCompleted": user.profileCompleted // NOVO
            ])
            self.user = user
            self.isAuthenticated = true
        } catch {
            errorMessage = handleAuthError(error)
            throw error
        }
    }
    
    // Ažuriranje profila nakon ProfileSetupView
    func updateProfile(name: String, role: UserRole, location: String) async throws {
        guard let user = self.user else { return }
        let db = Firestore.firestore()
        try await db.collection("users").document(user.id).updateData([
            "name": name,
            "role": role.rawValue,
            "location": location,
            "profileCompleted": true
        ])
        // Lokalno ažuriraj user objekt
        self.user = User(
            id: user.id,
            profileCompleted: true, name: name,
            email: user.email,
            role: role,
            avatar: user.avatar,
            location: location,
            phoneNumber: user.phoneNumber,
            joinDate: user.joinDate,
            rating: user.rating,
            totalSales: user.totalSales,
            isVerified: user.isVerified
        )
    }
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = ""
        
        defer { isLoading = false }
        
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            // AuthStateListener će automatski dohvatiti usera iz Firestore-a
        } catch {
            errorMessage = handleAuthError(error)
            throw error
        }
    }
    
    func signInWithGoogle() async throws {
        isLoading = true
        errorMessage = ""
        
        defer { isLoading = false }
        
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AuthError.configurationError
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                throw AuthError.noViewController
            }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw AuthError.tokenError
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            let authResult = try await Auth.auth().signIn(with: credential)
            
            // Provjeri postoji li korisnik u Firestore-u
            let db = Firestore.firestore()
            let userDoc = try await db.collection("users").document(authResult.user.uid).getDocument()
            if !userDoc.exists {
                // Prvi put, stvori korisnika s profileCompleted: false
                let user = User(
                    id: authResult.user.uid,
                    profileCompleted: false, name: "",
                    email: authResult.user.email ?? "",
                    role: .buyer,
                    avatar: "person.circle.fill",
                    location: "",
                    phoneNumber: nil,
                    joinDate: Date(),
                    rating: 0.0,
                    totalSales: 0,
                    isVerified: authResult.user.isEmailVerified // NOVO
                )
                try await db.collection("users").document(user.id).setData([
                    "id": user.id,
                    "name": user.name,
                    "email": user.email,
                    "role": user.role.rawValue,
                    "avatar": user.avatar,
                    "location": user.location,
                    "phoneNumber": user.phoneNumber as Any,
                    "joinDate": Timestamp(date: user.joinDate),
                    "rating": user.rating,
                    "totalSales": user.totalSales,
                    "isVerified": user.isVerified,
                    "profileCompleted": user.profileCompleted // NOVO
                ])
                self.user = user
                self.isAuthenticated = true
            }
            // Ako već postoji, AuthStateListener će dohvatiti podatke
            
        } catch {
            errorMessage = handleAuthError(error)
            throw error
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        user = nil
        isAuthenticated = false
    }
    
    func resetPassword(email: String) async throws {
        isLoading = true
        errorMessage = ""
        
        defer { isLoading = false }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            errorMessage = handleAuthError(error)
            throw error
        }
    }
    
    private func handleAuthError(_ error: Error) -> String {
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "emailAlreadyInUse"
            case AuthErrorCode.invalidEmail.rawValue:
                return "invalidEmailAddress"
            case AuthErrorCode.weakPassword.rawValue:
                return "passwordTooShort"
            case AuthErrorCode.userNotFound.rawValue:
                return "userWithThisEmailNotFound"
            case AuthErrorCode.wrongPassword.rawValue:
                return "wrongPassword"
            case AuthErrorCode.networkError.rawValue:
                return "noInternetConnection"
            case AuthErrorCode.tooManyRequests.rawValue:
                return "tooManyRequests"
            default:
                return String(format: NSLocalizedString("thereHasBeenAnError", comment: ""), authError.localizedDescription)
            }
        }
        return error.localizedDescription
    }
}

// Custom auth errors
enum AuthError: Error {
    case configurationError
    case noViewController
    case tokenError
}

