import Foundation

struct TaskItem: Identifiable, Codable {
    var id: String? // Firestore document ID
    let userId: String          // ID korisnika kojem pripada zadatak
    let title: String
    let description: String?
    let taskType: TaskType
    let priority: TaskPriority
    let dueDate: Date
    let estimatedDuration: Int  // u minutama
    var isCompleted: Bool
    var completedDate: Date?
    let relatedPlant: String?   // plantId (opcionalno)
    let relatedGarden: String?  // gardenId (opcionalno)
    let createdAt: Date
    let reminder: TaskReminder?
}

// MARK: - TaskReminder

struct TaskReminder: Codable {
    let isEnabled: Bool
    let minutesBefore: Int
    let reminderDate: Date
}

