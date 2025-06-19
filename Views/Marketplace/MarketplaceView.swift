import SwiftUI

struct MarketplaceView: View {
    @StateObject private var productRepo = ProductRepository()
    @ObservedObject var plantRepo: PlantRepository
    @ObservedObject var gardenRepo: GardenRepository
    @EnvironmentObject var authService: AuthService

    @State private var searchText = ""
    @State private var showingAddProduct = false
    @State private var selectedProduct: Product?

    var filteredProducts: [Product] {
        let products = productRepo.products
        if searchText.isEmpty { return products }
        return products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            ($0.description ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Simple search bar
                    TextField("Pretraži proizvode...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding([.horizontal, .top])

                    ScrollView {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible()), count: 2),
                            spacing: 12
                        ) {
                            ForEach(filteredProducts) { product in
                                Button {
                                    selectedProduct = product
                                } label: {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }

                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddProduct = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color("vrtkoPrimary"))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Local Market")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                productRepo.fetchProducts()
                plantRepo.fetchPlantsForUser(userId: authService.user?.id ?? "")
            }
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(
                    product: product,
                    productRepo: productRepo,
                    currentUserId: authService.user?.id ?? ""
                )
            }
            .sheet(isPresented: $showingAddProduct) {
                AddProductView(
                    plantRepo: plantRepo,
                    productRepo: productRepo,
                    gardenRepo: gardenRepo,
                    userId: authService.user?.id ?? "",
                    onComplete: { showingAddProduct = false }
                )
            }
        }
    }
}
