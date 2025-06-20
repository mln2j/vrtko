import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    
    private var isFormValid: Bool {
        !email.isEmpty && password.count >= 6
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Top spacing
                    Spacer()
                        .frame(height: geometry.size.height * 0.12)
                    
                    // App branding
                    VStack(spacing: 8) {
                        Text("appName")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color("vrtkoPrimary"))
                        
                        Text("motto")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.12)
                    
                    // Registration form
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
                            .textContentType(.newPassword)
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
                    
                    // Sign up button
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
                                Text("signUp")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isFormValid ? Color("vrtkoPrimary") : Color.gray.opacity(0.4))
                        )
                    }
                    .disabled(!isFormValid || authService.isLoading)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 80)
                    
                    // Sign in link
                    Button(action: {
                        NotificationCenter.default.post(name: .showLogin, object: nil)
                    }) {
                        Text("haveAnAccountSignIn")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
    }
    
    private func signUp() async {
        do {
            try await authService.signUp(
                email: email,
                password: password
            )
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

