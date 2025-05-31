//DashboardView,swift
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var weatherService = OpenMeteoService()
    @State private var selectedGardenFilter = "All"
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        greetingHeader
                        
                        weatherSection
                        
                        quickStatsSection
                        myGardenSection
                        todaysTasksSection
                        localMarketSection
                    }
                    .padding(.vertical)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: 16)
                }
                .navigationBarHidden(true)
                .background(Color.backgroundGray)
            }
            .task {
                await weatherService.fetchWeather()
            }
        }
        
        private var weatherSection: some View {
            VStack(spacing: 8) {
                if weatherService.isLoading {
                    // Loading state
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.lightGray.opacity(0.3))
                        .frame(height: 100)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        )
                        .padding(.horizontal)
                } else if let weather = weatherService.currentWeather {
                    // Weather data
                    WeatherWidget(weather: weather)
                        .padding(.horizontal)
                        .onTapGesture {
                            Task {
                                await weatherService.fetchWeather()
                            }
                        }
                } else {
                    // Error state
                    VStack(spacing: 8) {
                        Text("Weather data unavailable")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        Button("Retry") {
                            Task {
                                await weatherService.fetchWeather()
                            }
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.primaryGreen)
                    }
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.lightGray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Error message ako postoji
                if !weatherService.errorMessage.isEmpty {
                    Text(weatherService.errorMessage)
                        .font(.caption)
                        .foregroundColor(.error)
                        .padding(.horizontal)
                }
            }
        }
    
    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(dynamicGreeting))
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

    private var dynamicGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "goodMorning"
        case 12..<18:
            return "goodAfternoon"
        case 18..<22:
            return "goodEvening"
        default:
            return "goodNight"
        }
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
