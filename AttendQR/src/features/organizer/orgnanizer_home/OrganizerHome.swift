import SwiftUI
import Combine

struct OrganizerHome: View {
    @StateObject private var viewModel = OrganizerHomeViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // MARK: - Dashboard Header
                    dashboardHeader
                    
                    // MARK: - Metrics Grid
                    metricsGrid
                    
                    // MARK: - Live Activity
                    liveActivitySection
                }
                .padding(.top, 40)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var dashboardHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(AppColors.accent)
                        .frame(width: 8, height: 8)
                        .shadow(color: AppColors.accent, radius: 4)
                    
                    CustomText(
                        title: "Live Dashboard",
                        fontSize: 14,
                        fontColor: AppColors.accent,
                        weight: .bold
                    )
                }
                
                CustomText(
                    title: "Hello Organizer,",
                    fontSize: 26,
                    fontColor: .white,
                    weight: .bold
                )
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(
                title: "Scanned Today",
                value: "\(viewModel.totalScannedToday)",
                percentageChange: 12.5,
                icon: .system("qrcode.viewfinder"),
                iconColor: AppColors.accent
            )
            
            StatCard(
                title: "Active Events",
                value: "\(viewModel.activeEventsToday)",
                percentageChange: nil,
                icon: .system("bolt.fill"),
                iconColor: .orange
            )
            
            StatCard(
                title: "Capacity",
                value: String(format: "%.0f%%", viewModel.capacityUsage),
                percentageChange: -2.4,
                icon: .system("person.3.fill"),
                iconColor: .blue
            )
            
            StatCard(
                title: "Next Event",
                value: viewModel.nextEventIn,
                percentageChange: nil,
                icon: .system("clock.fill"),
                iconColor: .purple
            )
        }
        .padding(.horizontal, 24)
    }
    
    private var liveActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Scans")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    ForEach(viewModel.recentScans) { activity in
                        HStack(spacing: 16) {
                            Circle()
                                .fill(AppColors.accent.opacity(0.1))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(AppColors.accent)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(activity.attendeeName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(activity.eventName)
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColors.textTertiary)
                            }
                            
                            Spacer()
                            
                            Text(activity.time)
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.textTertiary)
                        }
                        .padding(16)
                        .background(AppColors.cardDark)
                        .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    OrganizerHome()
        .environmentObject(ThemeManager())
}
