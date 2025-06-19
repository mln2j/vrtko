import SwiftUI

struct GardenCard: View {
    let garden: Garden

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("vrtkoLightGray"))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "laurel.leading")
                        .font(.system(size: 28))
                        .foregroundColor(Color("vrtkoSecondary").opacity(0.85))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(garden.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("vrtkoPrimaryText"))

                Text(garden.location.city ?? "")
                    .font(.system(size: 12))
                    .foregroundColor(Color("vrtkoSecondaryText"))

                Text("\(garden.plantCount) plants")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("vrtkoSecondaryText"))
            }

            Spacer()
        }
        .padding(12)
        .background(Color("vrtkoGrayBackground"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
        .padding(.bottom, 4)
    }
}


struct GardenCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
