import Foundation

extension Date {
    // Format za prikaz datuma
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.locale = Locale(identifier: "hr_HR")
        return formatter.string(from: self)
    }
    
    // Format za prikaz vremena
    func timeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "hr_HR")
        return formatter.string(from: self)
    }
    
    // Relativni prikaz datuma (prije 2 dana, sutra, itd.)
    func relativeFormatted() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "hr_HR")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    // Provjeri je li datum danas
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    // Provjeri je li datum sutra
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    // Provjeri je li datum jučer
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    // Dodaj dane
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    // Dodaj mjesece
    func addingMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    // Početak dana
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    // Kraj dana
    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
    
    // Broj dana između datuma
    func daysBetween(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self.startOfDay, to: date.startOfDay).day ?? 0
    }
    
    // Sezona
    var season: Season {
        let month = Calendar.current.component(.month, from: self)
        switch month {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .autumn
        default: return .winter
        }
    }
}

enum Season: String, CaseIterable {
    case spring = "spring"
    case summer = "summer"
    case autumn = "autumn"
    case winter = "winter"
    
    var displayName: String {
        switch self {
        case .spring: return "Proljeće"
        case .summer: return "Ljeto"
        case .autumn: return "Jesen"
        case .winter: return "Zima"
        }
    }
    
    var icon: String {
        switch self {
        case .spring: return "🌸"
        case .summer: return "☀️"
        case .autumn: return "🍂"
        case .winter: return "❄️"
        }
    }
}
