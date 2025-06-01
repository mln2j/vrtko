import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authService = AuthService()
    
    var body: some View {
        Group {
            if let user = authService.user, authService.isAuthenticated {
                if !user.profileCompleted {
                    // Prikazuj ekran za postavljanje profila dok korisnik ne završi
                    ProfileSetupView()
                        .environmentObject(authService)
                } else {
                    // Glavni TabView aplikacije
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
                        
                        GardenListView()
                            .tabItem {
                                Image(systemName: "leaf.fill")
                                Text("Gardens")
                            }
                        
                        ProfileView()
                            .tabItem {
                                Image(systemName: "person.fill")
                                Text("Profile")
                            }
                    }
                    .accentColor(.primaryGreen)
                    .environmentObject(authService)
                }
            } else {
                AuthenticationView()
                    .environmentObject(authService)
            }
        }
        .environmentObject(authService)
    }
}

