import SwiftUI

struct UserMainView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content Area
            Group {
                switch selectedTab {
                case 0:
                    UserHomeView()
                case 1:
                    UserScanView()
                case 2:
                    UserEventView()
                case 3:
                    UserProfileView()
                default:
                    UserHomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Navigation
            CustomBottomNavigation(currentIndex: $selectedTab)
                .padding(.bottom, 0)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
    }
}

#Preview {
    UserMainView()
        .environmentObject(ThemeManager())
        .environmentObject(Router())
}
