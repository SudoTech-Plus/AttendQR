//
//  NavItem.swift
//  Wenlance_Swift
//
//  Created by Frouen on 2/8/26.
//
import SwiftUI
import LucideIcons

 struct NavItemView: View {
    let icon: UIImage
    let label: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // Rendering Lucide Icon from UIImage with template rendering for tinting
                Image(uiImage: icon)
                    .renderingMode(.template) // Allows foregroundColor to work
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? (colorScheme == .dark ? AppColors.accent: AppColors.accent) : .gray)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? (colorScheme == .dark ? AppColors.accent.opacity(0.2) : AppColors.accent.opacity(0.15)) : Color.clear)
                    )
                
                // Label using CustomText (our component)
                CustomText(
                    title: label,
                    fontSize: 10,
                    fontColor: isSelected ? (colorScheme == .dark ? AppColors.accent: AppColors.accent) : .gray,
                    weight: isSelected ? .semibold : .medium
                )
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
