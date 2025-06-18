import SwiftUI

extension Color {
    // Gradient kombinacije koriste tvoje asset boje
    static let gardenGradient = LinearGradient(
        colors: [Color("vrtkoLeafGreen"), Color("vrtkoPrimary")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let skyGradient = LinearGradient(
        colors: [Color("vrtkoSkyBlue"), Color("vrtkoCyan")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let earthGradient = LinearGradient(
        colors: [Color("vrtkoSoilBrown"), Color("vrtkoSecondary")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
}
