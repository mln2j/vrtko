import Foundation
import FirebaseAuth
import Combine
import GoogleSignIn
import FirebaseCore

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
                    self?.createUserFromFirebaseUser(user)
                } else {
                    self?.user = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    private func checkAuthStatus() {
        if let currentUser = Auth.auth().currentUser {
            createUserFromFirebaseUser(currentUser)
        }
    }
    
    private func createUserFromFirebaseUser(_ firebaseUser: FirebaseAuth.User) {
        self.user = User(
            name: firebaseUser.displayName ?? "User",
            email: firebaseUser.email ?? "",
            avatar: "person.circle.fill",
            location: "Zagreb",
            joinDate: firebaseUser.metadata.creationDate ?? Date(),
            rating: 4.5,
            totalSales: 0,
            isVerified: firebaseUser.isEmailVerified
        )
        self.isAuthenticated = true
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String, location: String) async throws {
        isLoading = true
        errorMessage = ""
        
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = "\(firstName) \(lastName)"
            try await changeRequest.commitChanges()
            
            try await result.user.sendEmailVerification()
            
        } catch {
            errorMessage = handleAuthError(error)
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = ""
        
        defer { isLoading = false }
        
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
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
            
            _ = try await Auth.auth().signIn(with: credential)
            
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
