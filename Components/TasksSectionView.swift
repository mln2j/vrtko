import SwiftUI

struct TasksSectionView: View {
    @ObservedObject var taskRepo: TaskRepository

    var body: some View {
        ForEach(taskRepo.tasks) { task in
            TaskRow(task: task) { updatedTask in
                // Ažuriraj task u Firestore
                Task {
                    try? await taskRepo.updateTask(updatedTask)
                }
            }
            .padding(.horizontal)
        }
    }
}
