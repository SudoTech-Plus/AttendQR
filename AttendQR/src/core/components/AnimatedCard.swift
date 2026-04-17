import SwiftUI

/// Animated card with scale and elevation animations on tap
struct AnimatedCard<Content: View>: View {
    let content: Content
    let margin: EdgeInsets?
    let color: Color?
    let borderRadius: CGFloat?
    let onTap: (() -> Void)?
    let scaleOnTap: CGFloat
    
    init(
        margin: EdgeInsets? = nil,
        color: Color? = nil,
        borderRadius: CGFloat? = 12,
        onTap: (() -> Void)? = nil,
        scaleOnTap: CGFloat = 0.98,
        @ViewBuilder child: () -> Content
    ) {
        self.content = child()
        self.margin = margin
        self.color = color
        self.borderRadius = borderRadius
        self.onTap = onTap
        self.scaleOnTap = scaleOnTap
    }
    
    var body: some View {
        Button(action: {
            // Action is handled by the ButtonStyle or manual trigger
            onTap?()
        }) {
            content
                .padding(margin ?? EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(color ?? AppColors.surface)
                .cornerRadius(borderRadius ?? 12)
        }
        .buttonStyle(AnimatedCardButtonStyle(scaleOnTap: scaleOnTap))
    }
}

struct AnimatedCardButtonStyle: ButtonStyle {
    let scaleOnTap: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleOnTap : 1.0)
            .shadow(
                color: Color.black.opacity(configuration.isPressed ? 0.1 : 0.05),
                radius: configuration.isPressed ? 4 : 8,
                x: 0,
                y: configuration.isPressed ? 2 : 4
            )
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
#Preview {
    VStack(spacing: 20) {
        AnimatedCard(onTap: { print("Tapped!") }) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Animated Card")
                    .font(.headline)
                Text("Tap me to see the scale and shadow animation.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        
        AnimatedCard(color: .blue, borderRadius: 20, scaleOnTap: 0.9) {
            Text("Custom Styled Card")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.background)
}
