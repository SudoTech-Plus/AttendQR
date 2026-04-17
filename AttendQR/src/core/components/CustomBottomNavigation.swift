import SwiftUI
import LucideIcons

struct CustomBottomNavigation: View {
    @Binding var currentIndex: Int
    @Environment(\.colorScheme) var colorScheme
    
    var navItems: [(icon: PlatformImage, label: String)] = [
        (Lucide.house, "Home"),
        (Lucide.qrCode, "Scan"),
        (Lucide.calendar, "Events"),
        (Lucide.user, "Profile")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Shadow top border effect
            Divider()
                .background(Color.black.opacity(0.05))
            
            HStack(spacing: 0) {
                ForEach(0..<navItems.count, id: \.self) { index in
                    NavItemView(
                        icon: navItems[index].icon,
                        label: navItems[index].label,
                        isSelected: currentIndex == index,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentIndex = index
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(AppColors.primary)
        }
        .background(
            AppColors.primary
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -2)
        )
    }
}


// Preview Mode
struct CustomBottomNavigation_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomBottomNavigation(currentIndex: .constant(0))
            Spacer()
        }
        .background(AppColors.primary)
    }
}
