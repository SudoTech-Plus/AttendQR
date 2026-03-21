import SwiftUI

/// Animated list item with fade and slide animation
struct AnimatedListItem<Content: View>: View {
    let child: Content
    let index: Int
    let delay: Double
    let duration: Double
    
    @State private var isVisible = false
    
    init(
        index: Int,
        delay: Double = 0.1,
        duration: Double = 0.6,
        @ViewBuilder child: () -> Content
    ) {
        self.index = index
        self.delay = delay
        self.duration = duration
        self.child = child()
    }
    
    var body: some View {
        child
            .opacity(isVisible ? 1.0 : 0.0)
            .offset(y: isVisible ? 0 : 30) // Slide up from 30 points
            .onAppear {
                let staggerDelay = delay * Double(index)
                withAnimation(.easeOut(duration: duration).delay(staggerDelay)) {
                    isVisible = true
                }
            }
    }
}

// MARK: - Preview
struct AnimatedListItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<10) { index in
                    AnimatedListItem(index: index) {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.blue)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Item \(index + 1)")
                                    .font(.headline)
                                Text("This is a staggered animated list item.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
