import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authService: AuthService
    @Binding var selectedTab: Int
    @StateObject private var weatherService = OpenMeteoService()
    @StateObject private var plantRepo = PlantRepository()
    @StateObject private var productRepo = ProductRepository()
    @StateObject private var taskRepo = TaskRepository()
    @StateObject private var gardensRepo = GardenRepository()
    @State private var selectedGardenFilter = "All"
    @State private var showLoader = false
    @State private var loadingStartTime: Date?
    @State private var selectedProduct: Product?
    
    private var todaysTasks: [TaskItem] {
        let today = Calendar.current.startOfDay(for: Date())
        let userPlantIds = plantRepo.plants.compactMap { $0.id }
        return taskRepo.tasks.filter { task in
            guard let plantId = task.relatedPlant else { return false }
            let isToday = Calendar.current.isDate(task.dueDate, inSameDayAs: today)
            let isForUserPlant = userPlantIds.contains(plantId)
            return isToday && isForUserPlant
        }
    }
    
    func handleTaskToggle(_ updatedTask: TaskItem) {
        Task {
            // 1. Ažuriraj task u bazi
            try? await taskRepo.updateTask(updatedTask)
            
            // 2. Ako task ima povezanu biljku
            guard let plantId = updatedTask.relatedPlant else { return }
            
            // 3. Ovisno o tipu taska i je li dovršen, ažuriraj status biljke
            switch updatedTask.taskType {
            case .harvesting:
                if updatedTask.isCompleted {
                    // Dovršeno: postavi status na harvested
                    try? await plantRepo.updatePlantStatus(plantId: plantId, newStatus: .harvested)
                } else {
                    // Vraćeno: postavi status na ready (ili što ti ima smisla)
                    try? await plantRepo.updatePlantStatus(plantId: plantId, newStatus: .ready)
                }
            case .weeding:
                if updatedTask.isCompleted {
                    // Dovršeno: možeš postaviti status na growing ili drugi
                    try? await plantRepo.updatePlantStatus(plantId: plantId, newStatus: .fruiting)
                } else {
                    // Vraćeno: vrati na prethodni status (npr. planted)
                    try? await plantRepo.updatePlantStatus(plantId: plantId, newStatus: .growing)
                }
            case .watering:
                if updatedTask.isCompleted {
                    // Dovršeno: možeš postaviti status na growing ili drugi
                    try? await plantRepo.updatePlantStatus(plantId: plantId, newStatus: .growing)
                } else {
                    // Vraćeno: vrati na prethodni status (npr. planted)
                    try? await plantRepo.updatePlantStatus(plantId: plantId, newStatus: .planted)
                }
            default:
                break
            }
        }
    }



    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    greetingHeader
                    weatherSection
                    quickStatsSection
                    if authService.user?.role != .buyer {
                        myGardensSection
                        todaysTasksSection
                    }
                    localMarketSection
                }
                .padding(.vertical)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: 16)
            }
            .navigationBarHidden(true)
            .onAppear {
                if let userId = authService.user?.id {
                    plantRepo.fetchPlantsForUser(userId: userId)
                    productRepo.fetchProducts()
                    taskRepo.fetchTasks(for: userId)
                    gardensRepo.fetchGardens(for: userId)
                }
            }
        }
        .task {
            await weatherService.fetchWeather()
        }
        .onChange(of: weatherService.isLoading) { isLoading in
            if isLoading {
                loadingStartTime = Date()
                showLoader = true
            } else if let start = loadingStartTime {
                let elapsed = Date().timeIntervalSince(start)
                let minDuration = 0.4
                if elapsed < minDuration {
                    DispatchQueue.main.asyncAfter(deadline: .now() + (minDuration - elapsed)) {
                        showLoader = false
                    }
                } else {
                    showLoader = false
                }
            }
        }
    }

    private var weatherSection: some View {
        VStack(spacing: 8) {
            if weatherService.isLoading || showLoader {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .frame(height: 120)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    )
                    .padding(.horizontal)
            } else if let weather = weatherService.currentWeather {
                WeatherWidget(weather: weather)
                    .padding(.horizontal)
                    .onTapGesture {
                        Task {
                            await weatherService.fetchWeather()
                        }
                    }
            } else {
                VStack(spacing: 8) {
                    Text("Weather data unavailable")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("vrtkoSecondaryText"))

                    Button("Retry") {
                        Task {
                            await weatherService.fetchWeather()
                        }
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("vrtkoPrimary"))
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color("vrtkoLightGray").opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
            }

            if !weatherService.errorMessage.isEmpty {
                Text(weatherService.errorMessage)
                    .font(.caption)
                    .foregroundColor(Color("vrtkoError"))
                    .padding(.horizontal)
            }
        }
    }

    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(dynamicGreeting))
                    .font(.system(size: 16))
                    .foregroundColor(Color("vrtkoSecondaryText"))

                Text("\(authService.user?.firstName ?? "User")!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("vrtkoPrimaryText"))
            }
            Spacer()
            Button(action: {
                selectedTab = 4 // Profile tab tag
            }) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color("vrtkoPrimary"))
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
            Button(action: {
                selectedTab = 3
            }) {
                StatCard(title: "Plants", value: "\(plantRepo.plants.count)", icon: "leaf.fill", color: Color("vrtkoLeafGreen"))
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                selectedTab = 2
            }) {
                StatCard(
                    title: "For Sale",
                    value: "\(productRepo.products.filter { $0.availability == .available }.count)",
                    icon: "cart.fill",
                    color: Color("vrtkoSuccess")
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                selectedTab = 1
            }) {
                StatCard(title: "Tasks", value: "\(taskRepo.tasks.filter { !$0.isCompleted }.count)", icon: "list.bullet", color: Color("vrtkoWarning"))
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(.horizontal)
    }

    private var myGardensSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Gardens")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Button(action: {
                    selectedTab = 3 // Gardens tab tag
                }) {
                    Text("View All")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(gardensRepo.gardens.prefix(5)) { garden in
                        NavigationLink(destination: GardenDetailView(garden: garden, gardenRepo: gardensRepo)
                            .environmentObject(authService)) {
                            GardenCard(garden: garden)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }


    private var todaysTasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Tasks")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Button(action: {
                    selectedTab = 1 // Gdje je 1 tag za PlannerView tab
                }) {
                    Text("View All")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            TasksSectionView(tasks: todaysTasks, onToggle: handleTaskToggle)
        }
    }

    private var localMarketSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Local Market")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Button(action: {
                    selectedTab = 2
                }) {
                    Text("View All")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(productRepo.products.prefix(4)) { product in
                        Button {
                            selectedProduct = product
                        } label: {
                            ProductCard(product: product)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }.sheet(item: $selectedProduct) { product in
            ProductDetailView(
                product: product,
                productRepo: productRepo,
                currentUserId: authService.user?.id ?? ""
            )
        }
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(selectedTab: .constant(0))
            .environmentObject(AuthService())
    }
}
