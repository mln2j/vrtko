import SwiftUI

struct WeatherWidget: View {
    let weather: WeatherData
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(weather.condition.icon)
                        .font(.system(size: 32))
                    
                    Text(weather.temperatureText)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(weather.condition.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(weather.gardeningAdvice)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label("\(weather.humidity)%", systemImage: "humidity")
                    Label("\(Int(weather.windSpeed)) km/h", systemImage: "wind")
                }
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
                .labelStyle(.iconOnly)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(weather.location)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                
                if weather.isGoodForGardening {
                    VStack(spacing: 2) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        Text("Dobro za vrt")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                    }
                } else {
                    VStack(spacing: 2) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                        Text("Provjeri uvjete")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(16)
        .frame(height: 100)
        .background(
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
    
    private var gradientColors: [Color] {
        switch weather.condition {
        case .sunny:
            return [.blue, .cyan]
        case .partlyCloudly:
            return [.blue.opacity(0.8), .gray.opacity(0.6)]
        case .cloudy:
            return [.gray, .gray.opacity(0.8)]
        case .rainy:
            return [.blue.opacity(0.7), .gray]
        case .stormy:
            return [.gray.opacity(0.9), .black.opacity(0.7)]
        case .snowy:
            return [.gray.opacity(0.6), .white.opacity(0.8)]
        case .foggy:
            return [.gray.opacity(0.8), .gray.opacity(0.6)]
        }
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidget(weather: MockData.currentWeather)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
