//
//  ProductRepository.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 31.05.2025..
//


import Foundationimport FirebaseFirestoreclass ProductRepository: ObservableObject {    @Published var products: [Product] = []    private var listener: ListenerRegistration?        func fetchProducts(isActiveOnly: Bool = true) {        listener?.remove()        var query: Query = Firestore.firestore().collection("products")        if isActiveOnly {            query = query.whereField("isActive", isEqualTo: true)        }        listener = query.addSnapshotListener { snapshot, error in            guard let documents = snapshot?.documents else { return }            self.products = documents.compactMap { try? $0.data(as: Product.self) }        }    }        func addProduct(_ product: Product) async throws {        try Firestore.firestore().collection("products").addDocument(from: product)    }        func updateProduct(_ product: Product) async throws {        guard let id = product.id else { return }        try Firestore.firestore().collection("products").document(id).setData(from: product)    }        func deleteProduct(_ product: Product) async throws {        guard let id = product.id else { return }        try await Firestore.firestore().collection("products").document(id).delete()    }        deinit {        listener?.remove()    }}