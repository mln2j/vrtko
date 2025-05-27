// Extensions/Currency+Converter.swift
extension Double {
    static let kunaToEuroRate = 7.53450  // Službeni tečaj
    
    var kunaToEuro: Double {
        return self / Double.kunaToEuroRate
    }
    
    var euroToKuna: Double {
        return self * Double.kunaToEuroRate
    }
}

// Korištenje:
let priceInKuna = 15.0
let priceInEuro = priceInKuna.kunaToEuro  // ~1.99 EUR
