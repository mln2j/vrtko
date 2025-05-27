//
//  NumberFormatter+Currency.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 27.05.2025..
//


import Foundation

extension NumberFormatter {
    static let croatianCurrency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "hr_HR")
        formatter.currencyCode = "EUR"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static let croatianCurrencyNoDecimals: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "hr_HR")
        formatter.currencyCode = "EUR"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

extension Double {
    var croatianCurrencyFormatted: String {
        NumberFormatter.croatianCurrency.string(from: NSNumber(value: self)) ?? "€\(self)"
    }
    
    var croatianCurrencyFormattedCompact: String {
        NumberFormatter.croatianCurrencyNoDecimals.string(from: NSNumber(value: self)) ?? "€\(self)"
    }
}
