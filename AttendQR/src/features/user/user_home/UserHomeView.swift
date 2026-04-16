import SwiftUI
import LucideIcons

struct UserHomeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = UserHomeViewModel()
    @State private var currentTab = 0
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // MARK: - Header
                        headerView
                        
                        // MARK: - Scan Promo Card
                        scanPromoCard
                        
                        // MARK: - Stats Grid
                        statsGridView
                        
                        // MARK: - Recent Activity
                        recentActivitySection
                    }
                    .padding(.bottom, 100)
                }
            }
            
            // MARK: - Bottom Navigation
            VStack {
                Spacer()
                CustomBottomNavigation(currentIndex: $currentTab)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                CustomText(
                    title: "Good day,",
                    fontSize: 14,
                    fontColor: AppColors.textTertiary,
                    weight: .medium
                )
                
                CustomText(
                    title: viewModel.userName,
                    fontSize: 26,
                    fontColor: .white,
                    weight: .bold
                )
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                        
                        Circle()
                            .fill(AppColors.accent)
                            .frame(width: 8, height: 8)
                            .offset(x: 8, y: -8)
                    }
                }
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(AppColors.accent.opacity(0.8))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
    
    private var scanPromoCard: some View {
        Button(action: {
            // Trigger Scan Action (potential modal)
        }) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        CustomText(
                            title: "Ready to mark attendance?",
                            fontSize: 18,
                            fontColor: .white,
                            weight: .bold
                        )
                        
                        CustomText(
                            title: "Scan any QR code to instantly check-in",
                            fontSize: 14,
                            fontColor: .white.opacity(0.8),
                            weight: .regular
                        )
                    }
                    Spacer()
                    
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("Scan Now")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .foregroundColor(AppColors.accent)
                        .cornerRadius(20)
                    
                    Spacer()
                }
            }
            .padding(24)
            .background(
                LinearGradient(
                    colors: [AppColors.accent, AppColors.accent.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(24)
            .shadow(color: AppColors.accent.opacity(0.3), radius: 15, x: 0, y: 8)
        }
        .padding(.horizontal, 24)
    }
    
    private var statsGridView: some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomText(
                title: "Your Overview",
                fontSize: 18,
                fontColor: .white,
                weight: .bold
            )
            .padding(.horizontal, 24)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatCard(
                    title: "Attendance",
                    value: String(format: "%.1f%%", viewModel.attendanceRate),
                    percentageChange: 2.5,
                    icon: UIImage(systemName: "chart.bar.fill") ?? UIImage(),
                    iconColor: AppColors.accent
                )
                
                // ... (StatCard uses AppColors and standard Text internally, usually)
                
                StatCard(
                    title: "Total Events",
                    value: "\(viewModel.totalEvents)",
                    percentageChange: nil,
                    icon: UIImage(systemName: "calendar") ?? UIImage(),
                    iconColor: .orange
                )
                
                StatCard(
                    title: "Upcoming",
                    value: "\(viewModel.upcomingEvents)",
                    percentageChange: nil,
                    icon: UIImage(systemName: "clock.fill") ?? UIImage(),
                    iconColor: .blue
                )
                
                StatCard(
                    title: "Reward Points",
                    value: "\(viewModel.points)",
                    percentageChange: 15.0,
                    icon: UIImage(systemName: "star.fill") ?? UIImage(),
                    iconColor: .yellow
                )
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                CustomText(
                    title: "Recent Activity",
                    fontSize: 18,
                    fontColor: .white,
                    weight: .bold
                )
                
                Spacer()
                
                Button(action: {}) {
                    CustomText(
                        title: "See All",
                        fontSize: 14,
                        fontColor: AppColors.accent,
                        weight: .semibold
                    )
                }
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                ForEach(Array(viewModel.recentActivities.enumerated()), id: \.element.id) { index, activity in
                    AnimatedListItem(index: index) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.accent.opacity(0.1))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(AppColors.accent)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                CustomText(
                                    title: activity.eventName,
                                    fontSize: 16,
                                    fontColor: .white,
                                    weight: .semibold
                                )
                                
                                CustomText(
                                    title: activity.date.formatted(date: .abbreviated, time: .shortened),
                                    fontSize: 13,
                                    fontColor: AppColors.textTertiary,
                                    weight: .regular
                                )
                            }
                            
                            Spacer()
                            
                            CustomText(
                                title: activity.status,
                                fontSize: 12,
                                fontColor: AppColors.accent,
                                weight: .bold
                            )
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.accent.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(16)
                        .background(AppColors.cardDark)
                        .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.top, 8)
    }
}

#Preview {
    UserHomeView()
        .environmentObject(ThemeManager())
        .environmentObject(Router())
}
