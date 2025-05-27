import SwiftUI

struct ProductCard: View {
    let product: Product
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image section
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.lightGray)
                    .frame(height: 120)
                    .overlay(
                        Text(product.primaryImage)
                            .font(.system(size: 40))
                    )
                
                // Favorite button
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 28, height: 28)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(8)
                
                // Quality badge
                if product.isOrganic {
                    VStack {
                        Spacer()
                        HStack {
                            Text("BIO")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.leafGreen)
                                .cornerRadius(4)
                            Spacer()
                        }
                        .padding(8)
                    }
                }
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(product.localizedPriceText)  // ← Koristite novi localized formatter
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
                
                // Availability status
                if product.availability != .available {
                    Text(product.availability.displayName)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(product.availability.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(product.availability.color.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 160, height: 200)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.bottom, 8)
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        ProductCard(product: MockData.sampleProduct)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
