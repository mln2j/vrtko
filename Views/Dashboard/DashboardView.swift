//DashboardView,swift
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authService: AuthService
    @State private var selectedGardenFilter = "All"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    greetingHeader
                    WeatherWidget(weather: MockData.currentWeather)
                        .padding(.horizontal)
                    
                    quickStatsSection
                    myGardenSection
                    todaysTasksSection
                    localMarketSection
                }
                .padding(.vertical)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                            Color.clear
                                .frame(height: 16)
                        }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .background(Color.backgroundGray)
        }
    }
    
    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good morning,")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                
                Text("\(authService.user?.firstName ?? "User")!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.primaryGreen)
            }
        }
        .padding(.horizontal)
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: 12) {
            StatCard(title: "Plants", value: "\(MockData.gardenPlants.count)", icon: "leaf.fill", color: .leafGreen)
            StatCard(title: "Ready", value: "\(MockData.plantsWithStatus(.ready).count)", icon: "checkmark.circle.fill", color: .success)
            StatCard(title: "Tasks", value: "\(MockData.todaysTasks.filter { !$0.isCompleted }.count)", icon: "list.bullet", color: .warning)
        }
        .padding(.horizontal)
    }
    
    private var myGardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Garden")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                NavigationLink("View All", destination: Text("Garden Detail"))
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
                ForEach(Array(MockData.gardenPlants.prefix(3))) { plant in
                    GardenCard(plant: plant)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var todaysTasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Tasks")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                NavigationLink("View All", destination: Text("Tasks"))
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            TasksSectionView()
        }
    }
    
    private var localMarketSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Local Market")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                NavigationLink("View All", destination: Text("Marketplace"))
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(MockData.availableProducts().prefix(4))) { product in
                        ProductCard(product: product)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
