import SwiftUI

extension AnyTransition {
    /// Replicates the Flutter PageTransition with fade and slide from right
    static var pageTransition: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: PageTransitionModifier(opacity: 0, offsetX: 20),
                identity: PageTransitionModifier(opacity: 1, offsetX: 0)
            ),
            removal: .modifier(
                active: PageTransitionModifier(opacity: 0, offsetX: -20),
                identity: PageTransitionModifier(opacity: 1, offsetX: 0)
            )
        )
    }
}

struct PageTransitionModifier: ViewModifier {
    let opacity: Double
    let offsetX: CGFloat
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .offset(x: offsetX)
    }
}

/// A custom view modifier for standard page-level layout, similar to Flutter's Scaffold
struct PageContainer<Content: View>: View {
    let content: Content
    let title: String?
    let showBackButton: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    init(title: String? = nil, showBackButton: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.showBackButton = showBackButton
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            if title != nil || showBackButton {
                HStack {
                    if showBackButton {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    if let title = title {
                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 60) // Safe area top
                .padding(.bottom, 16)
                .background(AppColors.background)
            }
            
            // Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.surface)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - Animation Wrapper
extension Animation {
    /// Standard page transition animation (300ms easeOutCubic equivalent)
    static var pageAnimation: Animation {
        .timingCurve(0.215, 0.61, 0.355, 1, duration: 0.3)
    }
}

// MARK: - Preview
struct PageTransition_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var currentPage = 1
        
        var body: some View {
            VStack {
                HStack {
                    Button("Page 1") { withAnimation(.pageAnimation) { currentPage = 1 } }
                    Button("Page 2") { withAnimation(.pageAnimation) { currentPage = 2 } }
                }
                .padding()
                
                ZStack {
                    if currentPage == 1 {
                        VStack {
                            Text("Page One")
                                .font(.largeTitle)
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 100, height: 100)
                        }
                        .transition(.pageTransition)
                    } else {
                        VStack {
                            Text("Page Two")
                                .font(.largeTitle)
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.green)
                                .frame(width: 100, height: 100)
                        }
                        .transition(.pageTransition)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background)
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
