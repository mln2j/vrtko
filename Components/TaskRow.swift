import SwiftUI

struct TaskRow: View {
    @Binding var task: TaskItem  // ← Promijenite u @Binding
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
                        .foregroundColor(task.isCompleted ? .textSecondary : .textPrimary)
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
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    Label(task.dueDateText, systemImage: "clock")
                        .font(.system(size: 11))
                        .foregroundColor(task.isOverdue ? .error : .textSecondary)
                    
                    Label(task.durationText, systemImage: "timer")
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
                .labelStyle(.iconOnly)
            }
            
            // Completion checkbox
            Button(action: {
                task.isCompleted.toggle()
                if task.isCompleted {
                    task.completedDate = Date()
                } else {
                    task.completedDate = nil
                }
                onToggle(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .success : .textSecondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .opacity(task.isCompleted ? 0.7 : 1.0)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            TaskRow(task: .constant(MockData.todaysTasks[0])) { _ in }
            TaskRow(task: .constant(MockData.todaysTasks[1])) { _ in }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
