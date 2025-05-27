//MarketplaceView.swift
import SwiftUI

struct MarketplaceView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showingFilters = false
    
    private let categories = ["All", "Vegetables", "Fruits", "Herbs", "Seeds"]
    
    var filteredProducts: [Product] {
        var products = MockData.products
        
        if !searchText.isEmpty {
            products = products.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedCategory != "All" {
            let category = ProductCategory.allCases.first {
                $0.displayName == selectedCategory
            }
            if let category = category {
                products = products.filter { $0.category == category }
            }
        }
        
        return products
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    SearchBar(
                        text: $searchText,
                        placeholder: "Search vegetables, fruits..."
                    )
                    
                    FilterChipGroup(
                        filters: categories,
                        selectedFilter: $selectedCategory
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .background(Color.cardBackground)
                
                HStack {
                    Text("📍 Within 5km • \(filteredProducts.count) results")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Button("Sort: Nearest") {
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.backgroundGray)
                
                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 2),
                        spacing: 12
                    ) {
                        ForEach(filteredProducts) { product in
                            ProductCard(product: product)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .background(Color.backgroundGray)
            }
            .navigationTitle("Local Market")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters.toggle() }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView()
            }
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.primaryGreen)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        )
    }
}

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Filter Options")
                    .font(.title2)
                Spacer()
            }
            .padding()
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceView()
    }
}
