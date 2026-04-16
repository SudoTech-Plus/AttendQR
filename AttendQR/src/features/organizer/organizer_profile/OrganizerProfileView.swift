import SwiftUI
import Combine

struct OrganizerProfileView: View {
    @StateObject private var viewModel = OrganizerProfileViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Profile Header
                    orgHeader
                    
                    // Settings Groups
                    VStack(spacing: 24) {
                        ForEach(0..<viewModel.settingsGroups.count, id: \.self) { groupIndex in
                            VStack(spacing: 0) {
                                ForEach(viewModel.settingsGroups[groupIndex]) { item in
                                    OrgSettingsRow(item: item)
                                    
                                    if item.id != viewModel.settingsGroups[groupIndex].last?.id {
                                        Divider()
                                            .background(Color.white.opacity(0.05))
                                            .padding(.leading, 56)
                                    }
                                }
                            }
                            .background(AppColors.cardDark)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Logout Button
                    Button(action: {
                        router.navigate(to: .login)
                    }) {
                        HStack {
                            Image(systemName: "power")
                                .font(.system(size: 18, weight: .bold))
                            Text("Log out Organizer")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
                .padding(.top, 40)
            }
        }
    }
    
    private var orgHeader: some View {
        VStack(spacing: 16) {
            // Org Logo with Blue Glow
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Circle()
                    .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "building.2.fill")
                    .resizable()
                    .padding(30)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.05))
                    .clipShape(Circle())
            }
            
            VStack(spacing: 4) {
                CustomText(
                    title: viewModel.orgName,
                    fontSize: 24,
                    fontColor: .white,
                    weight: .bold
                )
                
                CustomText(
                    title: "\(viewModel.plan) Account",
                    fontSize: 14,
                    fontColor: .blue,
                    weight: .medium
                )
            }
        }
    }
}

struct OrgSettingsRow: View {
    let item: OrgSettingsItem
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(item.color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: item.icon)
                        .foregroundColor(item.color)
                        .font(.system(size: 18))
                }
                
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                if let detail = item.detail {
                    Text(detail)
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textTertiary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    OrganizerProfileView()
        .environmentObject(ThemeManager())
        .environmentObject(Router())
}
