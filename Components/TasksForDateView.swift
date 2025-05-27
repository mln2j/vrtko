import SwiftUI

struct TasksForDateView: View {
    let selectedDate: Date
    @State private var tasks: [TaskItem] = []
    @State private var showingAddTask = false
    
    var body: some View {
        Group {  // ← Dodajte Group ili neki drugi container
            if tasks.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.textSecondary)
                    
                    Text("No tasks for this day")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                    
                    Button("Add Task") {
                        showingAddTask.toggle()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.primaryGreen)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                            TaskRow(task: .constant(tasks[index])) { updatedTask in
                                // Handle task update
                                tasks[index] = updatedTask
                                print("Task updated: \(updatedTask.title)")
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {  // ← Sada je .onAppear vezan uz Group
            loadTasks()
        }
        .onChange(of: selectedDate) { newDate in  // ← I .onChange je vezan uz Group
            loadTasks()
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
    }
    
    private func loadTasks() {
        tasks = MockData.tasksForDate(selectedDate)
    }
}
