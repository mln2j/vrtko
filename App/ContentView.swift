import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authService = AuthService()

    var body: some View {
        Group {
            if authService.isLoading {
                LoadingScreen()
            } else if let user = authService.user, authService.isAuthenticated {
                if !user.profileCompleted {
                    ProfileSetupView()
                        .environmentObject(authService)
                } else {
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
                    .accentColor(Color("vrtkoPrimary"))
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
