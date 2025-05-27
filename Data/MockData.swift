import Foundation
import SwiftUI

class MockData {
    // MARK: - Current User
    static let currentUser = User(
        name: "Mihael Lendvaj",
        email: "mihael.lendvaj@example.com",
        avatar: "person.circle.fill",
        location: "Zagreb",
        phoneNumber: "+385 98 123 4567",
        joinDate: Date().addingDays(-120),
        rating: 4.7,
        totalSales: 23,
        isVerified: true
    )
    
    // MARK: - Users
    static let users: [User] = [
        currentUser,
        User(name: "Marko Petrović", email: "marko.p@example.com", location: "Maksimir", joinDate: Date().addingDays(-200), rating: 4.8, totalSales: 45, isVerified: true),
        User(name: "Petra Simić", email: "petra.s@example.com", location: "Dubrava", joinDate: Date().addingDays(-80), rating: 4.9, totalSales: 12, isVerified: false),
        User(name: "Ivan Kovač", email: "ivan.k@example.com", location: "Trešnjevka", joinDate: Date().addingDays(-300), rating: 4.7, totalSales: 67, isVerified: true),
        User(name: "Maja Lovrić", email: "maja.l@example.com", location: "Črnomerec", joinDate: Date().addingDays(-50), rating: 4.6, totalSales: 8, isVerified: false),
        User(name: "Tomislav Matić", email: "tomislav.m@example.com", location: "Maksimir", joinDate: Date().addingDays(-180), rating: 4.9, totalSales: 34, isVerified: true),
        User(name: "Anja Tomić", email: "anja.t@example.com", location: "Novi Zagreb", joinDate: Date().addingDays(-90), rating: 4.5, totalSales: 15, isVerified: false)
    ]
    
    // MARK: - Plant Types
    static let plantTypes: [PlantType] = [
        PlantType(name: "Rajčica", category: .vegetables, scientificName: "Solanum lycopersicum", daysToMaturity: 80, plantingMonths: [4, 5, 6], harvestMonths: [7, 8, 9], difficulty: .medium, sunRequirement: .fullSun, waterRequirement: .medium, spaceRequirement: 50, icon: "🍅"),
        PlantType(name: "Mrkva", category: .vegetables, scientificName: "Daucus carota", daysToMaturity: 70, plantingMonths: [3, 4, 7, 8], harvestMonths: [6, 7, 10, 11], difficulty: .easy, sunRequirement: .fullSun, waterRequirement: .medium, spaceRequirement: 5, icon: "🥕"),
        PlantType(name: "Salata", category: .vegetables, scientificName: "Lactuca sativa", daysToMaturity: 45, plantingMonths: [3, 4, 8, 9], harvestMonths: [5, 6, 10, 11], difficulty: .easy, sunRequirement: .partialSun, waterRequirement: .medium, spaceRequirement: 20, icon: "🥬"),
        PlantType(name: "Paprika", category: .vegetables, scientificName: "Capsicum annuum", daysToMaturity: 75, plantingMonths: [5, 6], harvestMonths: [8, 9, 10], difficulty: .medium, sunRequirement: .fullSun, waterRequirement: .medium, spaceRequirement: 40, icon: "🫑"),
        PlantType(name: "Bosiljak", category: .herbs, scientificName: "Ocimum basilicum", daysToMaturity: 60, plantingMonths: [4, 5, 6], harvestMonths: [6, 7, 8, 9], difficulty: .easy, sunRequirement: .fullSun, waterRequirement: .medium, spaceRequirement: 15, icon: "🌿"),
        PlantType(name: "Tikvica", category: .vegetables, scientificName: "Cucurbita pepo", daysToMaturity: 50, plantingMonths: [5, 6], harvestMonths: [7, 8, 9], difficulty: .easy, sunRequirement: .fullSun, waterRequirement: .high, spaceRequirement: 100, icon: "🥒")
    ]
    
    // MARK: - Products
    static let products: [Product] = [
        Product(
            name: "Svježe rajčice",
            description: "Domaće rajčice uzgojene bez pesticida. Slatke i sočne, savršene za salate.",
            price: 2.0,  // ← Bilo 15 kn, sada ~2 EUR
            unit: .kg,
            category: .vegetables,
            images: ["🍅"],
            seller: users[1],
            location: ProductLocation(address: "Maksimirska 45", city: "Zagreb", postalCode: "10000", latitude: 45.8150, longitude: 15.9819, distanceFromUser: 1.2),
            availability: .available,
            quality: .excellent,
            isOrganic: true,
            harvestDate: Date().addingDays(-2),
            rating: 4.8,
            reviewCount: 12
        ),
        Product(
            name: "Organska mrkva",
            description: "Domaća mrkva iz ekološkog uzgoja. Slatka i hrskava.",
            price: 1.1,  // ← Bilo 8 kn, sada ~1.10 EUR
            unit: .kg,
            category: .vegetables,
            images: ["🥕"],
            seller: users[2],
            location: ProductLocation(address: "Dubravska 23", city: "Zagreb", postalCode: "10040", latitude: 45.8050, longitude: 16.0319, distanceFromUser: 2.1),
            availability: .available,
            quality: .good,
            isOrganic: true,
            harvestDate: Date().addingDays(-1),
            rating: 4.9,
            reviewCount: 8
        ),
        Product(
            name: "Zelena salata",
            description: "Svježa ledena salata, idealna za proljetne salate.",
            price: 1.6,  // ← Bilo 12 kn, sada ~1.60 EUR
            unit: .piece,
            category: .vegetables,
            images: ["🥬"],
            seller: users[3],
            location: ProductLocation(address: "Trešnjevački put 10", city: "Zagreb", postalCode: "10020", latitude: 45.8000, longitude: 15.9500, distanceFromUser: 0.8),
            availability: .available,
            quality: .excellent,
            isOrganic: false,
            harvestDate: Date(),
            rating: 4.7,
            reviewCount: 5
        ),
        Product(
            name: "Crvena paprika",
            description: "Slatka crvena paprika, odličnana za roštilj i kuhanje.",
            price: 2.4,  // ← Bilo 18 kn, sada ~2.40 EUR
            unit: .kg,
            category: .vegetables,
            images: ["🫑"],
            seller: users[4],
            location: ProductLocation(address: "Črnomerečka 67", city: "Zagreb", postalCode: "10110", latitude: 45.8200, longitude: 15.9200, distanceFromUser: 3.2),
            availability: .reserved,
            quality: .good,
            isOrganic: false,
            harvestDate: Date().addingDays(-3),
            rating: 4.6,
            reviewCount: 15
        ),
        Product(
            name: "Miješano začinsko bilje",
            description: "Mix domaćih začina: bosiljak, peršin, majčina dušica.",
            price: 0.7,  // ← Bilo 5 kn, sada ~0.70 EUR
            unit: .bunch,
            category: .herbs,
            images: ["🌿"],
            seller: users[5],
            location: ProductLocation(address: "Maksimirski prilaz 28", city: "Zagreb", postalCode: "10000", latitude: 45.8180, longitude: 15.9900, distanceFromUser: 1.5),
            availability: .available,
            quality: .excellent,
            isOrganic: true,
            harvestDate: Date(),
            rating: 4.9,
            reviewCount: 20
        ),
        Product(
            name: "Mlada tikvica",
            description: "Nježne mlade tikvice, savršene za grilanje.",
            price: 1.3,  // ← Bilo 10 kn, sada ~1.30 EUR
            unit: .kg,
            category: .vegetables,
            images: ["🥒"],
            seller: users[6],
            location: ProductLocation(address: "Novozagrebačka 45", city: "Zagreb", postalCode: "10090", latitude: 45.7800, longitude: 15.9600, distanceFromUser: 4.1),
            availability: .available,
            quality: .good,
            isOrganic: false,
            harvestDate: Date().addingDays(-1),
            rating: 4.5,
            reviewCount: 7
        )
    ]
    
    // MARK: - Garden Plants
    static let gardenPlants: [GardenPlant] = [
        GardenPlant(
            plantType: plantTypes[0], // Rajčica
            variety: "Cherry rajčica",
            status: .growing,
            plantedDate: Date().addingDays(-30),
            expectedHarvestDate: Date().addingDays(50),
            actualHarvestDate: nil,
            notes: "Prvo sadnja ove godine. Raste dobro.",
            photos: [],
            location: PlantLocation(section: "Glavna gredica", row: 1, position: 1, coordinates: CGPoint(x: 100, y: 50))
        ),
        GardenPlant(
            plantType: plantTypes[1], // Mrkva
            variety: "Nantes mrkva",
            status: .ready,
            plantedDate: Date().addingDays(-60),
            expectedHarvestDate: Date().addingDays(10),
            actualHarvestDate: nil,
            notes: "Sprema za berbu sljedeći tjedan.",
            photos: [],
            location: PlantLocation(section: "Korijenje", row: 2, position: 3, coordinates: CGPoint(x: 50, y: 100))
        ),
        GardenPlant(
            plantType: plantTypes[2], // Salata
            variety: "Iceberg salata",
            status: .growing,
            plantedDate: Date().addingDays(-20),
            expectedHarvestDate: Date().addingDays(25),
            actualHarvestDate: nil,
            notes: "Druga serija sadnje.",
            photos: [],
            location: PlantLocation(section: "Listovno povrće", row: 1, position: 2, coordinates: CGPoint(x: 150, y: 75))
        ),
        GardenPlant(
            plantType: plantTypes[3], // Paprika
            variety: "Slatka babura",
            status: .flowering,
            plantedDate: Date().addingDays(-45),
            expectedHarvestDate: Date().addingDays(30),
            actualHarvestDate: nil,
            notes: "Počela cvjetati prošli tjedan.",
            photos: [],
            location: PlantLocation(section: "Glavna gredica", row: 1, position: 3, coordinates: CGPoint(x: 200, y: 50))
        )
    ]
    
    // MARK: - Tasks
    static let todaysTasks: [TaskItem] = [
        TaskItem(
            title: "Zalij rajčice",
            description: "Provjerite vlagu tla i zalijte ako je potrebno",
            taskType: .watering,
            priority: .high,
            dueDate: Date().addingTimeInterval(2 * 3600), // 2 sata od sada
            estimatedDuration: 15,
            relatedPlant: gardenPlants[0].id
        ),
        TaskItem(
            title: "Provjeri rast mrkve",
            description: "Izmjerite veličinu korijena",
            taskType: .monitoring,
            priority: .medium,
            dueDate: Date().addingTimeInterval(4 * 3600), // 4 sata od sada
            estimatedDuration: 10,
            isCompleted: true,
            completedDate: Date().addingTimeInterval(-1800), // prije 30 min
            relatedPlant: gardenPlants[1].id
        ),
        TaskItem(
            title: "Uberi salatu",
            description: "Prva salata je spremna za berbu",
            taskType: .harvesting,
            priority: .medium,
            dueDate: Date().addingTimeInterval(8 * 3600), // 8 sati od sada
            estimatedDuration: 20,
            relatedPlant: gardenPlants[2].id
        ),
        TaskItem(
            title: "Posadi nove sjemenke",
            description: "Posaditi novu seriju salate",
            taskType: .planting,
            priority: .low,
            dueDate: Date().addingTimeInterval(10 * 3600), // 10 sati od sada
            estimatedDuration: 45
        )
    ]
    
    // MARK: - Weather Data
    static let currentWeather = WeatherData(
        temperature: 22.0,
        condition: .sunny,
        humidity: 65,
        windSpeed: 5.2,
        precipitation: 0.0,
        uvIndex: 6,
        location: "Zagreb",
        lastUpdated: Date()
    )
    
    // MARK: - Helper methods
    static func randomProduct() -> Product {
        products.randomElement() ?? products[0]
    }
    
    static func randomUser() -> User {
        users.randomElement() ?? users[0]
    }
    
    static func randomPlant() -> GardenPlant {
        gardenPlants.randomElement() ?? gardenPlants[0]
    }
    
    static func tasksForDate(_ date: Date) -> [TaskItem] {
        // Generiraj zadatke za određeni datum
        return todaysTasks.map { task in
            TaskItem(
                title: task.title,
                description: task.description,
                taskType: task.taskType,
                priority: task.priority,
                dueDate: date,
                estimatedDuration: task.estimatedDuration,
                isCompleted: task.isCompleted,
                relatedPlant: task.relatedPlant
            )
        }
    }
    
    static func productsInCategory(_ category: ProductCategory) -> [Product] {
        products.filter { $0.category == category }
    }
    
    static func availableProducts() -> [Product] {
        products.filter { $0.availability == .available }
    }
    
    static func plantsWithStatus(_ status: PlantStatus) -> [GardenPlant] {
        gardenPlants.filter { $0.status == status }
    }
}

// MARK: - Sample data for testing
extension MockData {
    static let sampleProduct = products[0]
    static let sampleUser = users[0]
    static let samplePlant = gardenPlants[0]
    static let sampleTask = todaysTasks[0]
}
