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
                .background(Color(UIColor.secondarySystemBackground))
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
