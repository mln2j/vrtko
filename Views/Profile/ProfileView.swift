import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showingSettings = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            if let user = authService.user {
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile header
                        profileHeader(user: user)
                        
                        // Stats cards
                        statsSection(user: user)
                        
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
                        .environmentObject(authService)
                }
                .alert("Sign Out", isPresented: $showingLogoutAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Sign Out", role: .destructive) {
                        signOut()
                    }
                } message: {
                    Text("Are you sure you want to sign out?")
                }
            } else {
                // Loading state
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading profile...")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundGray)
            }
        }
    }
    
    private func profileHeader(user: User) -> some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.primaryGreen.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                if user.avatar.hasPrefix("http") {
                    // For future: AsyncImage for profile photos from Google/Firebase
                    AsyncImage(url: URL(string: user.avatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.primaryGreen)
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                } else {
                    Image(systemName: user.avatar)
                        .font(.system(size: 50))
                        .foregroundColor(.primaryGreen)
                }
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
                
                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .padding(.top, 2)
                
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
    
    private func statsSection(user: User) -> some View {
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
                value: "", // TODO: Replace with real data
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
                // TODO: Handle edit profile
            }
            
            ProfileMenuItem(
                icon: "leaf.fill",
                title: "My Garden",
                subtitle: "Manage your plants and garden"
            ) {
                // TODO: Handle my garden
            }
            
            ProfileMenuItem(
                icon: "bag.fill",
                title: "My Products",
                subtitle: "View your listed products"
            ) {
                // TODO: Handle my products
            }
            
            ProfileMenuItem(
                icon: "clock.fill",
                title: "Order History",
                subtitle: "See your past purchases"
            ) {
                // TODO: Handle order history
            }
            
            ProfileMenuItem(
                icon: "heart.fill",
                title: "Favorites",
                subtitle: "Your saved products and gardens"
            ) {
                // TODO: Handle favorites
            }
            
            ProfileMenuItem(
                icon: "questionmark.circle.fill",
                title: "Help & Support",
                subtitle: "Get help and contact support"
            ) {
                // TODO: Handle help
            }
            
            // Sign Out button
            ProfileMenuItem(
                icon: "rectangle.portrait.and.arrow.right",
                title: "Sign Out",
                subtitle: "Sign out of your account",
                textColor: .error
            ) {
                showingLogoutAlert = true
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func signOut() {
        do {
            try authService.signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String
    var textColor: Color = .textPrimary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(textColor == .textPrimary ? .primaryGreen : textColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(textColor)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                if textColor == .textPrimary {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.title2)
                
                // User info section
                if let user = authService.user {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Account Information")
                            .font(.headline)
                        
                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                        Text("Location: \(user.location)")
                        Text("Verified: \(user.isVerified ? "Yes" : "No")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.lightGray)
                    .cornerRadius(8)
                }
                
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
            .environmentObject(AuthService())
    }
}
