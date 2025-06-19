import SwiftUI

struct TasksSectionView: View {
    let tasks: [TaskItem]
    var body: some View {
        if tasks.isEmpty {
            Text("Nema zadataka za prikaz.")
                .foregroundColor(.secondary)
                .padding()
        } else {
            ForEach(tasks) { task in
                TaskRow(task: task) { updatedTask in
                    Task {
                        try? await TaskRepository().updateTask(updatedTask)
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    print("Drawing task: \(task.title), id: \(task.id ?? "nil"), due: \(task.dueDate)")
                }
            }
        }
    }
}
