import SwiftUI

extension Color {
    // Primary colors
    static let primaryGreen = Color(red: 0.18, green: 0.49, blue: 0.18) // #2E7D2E
    static let secondaryBrown = Color(red: 0.55, green: 0.27, blue: 0.07) // #8B4513
    static let accentOrange = Color(red: 1.0, green: 0.55, blue: 0.0) // #FF8C00
    
    // Background colors
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.98) // #FAFAFA
    static let cardBackground = Color.white
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97) // #F2F2F7
    
    // Text colors
    static let textPrimary = Color.black
    static let textSecondary = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    static let textTertiary = Color(red: 0.78, green: 0.78, blue: 0.80) // #C7C7CC
    
    // Status colors
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    // Garden specific colors
    static let soilBrown = Color(red: 0.4, green: 0.26, blue: 0.13)
    static let leafGreen = Color(red: 0.13, green: 0.55, blue: 0.13)
    static let sunYellow = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let waterBlue = Color(red: 0.0, green: 0.48, blue: 0.8)
    
    // Gradient combinations
    static let gardenGradient = LinearGradient(
        colors: [.leafGreen, .primaryGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let skyGradient = LinearGradient(
        colors: [.blue, .cyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let earthGradient = LinearGradient(
        colors: [.soilBrown, .secondaryBrown],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Custom color scheme
extension Color {
    static func theme(_ colorScheme: ColorScheme) -> ThemeColors {
        switch colorScheme {
        case .light:
            return ThemeColors.light
        case .dark:
            return ThemeColors.dark
        @unknown default:
            return ThemeColors.light
        }
    }
}

struct ThemeColors {
    let background: Color
    let cardBackground: Color
    let textPrimary: Color
    let textSecondary: Color
    
    static let light = ThemeColors(
        background: .backgroundGray,
        cardBackground: .white,
        textPrimary: .black,
        textSecondary: .textSecondary
    )
    
    static let dark = ThemeColors(
        background: Color(red: 0.11, green: 0.11, blue: 0.12),
        cardBackground: Color(red: 0.17, green: 0.17, blue: 0.18),
        textPrimary: .white,
        textSecondary: Color(red: 0.92, green: 0.92, blue: 0.96)
    )
}

import UIKit

extension UIColor {
    static let primaryGreen = UIColor(red: 0.18, green: 0.49, blue: 0.18, alpha: 1.0) // #2E7D2E
}
