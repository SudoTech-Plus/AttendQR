import Foundation
import SwiftUI
import Combine

struct ManagedEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let attendees: Int
    let status: String // "Active", "Ended", "Upcoming"
    let color: Color
    let imageUrl: String
}

class OrganizerEventsViewModel: ObservableObject {
    @Published var events: [ManagedEvent] = []
    
    init() {
        loadEvents()
    }
    
    func loadEvents() {
        events = [
            ManagedEvent(title: "iOS Development Summit", date: "Jul 18, 2026", attendees: 124, status: "Active", color: .green, imageUrl: "https://images.unsplash.com/photo-1540575861501-7ad05823c93b?auto=format&fit=crop&q=80&w=800"),
            ManagedEvent(title: "UX/UI Design Workshop", date: "Aug 02, 2026", attendees: 0, status: "Upcoming", color: .blue, imageUrl: "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&q=80&w=800"),
            ManagedEvent(title: "Weekly Engineering Sync", date: "Apr 15, 2026", attendees: 42, status: "Ended", color: .gray, imageUrl: "https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800"),
            ManagedEvent(title: "Product Launch Party", date: "Dec 20, 2025", attendees: 500, status: "Ended", color: .red, imageUrl: "https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&q=80&w=800")
        ]
    }
}
