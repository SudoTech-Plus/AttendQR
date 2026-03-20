import SwiftUI

/// Animated dialog with scale and fade animation
struct AnimatedDialog<Content: View>: View {
    @Binding var isShowing: Bool
    let duration: Double
    let curve: Animation
    let content: Content
    
    @State private var animate = false
    
    init(
        isShowing: Binding<Bool>,
        duration: Double = 0.3,
        curve: Animation = .easeOut(duration: 0.3),
        @ViewBuilder content: () -> Content
    ) {
        self._isShowing = isShowing
        self.duration = duration
        self.curve = curve
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if isShowing {
                // Dimmed background
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismiss()
                    }
                
                content
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1.0 : 0.0)
                    .onAppear {
                        withAnimation(curve) {
                            animate = true
                        }
                    }
            }
        }
        .onChange(of: isShowing) { showing in
            if !showing {
                animate = false
            }
        }
    }
    
    private func dismiss() {
        withAnimation(curve) {
            animate = false
        }
        // Wait for animation to finish before disappearing from hierarchy
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isShowing = false
        }
    }
}

// MARK: - Preview
struct AnimatedDialog_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var showDialog = false
        
        var body: some View {
            ZStack {
                VStack(spacing: 20) {
                    Text("Main Background Content")
                        .font(.title)
                    
                    Button("Show Animated Dialog") {
                        showDialog = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                AnimatedDialog(isShowing: $showDialog) {
                    VStack(spacing: 16) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        
                        Text("Welcome!")
                            .font(.headline)
                        
                        Text("This is an animated dialog with scale and fade effects, just like in Flutter.")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button("Close") {
                            // Manual trigger to show dismissal animation
                            // In a real app, you might want a more refined dismiss logic
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 20)
                    .padding(.horizontal, 40)
                }
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
