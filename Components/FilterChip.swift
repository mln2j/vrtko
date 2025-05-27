import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.primaryGreen : Color.lightGray)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterChipGroup: View {
    let filters: [String]
    @Binding var selectedFilter: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    FilterChip(
                        title: filter,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            FilterChip(title: "All", isSelected: true) {}
            FilterChip(title: "Vegetables", isSelected: false) {}
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
