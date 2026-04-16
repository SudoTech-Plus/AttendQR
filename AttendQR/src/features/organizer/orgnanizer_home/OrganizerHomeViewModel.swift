import Foundation
import SwiftUI
import Combine

struct ScanActivity: Identifiable {
    let id = UUID()
    let attendeeName: String
    let eventName: String
    let time: String
}

class OrganizerHomeViewModel: ObservableObject {
    @Published var totalScannedToday: Int = 142
    @Published var activeEventsToday: Int = 3
    @Published var capacityUsage: Double = 68.5
    @Published var nextEventIn: String = "45m"
    @Published var recentScans: [ScanActivity] = []
    @Published var isLoading: Bool = false
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.recentScans = [
                ScanActivity(attendeeName: "Frouen Wenlake", eventName: "iOS Summit 2026", time: "2m ago"),
                ScanActivity(attendeeName: "Sarah Johnson", eventName: "iOS Summit 2026", time: "5m ago"),
                ScanActivity(attendeeName: "Michael Chen", eventName: "Weekly Standup", time: "12m ago"),
                ScanActivity(attendeeName: "Emily Davis", eventName: "iOS Summit 2026", time: "15m ago")
            ]
            self.isLoading = false
        }
    }
}
