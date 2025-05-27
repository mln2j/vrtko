import SwiftUI

struct PlannerView: View {
    @State private var selectedDate = Date()
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Calendar section
                calendarSection
                
                // Selected date tasks
                tasksSection
            }
            .navigationTitle("Garden Planner")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }
    
    private var calendarSection: some View {
        VStack(spacing: 16) {
            // Month navigation
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                }
            }
            .padding(.horizontal)
            
            // Calendar grid
            CalendarGrid(selectedDate: $selectedDate)
        }
        .padding(.vertical)
        .background(Color.cardBackground)
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedDate.isToday ? "Today's Tasks" : "Tasks for \(selectedDate.formatted(style: .medium))")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal)
                
                Spacer()
            }
            
            TasksForDateView(selectedDate: selectedDate)
        }
        .background(Color.backgroundGray)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "hr_HR")
        return formatter.string(from: selectedDate)
    }
    
    private func changeMonth(_ direction: Int) {
        selectedDate = Calendar.current.date(byAdding: .month, value: direction, to: selectedDate) ?? selectedDate
    }
}

struct CalendarGrid: View {
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    var body: some View {
        let days = generateDaysInMonth()
        
        VStack(spacing: 8) {
            // Weekday headers
            HStack {
                ForEach(weekdayHeaders, id: \.self) { weekday in
                    Text(weekday)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar days
            ForEach(0..<6, id: \.self) { week in
                HStack(spacing: 4) {
                    ForEach(0..<7, id: \.self) { day in
                        let index = week * 7 + day
                        if index < days.count {
                            CalendarDayView(
                                day: days[index],
                                isSelected: calendar.isDate(days[index], inSameDayAs: selectedDate),
                                isToday: calendar.isDateInToday(days[index]),
                                hasEvents: false // Mock data - you can implement actual event checking
                            ) {
                                selectedDate = days[index]
                            }
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 40)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var weekdayHeaders: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "hr_HR")
        return formatter.shortWeekdaySymbols
    }
    
    private func generateDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let daysToSubtract = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstOfMonth) else {
            return []
        }
        
        var days: [Date] = []
        var currentDate = startDate
        
        for _ in 0..<42 { // 6 weeks * 7 days
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
}

struct CalendarDayView: View {
    let day: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvents: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: day))")
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(textColor)
                
                if hasEvents {
                    Circle()
                        .fill(Color.primaryGreen)
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if isToday {
            return .primaryGreen
        } else {
            return .textPrimary
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .primaryGreen
        } else if isToday {
            return .primaryGreen.opacity(0.1)
        } else {
            return .clear
        }
    }
}

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add New Task")
                    .font(.title2)
                Spacer()
            }
            .padding()
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
