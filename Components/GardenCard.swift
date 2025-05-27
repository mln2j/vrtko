import SwiftUI

struct GardenCard: View {
    let plant: GardenPlant
    
    var body: some View {
        HStack(spacing: 12) {
            // Plant image with status overlay
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.lightGray)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(plant.plantType.icon)
                            .font(.system(size: 24))
                    )
                
                // Status indicator
                Circle()
                    .fill(plant.status.color)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Text(plant.status.icon)
                            .font(.system(size: 8))
                    )
                    .offset(x: 4, y: 4)
            }
            
            // Plant info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(plant.plantType.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    if plant.isReadyForHarvest {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.warning)
                            .font(.system(size: 14))
                    }
                }
                
                Text(plant.variety)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
                
                HStack(spacing: 8) {
                    Label(plant.status.displayName, systemImage: "circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(plant.status.color)
                        .labelStyle(.iconOnly)
                    
                    Text(plant.status.displayName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(plant.status.color)
                    
                    Spacer()
                    
                    Text("\(plant.age) dana")
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct GardenCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            GardenCard(plant: MockData.gardenPlants[0])
            GardenCard(plant: MockData.gardenPlants[1])
            GardenCard(plant: MockData.gardenPlants[2])
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
