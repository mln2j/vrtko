import SwiftUI

struct ProfileView: View {
    let user = MockData.currentUser
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    profileHeader
                    
                    // Stats cards
                    statsSection
                    
                    // Menu options
                    menuSection
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.primaryGreen.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.primaryGreen)
            }
            
            // User info
            VStack(spacing: 4) {
                Text(user.name)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                    
                    Text(user.location)
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                }
                
                if user.isVerified {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        
                        Text("Verified Member")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 4)
                }
                
                Text(user.memberSince)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
                    .padding(.top, 4)
            }
        }
    }
    
    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Rating",
                value: String(format: "%.1f", user.rating),
                icon: "star.fill",
                color: .sunYellow
            )
            
            StatCard(
                title: "Sales",
                value: "\(user.totalSales)",
                icon: "bag.fill",
                color: .accentOrange
            )
            
            StatCard(
                title: "Plants",
                value: "\(MockData.gardenPlants.count)",
                icon: "leaf.fill",
                color: .leafGreen
            )
        }
    }
    
    private var menuSection: some View {
        VStack(spacing: 0) {
            ProfileMenuItem(
                icon: "person.crop.circle.fill",
                title: "Edit Profile",
                subtitle: "Update your personal information"
            ) {
                // Handle edit profile
            }
            
            ProfileMenuItem(
                icon: "leaf.fill",
                title: "My Garden",
                subtitle: "Manage your plants and garden"
            ) {
                // Handle my garden
            }
            
            ProfileMenuItem(
                icon: "bag.fill",
                title: "My Products",
                subtitle: "View your listed products"
            ) {
                // Handle my products
            }
            
            ProfileMenuItem(
                icon: "clock.fill",
                title: "Order History",
                subtitle: "See your past purchases"
            ) {
                // Handle order history
            }
            
            ProfileMenuItem(
                icon: "heart.fill",
                title: "Favorites",
                subtitle: "Your saved products and gardens"
            ) {
                // Handle favorites
            }
            
            ProfileMenuItem(
                icon: "questionmark.circle.fill",
                title: "Help & Support",
                subtitle: "Get help and contact support"
            ) {
                // Handle help
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryGreen)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.title2)
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
