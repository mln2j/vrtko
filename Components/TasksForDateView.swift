import SwiftUI

struct TasksForDateView: View {
    let selectedDate: Date
    @ObservedObject var taskRepo: TaskRepository
    @EnvironmentObject var authService: AuthService
    @State private var showingAddTask = false

    var body: some View {
        Group {
            if taskRepo.tasks.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(Color("vrtkoSecondaryText"))
                    Text("No tasks for this day")
                        .font(.system(size: 16))
                        .foregroundColor(Color("vrtkoSecondaryText"))
                    Button("Add Task") {
                        showingAddTask.toggle()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("vrtkoPrimary"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(taskRepo.tasks) { task in
                            TaskRow(task: task) { updatedTask in
                                Task {
                                    try? await taskRepo.updateTask(updatedTask)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            if let userId = authService.user?.id {
                taskRepo.fetchTasks(for: userId, date: selectedDate)
            }
        }
        .onChange(of: selectedDate) { newDate in
            if let userId = authService.user?.id {
                taskRepo.fetchTasks(for: userId, date: newDate)
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
    }
}
