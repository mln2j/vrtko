import Foundation
import SwiftUI

struct TaskItem: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String?
    let taskType: TaskType
    let priority: TaskPriority
    let dueDate: Date
    let estimatedDuration: Int // u minutama
    var isCompleted: Bool  // ← Promijenite iz 'let' u 'var'
    var completedDate: Date?  // ← Promijenite iz 'let' u 'var'
    let relatedPlant: UUID?
    let relatedGarden: UUID?
    let createdAt: Date
    let reminder: TaskReminder?
    
    init(title: String, description: String? = nil, taskType: TaskType, priority: TaskPriority = .medium, dueDate: Date, estimatedDuration: Int = 30, isCompleted: Bool = false, completedDate: Date? = nil, relatedPlant: UUID? = nil, relatedGarden: UUID? = nil, createdAt: Date = Date(), reminder: TaskReminder? = nil) {
        self.title = title
        self.description = description
        self.taskType = taskType
        self.priority = priority
        self.dueDate = dueDate
        self.estimatedDuration = estimatedDuration
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.relatedPlant = relatedPlant
        self.relatedGarden = relatedGarden
        self.createdAt = createdAt
        self.reminder = reminder
    }
}

enum TaskType: String, CaseIterable, Codable {
    case watering = "watering"
    case planting = "planting"
    case harvesting = "harvesting"
    case fertilizing = "fertilizing"
    case pruning = "pruning"
    case weeding = "weeding"
    case pestControl = "pestControl"
    case soilPrep = "soilPrep"
    case monitoring = "monitoring"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .watering: return "Zalijevanje"
        case .planting: return "Sadnja"
        case .harvesting: return "Berba"
        case .fertilizing: return "Gnojidba"
        case .pruning: return "Obrezivanje"
        case .weeding: return "Uklanjanje korova"
        case .pestControl: return "Zaštita od štetnika"
        case .soilPrep: return "Priprema tla"
        case .monitoring: return "Praćenje"
        case .other: return "Ostalo"
        }
    }
    
    var icon: String {
        switch self {
        case .watering: return "💧"
        case .planting: return "🌱"
        case .harvesting: return "🧺"
        case .fertilizing: return "🌾"
        case .pruning: return "✂️"
        case .weeding: return "🪴"
        case .pestControl: return "🛡️"
        case .soilPrep: return "🔨"
        case .monitoring: return "👀"
        case .other: return "📝"
        }
    }
    
    var color: Color {
        switch self {
        case .watering: return .blue
        case .planting: return .green
        case .harvesting: return .orange
        case .fertilizing: return .brown
        case .pruning: return .purple
        case .weeding: return .yellow
        case .pestControl: return .red
        case .soilPrep: return .gray
        case .monitoring: return .cyan
        case .other: return .black
        }
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case urgent = "urgent"
    
    var displayName: String {
        switch self {
        case .low: return "Nizak"
        case .medium: return "Srednji"
        case .high: return "Visok"
        case .urgent: return "Hitno"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .urgent: return 4
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
}

struct TaskReminder: Codable {
    let isEnabled: Bool
    let minutesBefore: Int
    let reminderDate: Date
    
    static let presets = [
        TaskReminder(isEnabled: true, minutesBefore: 15, reminderDate: Date()),
        TaskReminder(isEnabled: true, minutesBefore: 30, reminderDate: Date()),
        TaskReminder(isEnabled: true, minutesBefore: 60, reminderDate: Date()),
        TaskReminder(isEnabled: true, minutesBefore: 1440, reminderDate: Date()) // 1 dan
    ]
}

// Extension za dodatne funkcionalnosti
extension TaskItem {
    var isOverdue: Bool {
        !isCompleted && Date() > dueDate
    }
    
    var isDueToday: Bool {
        Calendar.current.isDateInToday(dueDate)
    }
    
    var isDueSoon: Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return dueDate <= tomorrow && !isCompleted
    }
    
    var durationText: String {
        if estimatedDuration < 60 {
            return "\(estimatedDuration) min"
        } else {
            let hours = estimatedDuration / 60
            let minutes = estimatedDuration % 60
            return minutes > 0 ? "\(hours)h \(minutes)min" : "\(hours)h"
        }
    }
    
    var dueDateText: String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(dueDate) {
            formatter.timeStyle = .short
            return "Danas u \(formatter.string(from: dueDate))"
        } else if Calendar.current.isDateInTomorrow(dueDate) {
            formatter.timeStyle = .short
            return "Sutra u \(formatter.string(from: dueDate))"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: dueDate)
        }
    }
}
