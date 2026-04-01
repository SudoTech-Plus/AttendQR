//
//  PercentageIndicator.swift
//  Wenlance_Swift
//
//  Created by Frouen on 2/4/26.
//

import SwiftUI
import LucideIcons
// MARK: - Percentage Indicator
struct PercentageIndicator: View {
    let percentage: Double
    
    var body: some View {
        let isIncrease = percentage > 0
        let isDecrease = percentage < 0
        let color = isIncrease ? AppColors.success : (isDecrease ? AppColors.error : AppColors.textSecondary)
        let icon = isIncrease ? Lucide.trendingUp : (isDecrease ? Lucide.trendingDown : Lucide.minus)
        
        HStack(spacing: 4) {
            Image(uiImage: icon)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundColor(color)
                
            Text("\(abs(percentage), specifier: "%.1f")%")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .cornerRadius(8)
    }
}
