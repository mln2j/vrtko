import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authService = AuthService()
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                TabView {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    PlannerView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Calendar")
                        }
                    
                    MarketplaceView()
                        .tabItem {
                            Image(systemName: "storefront.fill")
                            Text("Market")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .accentColor(.primaryGreen)
            } else {
                AuthenticationView()
            }
        }
        .environmentObject(authService)
    }
}
