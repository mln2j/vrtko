import SwiftUI

struct TasksSectionView: View {
    let tasks: [TaskItem]
    let onToggle: (TaskItem) -> Void

    var body: some View {
        if tasks.isEmpty {
            Text("Nema zadataka za prikaz.")
                .foregroundColor(.secondary)
                .padding()
        } else {
            ForEach(tasks) { task in
                TaskRow(task: task) { updatedTask in
                    onToggle(updatedTask)
                }
                .padding(.horizontal)
                .onAppear {
                    print("Drawing task: \(task.title), id: \(task.id ?? "nil"), due: \(task.dueDate)")
                }
            }
        }
    }
}
