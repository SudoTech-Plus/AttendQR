import SwiftUI

/// Wrapper view to add animations to dialogs or any overlay content
struct AnimatedDialogWrapper<Content: View>: View {
    let content: Content
    let duration: Double
    let curve: Animation
    
    @State private var animate = false
    
    init(
        duration: Double = 0.3,
        curve: Animation = .interpolatingSpring(stiffness: 300, damping: 20),
        @ViewBuilder child: () -> Content
    ) {
        self.duration = duration
        self.curve = curve
        self.content = child()
    }
    
    var body: some View {
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

// MARK: - Preview
struct AnimatedDialogWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            
            AnimatedDialogWrapper {
                VStack(spacing: 20) {
                    Text("Animated Wrapper")
                        .font(.headline)
                    
                    Text("This content is wrapped in AnimatedDialogWrapper for scale and fade effects.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                    
                    Button("Dismiss") {
                        // Action to close
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(AppColors.surface)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(40)
            }
        }
    }
}
