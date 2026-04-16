import Foundation
import SwiftUI
import Combine

struct AttendanceActivity: Identifiable {
    let id = UUID()
    let eventName: String
    let date: Date
    let status: String // e.g., "Present", "Late"
}

class UserHomeViewModel: ObservableObject {
    @Published var userName: String = "User"
    @Published var attendanceRate: Double = 92.5
    @Published var totalEvents: Int = 24
    @Published var upcomingEvents: Int = 2
    @Published var points: Int = 450
    @Published var recentActivities: [AttendanceActivity] = []
    @Published var isLoading: Bool = false
    
    init() {
        fetchUserData()
    }
    
    func fetchUserData() {
        isLoading = true
        
        // Simulating data fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.userName = "Frouen" // Example name
            self.attendanceRate = 96.0
            self.totalEvents = 21
            self.upcomingEvents = 3
            self.points = 520
            
            self.recentActivities = [
                AttendanceActivity(eventName: "Morning Standup", date: Date(), status: "Present"),
                AttendanceActivity(eventName: "iOS Workshop", date: Date().addingTimeInterval(-86400), status: "Present"),
                AttendanceActivity(eventName: "Weekly Sync", date: Date().addingTimeInterval(-172800), status: "Late")
            ]
            
            self.isLoading = false
        }
    }
}
