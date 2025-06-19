import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authService = AuthService()
    @StateObject private var plantRepo = PlantRepository()
    @StateObject private var gardenRepo = GardenRepository()
    @StateObject private var productRepo = ProductRepository()
    @State private var selectedTab = 0
    let numTabs = 5

    var body: some View {
        Group {
            if authService.isLoading {
                LoadingScreen()
            } else if let user = authService.user, authService.isAuthenticated {
                if !user.profileCompleted {
                    ProfileSetupView()
                        .environmentObject(authService)
                } else {
                    TabView(selection: $selectedTab) {
                        DashboardView(selectedTab: $selectedTab)
                            .tabItem {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                            .tag(0)
                        PlannerView()
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("Calendar")
                            }
                            .tag(1)
                        MarketplaceView(plantRepo: plantRepo, gardenRepo: gardenRepo)
                            .tabItem {
                                Image(systemName: "storefront.fill")
                                Text("Market")
                            }
                            .tag(2)
                        GardenListView()
                            .tabItem {
                                Image(systemName: "leaf.fill")
                                Text("Gardens")
                            }
                            .tag(3)
                        ProfileView(
                            plantRepo: plantRepo,
                            productRepo: productRepo,
                            gardenRepo: gardenRepo,
                            selectedTab: $selectedTab
                        )
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .tag(4)
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
