import SwiftUI

struct PlannerView: View {
    @State private var selectedDate: Date? = nil
    @State private var showingDatePicker = false
    @StateObject private var taskRepo = TaskRepository()
    @EnvironmentObject var authService: AuthService

    var filteredTasks: [Date: [TaskItem]] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: taskRepo.tasks) { task in
            calendar.startOfDay(for: task.dueDate)
        }
        if let selected = selectedDate {
            let key = calendar.startOfDay(for: selected)
            return grouped.filter { $0.key == key }
        }
        return grouped
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Date picker button
                HStack {
                    Button(action: { showingDatePicker = true }) {
                        Image(systemName: "calendar")
                        Text(selectedDate == nil ? "Svi datumi" : selectedDate!.formatted(date: .abbreviated, time: .omitted))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()

                // Task list grouped by date
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if filteredTasks.isEmpty {
                            Text("Nema zadataka za prikaz.")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(filteredTasks.keys.sorted(), id: \.self) { date in
                                Section(
                                    header: Text(date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.headline)
                                        .padding(.top, 8)
                                        .padding(.leading, 16) // Dodaj ovo!
                                ) {
                                    ForEach(filteredTasks[date] ?? []) { task in
                                        TaskRow(task: task) { updatedTask in
                                            Task {
                                                try? await taskRepo.updateTask(updatedTask)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("Garden Planner")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingDatePicker) {
                VStack {
                    DatePicker(
                        "Odaberi datum",
                        selection: Binding(
                            get: { selectedDate ?? Date() },
                            set: { selectedDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    Button("Prikaži sve") {
                        selectedDate = nil
                        showingDatePicker = false
                    }
                    .padding(.top)
                    Button("Zatvori") {
                        showingDatePicker = false
                    }
                    .padding(.top)
                }
                .presentationDetents([.medium, .large])
            }
        }
        .onAppear {
            if let userId = authService.user?.id {
                taskRepo.fetchTasks(for: userId)
            }
        }

    }
}

