import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let condition: WeatherCondition
    let humidity: Int
    let windSpeed: Double
    let precipitation: Double
    let uvIndex: Int
    let location: String
    let lastUpdated: Date
    
    var temperatureText: String {
        return String(format: "%.0f°C", temperature)
    }
    
    var isGoodForGardening: Bool {
        temperature >= 10 && temperature <= 30 && precipitation < 5 && windSpeed < 20
    }
    
    var gardeningAdvice: String {
        if isGoodForGardening {
            return "Savršeno vrijeme za rad u vrtu"
        } else if precipitation > 10 {
            return "Previše kiše za rad vani"
        } else if temperature < 10 {
            return "Prehladno za sadnju"
        } else if temperature > 30 {
            return "Prevrelo, zalij biljke"
        } else {
            return "Provjeri uvjete prije rada"
        }
    }
}

enum WeatherCondition: String, CaseIterable, Codable {
    case sunny = "sunny"
    case partlyCloudly = "partlyCloudly"
    case cloudy = "cloudy"
    case rainy = "rainy"
    case stormy = "stormy"
    case snowy = "snowy"
    case foggy = "foggy"
    
    var icon: String {
        switch self {
        case .sunny: return "☀️"
        case .partlyCloudly: return "⛅"
        case .cloudy: return "☁️"
        case .rainy: return "🌧️"
        case .stormy: return "⛈️"
        case .snowy: return "❄️"
        case .foggy: return "🌫️"
        }
    }
    
    var displayName: String {
        switch self {
        case .sunny: return "Sunčano"
        case .partlyCloudly: return "Djelomično oblačno"
        case .cloudy: return "Oblačno"
        case .rainy: return "Kišovito"
        case .stormy: return "Grmljavina"
        case .snowy: return "Snijeg"
        case .foggy: return "Magla"
        }
    }
}
