import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @ObservedObject var plantRepo: PlantRepository
    @ObservedObject var productRepo: ProductRepository
    @ObservedObject var gardenRepo: GardenRepository
    @Binding var selectedTab: Int
    @State private var showingLogoutAlert = false
    @State private var showingEditProfile = false

    var body: some View {
        NavigationView {
            if let user = authService.user {
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader(user: user)
                        statsSection(user: user)
                        menuSection
                    }
                    .padding()
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.large)
                .alert("Sign Out", isPresented: $showingLogoutAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Sign Out", role: .destructive) {
                        signOut()
                    }
                } message: {
                    Text("Are you sure you want to sign out?")
                }
                .sheet(isPresented: $showingEditProfile) {
                    EditProfileView(authService: authService)
                }
            } else {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading profile...")
                        .font(.system(size: 16))
                        .foregroundColor(Color("vrtkoSecondaryText"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("vrtkoGrayBackground"))
            }
        }
        .onAppear {
            if let userId = authService.user?.id {
                gardenRepo.fetchGardens(for: userId)
                productRepo.fetchProducts(for: userId)
            }
        }
    }
    
    private func profileHeader(user: User) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color("vrtkoPrimary").opacity(0.2))
                    .frame(width: 100, height: 100)
                if user.avatar.hasPrefix("http") {
                    AsyncImage(url: URL(string: user.avatar)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color("vrtkoPrimary"))
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                } else {
                    Image(systemName: user.avatar)
                        .font(.system(size: 50))
                        .foregroundColor(Color("vrtkoPrimary"))
                }
            }
            VStack(spacing: 4) {
                Text(user.name)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color("vrtkoPrimaryText"))
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color("vrtkoSecondaryText"))
                    Text(user.location)
                        .font(.system(size: 16))
                        .foregroundColor(Color("vrtkoSecondaryText"))
                }
                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(Color("vrtkoSecondaryText"))
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
                    .foregroundColor(Color("vrtkoSecondaryText"))
                    .padding(.top, 4)
            }
        }
    }
    
    private func statsSection(user: User) -> some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Sales",
                value: "\(user.totalSales)",
                icon: "eurosign.circle.fill",
                color: Color("vrtkoAccent")
            )
            Button(action: {
                selectedTab = 2 // Market tab
            }) {
                StatCard(
                    title: "Products",
                    value: "\(productRepo.products.count)",
                    icon: "cube.box.fill",
                    color: Color("vrtkoSecondary")
                )
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                selectedTab = 3 // Gardens tab
            }) {
                StatCard(
                    title: "Gardens",
                    value: "\(gardenRepo.gardens.count)",
                    icon: "tree.fill",
                    color: Color("vrtkoPrimary")
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var menuSection: some View {
        VStack(spacing: 0) {
            ProfileMenuItem(
                icon: "person.crop.circle.fill",
                title: "Edit Profile",
                subtitle: "Update your personal information"
            ) {
                showingEditProfile = true
            }
            ProfileMenuItem(
                icon: "rectangle.portrait.and.arrow.right",
                title: "Sign Out",
                subtitle: "Sign out of your account",
                textColor: Color("vrtkoError")
            ) {
                showingLogoutAlert = true
            }
        }
        .background(Color("vrtkoCardBackground"))
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
