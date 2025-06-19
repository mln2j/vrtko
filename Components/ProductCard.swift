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
                        .fill(Color("vrtkoLightGray"))
                        .frame(width: 160, height: 120)
                        .cornerRadius(12, corners: [.topLeft, .topRight])
                    
                    Text(product.icon)
                        .font(.system(size: 48))
                    
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
                
                // Content sekcija s povećanim paddingom
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("vrtkoPrimaryText"))
                        .lineLimit(2)
                        .frame(height: 34, alignment: .top)
                    
                    Text(product.priceText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color("vrtkoPrimary"))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 9))
                            .foregroundColor(Color("vrtkoSecondaryText"))
                        
                        Text(product.location.distanceText)
                            .font(.system(size: 11))
                            .foregroundColor(Color("vrtkoSecondaryText"))
                        
                        Spacer()
                        
                        if product.reviewCount > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(Color("vrtkoSunYellow"))
                                Text("\(product.rating, specifier: "%.1f")")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("vrtkoSecondaryText"))
                            }
                        }
                    }
                    .padding(.bottom, 4)  // ← Dodano: dodatni padding ispod lokacije/ratinga
                }
                .padding(.horizontal, 8)
                .padding(.top, 24)  // ← Povećano: s 16 na 24 za veći razmak od fotke
                .padding(.bottom, 16)  // ← Povećano: s 8 na 16 za veći razmak do kraja
                .frame(height: 90)  // ← Povećano: s 80 na 90 zbog većeg paddinga
            }
            .frame(width: 160, height: 210)  // ← Povećano: s 200 na 210 zbog većeg sadržaja
            .background(Color("vrtkoCardBackground"))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
            
            // BIO badge - overlay preko sve karte (pozicija prilagođena)
            if product.isOrganic {
                VStack {
                    Spacer()
                        .frame(height: 110)
                    HStack {
                        Text("BIO")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color("vrtkoLeafGreen"))
                            .cornerRadius(6)
                        Spacer()
                    }
                    .padding(.leading, 8)
                    Spacer()
                }
            }
        }
        .padding(.bottom, 12)
    }
}
