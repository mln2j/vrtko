import SwiftUI

extension View {
    // Uvjetno prikazivanje view-a
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // Card stil
    func cardStyle(padding: CGFloat = 16, cornerRadius: CGFloat = 12) -> some View {
        self
            .padding(padding)
            .background(Color.cardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // Primary button stil
    func primaryButtonStyle() -> some View {
        self
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.primaryGreen)
            .cornerRadius(12)
    }
    
    // Secondary button stil
    func secondaryButtonStyle() -> some View {
        self
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.primaryGreen)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primaryGreen, lineWidth: 1)
            )
    }
    
    // Text field stil
    func textFieldStyle() -> some View {
        self
            .padding(12)
            .background(Color.lightGray)
            .cornerRadius(8)
    }
    
    // Navigation bar stil
    func customNavigationBar(title: String, backgroundColor: Color = .clear) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
    }
    
    // Shimmer efekat za loading
    func shimmer() -> some View {
        self
            .redacted(reason: .placeholder)
            .shimmering()
    }
    
    // Loading overlay
    func loading(_ isLoading: Bool) -> some View {
        self
            .overlay(
                Group {
                    if isLoading {
                        Color.black.opacity(0.3)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                            )
                    }
                }
            )
    }
}

// MARK: - Shimmer modifier
struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.white.opacity(0.6),
                        Color.clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(45))
                .offset(x: phase)
                .clipped()
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(Shimmer())
    }
}
