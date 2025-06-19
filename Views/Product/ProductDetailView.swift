import SwiftUI
import FirebaseFirestore

struct ProductDetailView: View {
    @State var product: Product
    @ObservedObject var productRepo: ProductRepository
    let currentUserId: String

    @Environment(\.presentationMode) var presentationMode
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var newQuantity: Int = 1

    // Seller podaci
    @State private var seller: User?
    @State private var isLoadingSeller = true

    var isSeller: Bool {
        product.sellerId == currentUserId
    }
    
    func formattedPrice(_ value: Double, currency: String = "EUR") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }


    var body: some View {
        ScrollView {
            if isLoadingSeller {
                ProgressView("Učitavam podatke o prodavaču...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let seller = seller {
                VStack(alignment: .leading, spacing: 16) {
                    // Slike proizvoda
                    if !product.images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(product.images, id: \.self) { imageUrl in
                                    AsyncImage(url: URL(string: imageUrl)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }

                    // Osnovne informacije
                    Text(product.name)
                        .font(.title)
                        .bold()
                    Text(product.description)
                        .font(.body)
                    HStack {
                        Text("\(formattedPrice(product.price)) / \(product.unit.rawValue)")
                        Spacer()
                        Text("Kvaliteta: \(product.quality.displayName)")
                    }
                    .font(.subheadline)

                    // Količina
                    if isSeller {
                        HStack {
                            Text("Količina:")
                            Stepper(value: $newQuantity, in: 0...100) {
                                Text("\(newQuantity)")
                            }
                            Button("Spremi") {
                                updateQuantity()
                            }
                            .disabled(newQuantity == product.quantity)
                        }
                    } else {
                        Text("Količina: \(product.quantity)")
                    }

                    // Kontakt prodavača
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Kontakt prodavača")
                            .font(.headline)
                        Text("Ime: \(seller.name)")
                        if let phone = seller.phoneNumber, !phone.isEmpty {
                            Text("Telefon: \(phone)")
                        }
                        if !seller.email.isEmpty {
                            Text("Email: \(seller.email)")
                        }
                    }
                    .padding(.top, 8)

                    // Akcije za prodavača
                    if isSeller {
                        Button("Obriši oglas", role: .destructive) {
                            showDeleteAlert = true
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            } else {
                Text("Nije moguće dohvatiti podatke o prodavaču.")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Detalji proizvoda")
        .sheet(isPresented: $showEditSheet) {
            // Ovdje implementiraj EditProductView po potrebi
            // EditProductView(product: $product, productRepo: productRepo)
            Text("EditProductView nije implementiran")
        }
        .alert("Jeste li sigurni da želite obrisati oglas?", isPresented: $showDeleteAlert) {
            Button("Obriši", role: .destructive) {
                Task {
                    await deleteProduct()
                }
            }
            Button("Odustani", role: .cancel) { }
        }
        .onAppear {
            newQuantity = product.quantity
            fetchSeller()
        }
    }

    private func updateQuantity() {
        Task {
            var updatedProduct = product
            updatedProduct.quantity = newQuantity
            try? await productRepo.updateProduct(updatedProduct)
            product = updatedProduct
        }
    }

    private func deleteProduct() async {
        try? await productRepo.deleteProduct(product)
        presentationMode.wrappedValue.dismiss()
    }

    // Dohvat prodavača iz Firestore-a prema sellerId
    private func fetchSeller() {
        let db = Firestore.firestore()
        db.collection("users").document(product.sellerId).getDocument { snapshot, error in
            defer { self.isLoadingSeller = false }
            guard let data = snapshot?.data() else {
                self.seller = nil
                return
            }
            // Prilagodi prema svom modelu User
            self.seller = User(
                id: data["id"] as? String ?? product.sellerId,
                profileCompleted: data["profileCompleted"] as? Bool ?? false,
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                role: UserRole(rawValue: data["role"] as? String ?? "buyer") ?? .buyer,
                avatar: data["avatar"] as? String ?? "person.circle.fill",
                location: data["location"] as? String ?? "",
                phoneNumber: data["phoneNumber"] as? String ?? "",
                joinDate: (data["joinDate"] as? Timestamp)?.dateValue() ?? Date(),
                rating: data["rating"] as? Double ?? 0.0,
                totalSales: data["totalSales"] as? Int ?? 0,
                isVerified: data["isVerified"] as? Bool ?? false
            )
        }
    }
}

