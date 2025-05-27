import SwiftUI

struct TasksSectionView: View {
    @State private var tasks = MockData.todaysTasks.filter { !$0.isCompleted }
    
    var body: some View {
        ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
            TaskRow(task: $tasks[index]) { updatedTask in
                // Handle task completion - ovdje možete dodati logiku za spremanje
                print("Task \(updatedTask.title) updated")
            }
            .padding(.horizontal)
        }
    }
}
