import SwiftUI
import LucideIcons

 struct NavItemView: View {
    let icon: PlatformImage
    let label: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // Rendering Icon via PlatformImage helper
                Image(platformImage: icon)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? AppColors.accent : .gray)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? AppColors.accent.opacity(colorScheme == .dark ? 0.2 : 0.15) : Color.clear)
                    )
                
                // Label using CustomText (our component)
                CustomText(
                    title: label,
                    fontSize: 10,
                    fontColor: isSelected ? AppColors.accent : .gray,
                    weight: isSelected ? .semibold : .medium
                )
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
