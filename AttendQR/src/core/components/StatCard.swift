import SwiftUI

// MARK: - Stat Card Sub-view
struct StatCard: View {
    let title: String
    let value: String
    let percentageChange: Double?
    let icon: PlatformImage
    let iconColor: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(platformImage: icon)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(iconColor)
                }
                
                Spacer()
                
                if let percentage = percentageChange {
                    PercentageIndicator(percentage: percentage)
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardDark)
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 2)
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(iconColor.opacity(0.1), lineWidth: 1)
        )
    }
}
