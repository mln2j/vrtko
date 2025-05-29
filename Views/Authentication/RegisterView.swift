import SwiftUI
import FirebaseAuth
import GoogleSignInSwift

struct RegisterView: View {
    @EnvironmentObject var authService: AuthService
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var location = "Zagreb"
    @State private var acceptTerms = false
    
    private var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty &&
        password.count >= 6 && password == confirmPassword && acceptTerms
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 20) {
                        Spacer()
                            .frame(height: 40)
                        
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryGreen.opacity(0.1))
                                    .frame(width: 70, height: 70)
                                
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 30))
                                    .foregroundColor(.primaryGreen)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Create Account")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                Text("Join the Vrtko community")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 30)
                    }
                    
                    // Registration form
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("First Name")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                
                                TextField("First name", text: $firstName)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.lightGray, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Name")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                
                                TextField("Last name", text: $lastName)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.lightGray, lineWidth: 1)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter your email", text: $email)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.lightGray, lineWidth: 1)
                                )
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Your city", text: $location)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.lightGray, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            SecureField("Create password", text: $password)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.lightGray, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            SecureField("Confirm password", text: $confirmPassword)
                                .padding(16)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(password != confirmPassword && !confirmPassword.isEmpty ? Color.error : Color.lightGray, lineWidth: 1)
                                )
                        }
                        
                        if password != confirmPassword && !confirmPassword.isEmpty {
                            Text("Passwords don't match")
                                .font(.system(size: 12))
                                .foregroundColor(.error)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if !authService.errorMessage.isEmpty {
                            Text(authService.errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.error)
                                .multilineTextAlignment(.center)
                        }
                        
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: {
                                acceptTerms.toggle()
                            }) {
                                Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 20))
                                    .foregroundColor(acceptTerms ? .primaryGreen : .textSecondary)
                            }
                            
                            Text("I agree to the Terms of Service and Privacy Policy")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        
                        Button(action: {
                            Task {
                                await signUp()
                            }
                        }) {
                            HStack {
                                if authService.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Create Account")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isFormValid ? Color.primaryGreen : Color.textSecondary)
                            )
                        }
                        .disabled(!isFormValid || authService.isLoading)
                    }
                    
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.textTertiary)
                        
                        Text("or sign up with")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 16)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(.vertical, 30)
                    
                    // Google Sign In
                    GoogleSignInButton(action: {
                        Task {
                            await signUpWithGoogle()
                        }
                    })
                    .frame(height: 56)
                    .cornerRadius(12)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                        
                        Button("Sign In") {
                            NotificationCenter.default.post(name: .showLogin, object: nil)
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                    }
                    
                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .background(Color.backgroundGray)
        .ignoresSafeArea(.keyboard)
    }
    
    private func signUp() async {
        do {
            try await authService.signUp(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                location: location
            )
        } catch {
            // Error is handled in AuthService
        }
    }
    
    private func signUpWithGoogle() async {
        do {
            try await authService.signInWithGoogle()
        } catch {
            // Error is handled in AuthService
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthService())
    }
}
