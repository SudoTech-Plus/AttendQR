import SwiftUI
import LucideIcons

struct OrganizerMainView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    
    // Custom set of navigation items for Organizers
    private let organizerNavItems: [(icon: PlatformImage, label: String)] = [
        (Lucide.layoutDashboard, "Dashboard"),
        (Lucide.calendar, "Events"),
        (Lucide.user, "Profile")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content Area
            Group {
                switch selectedTab {
                case 0:
                    OrganizerHome()
                case 1:
                    OrganizerEvent()
                case 2:
                    OrganizerProfileView()
                default:
                    OrganizerHome()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Navigation (Injected with organizer items)
            CustomBottomNavigation(
                currentIndex: $selectedTab,
                navItems: organizerNavItems
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
    }
}

#Preview {
    OrganizerMainView()
        .environmentObject(ThemeManager())
        .environmentObject(Router())
}
