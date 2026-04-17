import SwiftUI

/// Animated Floating Action Button with scale and rotation
struct AnimatedFAB<Content: View>: View {
    let onPressed: (() -> Void)?
    let child: Content
    let backgroundColor: Color?
    let scale: CGFloat
    
    init(
        onPressed: (() -> Void)? = nil,
        backgroundColor: Color? = nil,
        scale: CGFloat = 1.1,
        @ViewBuilder child: () -> Content
    ) {
        self.onPressed = onPressed
        self.backgroundColor = backgroundColor
        self.scale = scale
        self.child = child()
    }
    
    var body: some View {
        Button(action: {
            onPressed?()
        }) {
            child
                .padding(16)
                .background(backgroundColor ?? .blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, y: 2)
        }
        .buttonStyle(AnimatedFABButtonStyle(scale: scale))
    }
}

struct AnimatedFABButtonStyle: ButtonStyle {
    let scale: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .rotationEffect(.degrees(configuration.isPressed ? 180 : 0))
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct AnimatedFAB_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            AnimatedFAB(onPressed: { print("FAB Pressed") }) {
                Image(systemName: "plus")
                    .font(.title2.bold())
            }
            
            AnimatedFAB(backgroundColor: .red, scale: 1.25) {
                Image(systemName: "heart.fill")
                    .font(.title2)
            }
            
            AnimatedFAB(backgroundColor: .green) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}
