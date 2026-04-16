import SwiftUI
import Combine

struct OrganizerEvent: View {
    @StateObject private var viewModel = OrganizerEventsViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    CustomText(
                        title: "Manage Events",
                        fontSize: 28,
                        fontColor: .white,
                        weight: .bold
                    )
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Events List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(viewModel.events) { event in
                            OrganizerEventCard(event: event)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Circle()
                            .fill(LinearGradient(
                                colors: [AppColors.accent, AppColors.accent.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 64, height: 64)
                            .shadow(color: AppColors.accent.opacity(0.4), radius: 15, y: 8)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                            )
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct OrganizerEventCard: View {
    let event: ManagedEvent
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                // Event Thumbnail
                AsyncImage(url: URL(string: event.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(AppColors.textTertiary)
                            )
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(event.status)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(event.color.opacity(0.2))
                            .foregroundColor(event.color)
                            .cornerRadius(6)
                        
                        Text(event.date)
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    CustomText(
                        title: event.title,
                        fontSize: 18,
                        fontColor: .white,
                        weight: .bold
                    )
                }
                
                Spacer()
                
                // Attendee Insight
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(event.attendees)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("Attendees")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.textTertiary)
                }
            }
            .padding(16)
            
            // Bottom Action Row
            HStack {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.accent)
                }
                
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "chart.pie.fill")
                        Text("Stats")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.03))
        }
        .background(AppColors.cardDark)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

#Preview {
    OrganizerEvent()
        .environmentObject(ThemeManager())
}
