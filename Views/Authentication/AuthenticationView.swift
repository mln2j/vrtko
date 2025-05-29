import SwiftUI

struct AuthenticationView: View {
    @State private var showingRegister = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if showingRegister {
                    RegisterView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                } else {
                    LoginView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showingRegister)
            .onReceive(NotificationCenter.default.publisher(for: .showRegister)) { _ in
                withAnimation {
                    showingRegister = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showLogin)) { _ in
                withAnimation {
                    showingRegister = false
                }
            }
        }
    }
}

// Notification extensions for navigation
extension Notification.Name {
    static let showRegister = Notification.Name("showRegister")
    static let showLogin = Notification.Name("showLogin")
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthService())
    }
}
