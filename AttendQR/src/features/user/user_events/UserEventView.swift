import SwiftUI
import Combine

struct UserEventView: View {
    @StateObject private var viewModel = UserEventsViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    CustomText(
                        title: "Discover Events",
                        fontSize: 28,
                        fontColor: .white,
                        weight: .bold
                    )
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.textTertiary)
                    
                    TextField("", text: $viewModel.searchText, prompt: 
                        Text("Search events...")
                            .foregroundColor(AppColors.textTertiary)
                    )
                    .foregroundColor(.white)
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: { viewModel.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColors.textTertiary)
                        }
                    }
                }
                .padding(14)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            CategoryButton(
                                title: category,
                                isSelected: viewModel.selectedCategory == category,
                                action: { viewModel.selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 20)
                
                // Events List
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.filteredEvents) { event in
                            EventCard(event: event)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

// MARK: - Subviews
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? AppColors.accent : Color.white.opacity(0.05))
                .foregroundColor(isSelected ? .black : .white)
                .cornerRadius(25)
        }
    }
}

struct EventCard: View {
    let event: AppEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event Image Placeholder
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 180)
                
                // Category Badge
                Text(event.category)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.accent)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    CustomText(
                        title: event.date,
                        fontSize: 12,
                        fontColor: AppColors.accent,
                        weight: .bold
                    )
                    
                    CustomText(
                        title: event.title,
                        fontSize: 18,
                        fontColor: .white,
                        weight: .bold
                    )
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(AppColors.textTertiary)
                        .font(.system(size: 14))
                    
                    CustomText(
                        title: event.location,
                        fontSize: 14,
                        fontColor: AppColors.textTertiary,
                        weight: .regular
                    )
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text(event.isJoined ? "Attending" : "Join")
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(event.isJoined ? Color.white.opacity(0.1) : AppColors.accent)
                            .foregroundColor(event.isJoined ? .white : .black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(16)
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
    UserEventView()
        .environmentObject(ThemeManager())
}
