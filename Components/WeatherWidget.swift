import SwiftUI

struct WeatherWidget: View {
    let weather: WeatherData
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - main info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(weather.condition.icon)
                        .font(.system(size: 36))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(weather.temperatureText)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(weather.condition.displayName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                // Location - prikaži samo ako nije "Current Location"
                if shouldShowLocation {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(displayLocation)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Garden advice
                Text(weather.gardeningAdvice)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Right side - compact info
            VStack(alignment: .trailing, spacing: 12) {
                // Time
                Text(formatCurrentTime())
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                // Garden status
                VStack(spacing: 4) {
                    Image(systemName: weather.isGoodForGardening ? "leaf.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(weather.isGoodForGardening ? .white : .yellow)
                    
                    Text(weather.isGoodForGardening ? "Perfect" : "Check")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white)
                }
                
                // Quick stats
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(weather.humidity)% • \(Int(weather.windSpeed)) km/h")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(16)
        .frame(height: 120) // Smanjeno s 280 na 120
        .background(gradientBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
    
    // Computed properties za lokaciju
    private var shouldShowLocation: Bool {
        !weather.location.isEmpty &&
        weather.location.lowercased() != "current location" &&
        weather.location != "Loading..."
    }
    
    private var displayLocation: String {
        // Ako je Zagreb ili poznati grad, prikaži
        if weather.location.lowercased().contains("zagreb") {
            return "Zagreb"
        } else if weather.location.lowercased() != "current location" {
            return weather.location
        }
        return ""
    }
    
    private func formatCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "hr_HR")
        return formatter.string(from: Date())
    }
    
    private var gradientBackground: LinearGradient {
        switch weather.condition {
        case .sunny:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .partlyCloudly:
            return LinearGradient(colors: [.blue.opacity(0.8), .gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .cloudy:
            return LinearGradient(colors: [.gray, .gray.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .rainy:
            return LinearGradient(colors: [.blue.opacity(0.7), .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .stormy:
            return LinearGradient(colors: [.gray.opacity(0.9), .black.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .snowy:
            return LinearGradient(colors: [.gray.opacity(0.6), .white.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .foggy:
            return LinearGradient(colors: [.gray.opacity(0.8), .gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            // Test s "Current Location"
            WeatherWidget(weather: WeatherData(
                temperature: 22.0,
                condition: .sunny,
                humidity: 65,
                windSpeed: 8.5,
                precipitation: 0,
                uvIndex: 5,
                location: "Current Location",
                lastUpdated: Date()
            ))
            
            // Test sa Zagreb
            WeatherWidget(weather: WeatherData(
                temperature: 18.0,
                condition: .rainy,
                humidity: 85,
                windSpeed: 12.0,
                precipitation: 5,
                uvIndex: 2,
                location: "Zagreb",
                lastUpdated: Date()
            ))
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .background(Color.backgroundGray)
    }
}
