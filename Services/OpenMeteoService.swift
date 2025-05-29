//
//  OpenMeteoService.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 29.05.2025..
//

import Foundation
import CoreLocation

@MainActor
class OpenMeteoService: NSObject, ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchWeather() async {
        isLoading = true
        errorMessage = ""
        
        guard let location = locationManager.location else {
            // Default Zagreb coordinates ako nema location
            await fetchWeatherData(lat: 45.8150, lon: 15.9819, locationName: "Zagreb")
            return
        }
        
        await fetchWeatherData(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude,
            locationName: "Current Location"
        )
    }
    
    // NOVA METODA: Reverse geocoding za dobijanje naziva grada
    private func getCityName(lat: Double, lon: Double) async -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let city = placemarks.first?.locality {
                return city
            } else if let subLocality = placemarks.first?.subLocality {
                return subLocality
            } else if let administrativeArea = placemarks.first?.administrativeArea {
                return administrativeArea
            }
        } catch {
            print("Reverse geocoding failed: \(error)")
        }
        
        return "Unknown Location"
    }
    
    // AŽURIRANA METODA: s reverse geocoding podršksom
    private func fetchWeatherData(lat: Double, lon: Double, locationName: String) async {
        // Za "Current Location", pokušaj dobiti stvarno ime grada
        let cityName = if locationName == "Current Location" {
            await getCityName(lat: lat, lon: lon)
        } else {
            locationName
        }
        
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            
            currentWeather = WeatherData(
                temperature: response.current.temperature2m,
                condition: mapWeatherCode(response.current.weatherCode),
                humidity: Int(response.current.relativeHumidity2m),
                windSpeed: response.current.windSpeed10m,
                precipitation: 0,
                uvIndex: 0,
                location: cityName, // ← Koristi stvarno ime grada
                lastUpdated: Date()
            )
            
        } catch {
            errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func mapWeatherCode(_ code: Int) -> WeatherCondition {
        // WMO Weather interpretation codes
        switch code {
        case 0: return .sunny                    // Clear sky
        case 1, 2, 3: return .partlyCloudly     // Mainly clear, partly cloudy, overcast
        case 45, 48: return .foggy              // Fog
        case 51, 53, 55: return .rainy          // Drizzle
        case 61, 63, 65: return .rainy          // Rain
        case 71, 73, 75: return .snowy          // Snow fall
        case 95, 96, 99: return .stormy         // Thunderstorm
        default: return .sunny
        }
    }
}

// MARK: - Location Manager Delegate
extension OpenMeteoService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            await fetchWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Location error: \(error.localizedDescription)"
        Task {
            await fetchWeatherData(lat: 45.8150, lon: 15.9819, locationName: "Zagreb")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            errorMessage = "Location access denied - using Zagreb"
            Task {
                await fetchWeatherData(lat: 45.8150, lon: 15.9819, locationName: "Zagreb")
            }
        default:
            break
        }
    }
}

// MARK: - Open-Meteo Response Models
struct OpenMeteoResponse: Codable {
    let current: OpenMeteoCurrentWeather
}

struct OpenMeteoCurrentWeather: Codable {
    let temperature2m: Double
    let relativeHumidity2m: Double
    let windSpeed10m: Double
    let weatherCode: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case relativeHumidity2m = "relative_humidity_2m"
        case windSpeed10m = "wind_speed_10m"
        case weatherCode = "weather_code"
    }
}
