import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            PlannerView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar" : "calendar")
                    Text("Planner")
                }
                .tag(1)
            
            MarketplaceView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "storefront.fill" : "storefront")
                    Text("Market")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.primaryGreen)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
