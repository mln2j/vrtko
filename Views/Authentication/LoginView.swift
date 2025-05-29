import SwiftUI
import FirebaseAuth
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Logo and title section
                    VStack(spacing: 20) {
                        Spacer()
                            .frame(height: geometry.size.height * 0.1)
                        
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryGreen.opacity(0.1))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(.primaryGreen)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Vrtko")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                Text("Tvoj vrt, tvoj plac")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    
                    // Login form
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
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
                                Text("Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                
                                SecureField("Enter your password", text: $password)
                                    .padding(16)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.lightGray, lineWidth: 1)
                                    )
                            }
                        }
                        
                        if !authService.errorMessage.isEmpty {
                            Text(authService.errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.error)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            Task {
                                await signIn()
                            }
                        }) {
                            HStack {
                                if authService.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(email.isEmpty || password.isEmpty ? Color.textSecondary : Color.primaryGreen)
                            )
                        }
                        .disabled(authService.isLoading || email.isEmpty || password.isEmpty)
                        
                        Button("Forgot Password?") {
                            Task {
                                if !email.isEmpty {
                                    try? await authService.resetPassword(email: email)
                                }
                            }
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primaryGreen)
                    }
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.textTertiary)
                        
                        Text("or continue with")
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
                            await signInWithGoogle()
                        }
                    })
                    .frame(height: 56)
                    .cornerRadius(12)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Sign up link
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                        
                        Button("Sign Up") {
                            NotificationCenter.default.post(name: .showRegister, object: nil)
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.05)
                }
                .padding(.horizontal, 24)
            }
        }
        .background(Color.backgroundGray)
        .ignoresSafeArea(.keyboard)
    }
    
    private func signIn() async {
        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            // Error is handled in AuthService
        }
    }
    
    private func signInWithGoogle() async {
        do {
            try await authService.signInWithGoogle()
        } catch {
            // Error is handled in AuthService
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthService())
    }
}
