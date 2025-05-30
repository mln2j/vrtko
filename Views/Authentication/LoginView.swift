import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var showingEmptyEmailAlert = false
    @State private var showingResetSentAlert = false
    @State private var showingResetErrorAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Top spacing
                    Spacer()
                        .frame(height: geometry.size.height * 0.15)
                    
                    // App branding
                    VStack(spacing: 8) {
                        Text("appName")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primaryGreen)
                        
                        Text("motto")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.15)
                    
                    // Login form
                    VStack(spacing: 16) {
                        // Email field
                        TextField("emailAddress", text: $email)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color(UIColor.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .textContentType(.emailAddress)
                        
                        // Password field
                        SecureField("password", text: $password)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color(UIColor.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .textContentType(.password)
                        
                        // Forgot password - S KOMPLETNOM LOGIKOM
                        Button("forgotPassword") {
                            handleForgotPassword()
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .disabled(authService.isLoading)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Error message
                    if !authService.errorMessage.isEmpty {
                        Text(authService.errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 16)
                    }
                    
                    // Buttons
                    VStack(spacing: 12) {
                        // Sign in button
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
                                    Text("signIn")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(email.isEmpty || password.isEmpty ? Color.gray.opacity(0.4) : Color.primaryGreen)
                            )
                        }
                        .disabled(authService.isLoading || email.isEmpty || password.isEmpty)
                        
                        // Google Sign in button
                        Button(action: {
                            Task {
                                await signInWithGoogle()
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "globe")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                
                                Text("signInWithGoogle")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .disabled(authService.isLoading)
                    }
                    .padding(.horizontal, 24)
                    
                    // More spacing before sign up link
                    Spacer()
                        .frame(height: 80)
                    
                    // Sign up link
                    Button(action: {
                        NotificationCenter.default.post(name: .showRegister, object: nil)
                    }) {
                        Text("dontHaveAnAccountSignUp")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
        // ALERT-OVI ZA FORGOT PASSWORD
        .alert("emailRequired", isPresented: $showingEmptyEmailAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("pleaseEnterYourEmailFirst")
        }
        .alert("resetEmailSent", isPresented: $showingResetSentAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("resetEmailHasBeenSentTo \(email)")

        }
        .alert("resetFailed", isPresented: $showingResetErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authService.errorMessage)
        }
    }
    
    // NOVA FUNKCIJA: Forgot password logika
    private func handleForgotPassword() {
        // Provjeri je li email unesen
        if email.isEmpty || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showingEmptyEmailAlert = true
            return
        }
        
        // Poslji reset email
        Task {
            do {
                try await authService.resetPassword(email: email.trimmingCharacters(in: .whitespacesAndNewlines))
                // Uspjeh - prikaži success alert
                await MainActor.run {
                    showingResetSentAlert = true
                }
            } catch {
                // Greška - prikaži error alert
                await MainActor.run {
                    showingResetErrorAlert = true
                }
            }
        }
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
