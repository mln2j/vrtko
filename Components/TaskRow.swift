import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    let onToggle: (TaskItem) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Task type icon
            ZStack {
                Circle()
                    .fill(task.taskType.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text(task.taskType.icon)
                    .font(.system(size: 18))
            }
            
            // Task content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(task.isCompleted ? Color("vrtkoSecondaryText") : Color("vrtkoPrimaryText"))
                        .strikethrough(task.isCompleted)
                    
                    Spacer()
                    
                    // Priority indicator
                    if task.priority == .high || task.priority == .urgent {
                        Circle()
                            .fill(task.priority.color)
                            .frame(width: 8, height: 8)
                    }
                }
                
                if let description = task.description {
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(Color("vrtkoSecondaryText"))
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    Label(task.dueDateText, systemImage: "clock")
                        .font(.system(size: 11))
                        .foregroundColor(task.isOverdue ? Color("vrtkoError") : Color("vrtkoSecondaryText"))
                    
                    Label(task.durationText, systemImage: "timer")
                        .font(.system(size: 11))
                        .foregroundColor(Color("vrtkoSecondaryText"))
                }
                .labelStyle(.iconOnly)
            }
            
            // Completion checkbox
            Button(action: {
                var updatedTask = task
                updatedTask.isCompleted.toggle()
                updatedTask.completedDate = updatedTask.isCompleted ? Date() : nil
                onToggle(updatedTask)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? Color("vrtkoSuccess") : Color("vrtkoSecondaryText"))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(Color("vrtkoCardBackground"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .opacity(task.isCompleted ? 0.7 : 1.0)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            // Ovdje koristiš value, ne binding
            TaskRow(task: TaskItem(
                id: "1",
                userId: "user1",
                title: "Zaliti rajčice",
                description: "Zaliti sve rajčice u vrtu",
                taskType: .watering,
                priority: .medium,
                dueDate: Date(),
                estimatedDuration: 15,
                isCompleted: false,
                completedDate: nil,
                relatedPlant: nil,
                relatedGarden: nil,
                createdAt: Date(),
                reminder: nil
            )) { _ in }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

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
