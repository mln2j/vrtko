import SwiftUI

struct ProductCard: View {
    let product: Product
    @State private var isFavorite = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // Image section
                ZStack {
                    Rectangle()
                        .fill(Color.lightGray)
                        .frame(width: 160, height: 120)
                        .cornerRadius(12, corners: [.topLeft, .topRight])
                    
                    Text(product.primaryImage)
                        .font(.system(size: 40))
                    
                    // Favorite button
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: { isFavorite.toggle() }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? .red : .white)
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(width: 28, height: 28)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                            Spacer()
                        }
                    }
                }
                
                // Content sekcija s dodatnim padding-om
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                        .frame(height: 34, alignment: .top)
                    
                    Text(product.priceText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primaryGreen)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.textSecondary)
                        
                        Text(product.location.distanceText)
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        if product.reviewCount > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(.sunYellow)
                                Text("\(product.rating, specifier: "%.1f")")
                                    .font(.system(size: 10))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 16)  // ← Povećaj padding na vrh
                .padding(.bottom, 8)
                .frame(height: 80)
            }
            .frame(width: 160, height: 200)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
            
            // BIO badge - overlay preko sve karte
            if product.isOrganic {
                VStack {
                    Spacer()
                        .frame(height: 112)  // Pozicioniraj točno na granici
                    HStack {
                        Text("BIO")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.leafGreen)
                            .cornerRadius(6)
                        Spacer()
                    }
                    .padding(.leading, 8)
                    Spacer()
                }
            }
        }
        .padding(.bottom, 6)
    }
}
