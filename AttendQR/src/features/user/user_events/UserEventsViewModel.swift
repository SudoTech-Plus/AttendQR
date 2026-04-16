import Foundation
import Combine
import SwiftUI

struct AppEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let location: String
    let category: String
    let imageName: String // Placeholder for asset name
    let isJoined: Bool
}

class UserEventsViewModel: ObservableObject {
    @Published var events: [AppEvent] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    
    let categories = ["All", "Work", "Education", "Social", "Workshop"]
    
    init() {
        loadMockEvents()
    }
    
    func loadMockEvents() {
        events = [
            AppEvent(title: "iOS Development Summit", date: "JUL 18, 2026", location: "San Francisco, CA", category: "Workshop", imageName: "event1", isJoined: false),
            AppEvent(title: "Annual Tech Conference", date: "AUG 05, 2026", location: "Online", category: "Education", imageName: "event2", isJoined: true),
            AppEvent(title: "Music Festival 2026", date: "SEPT 12, 2026", location: "London, UK", category: "Social", imageName: "event3", isJoined: false),
            AppEvent(title: "Morning Team Sync", date: "TOMORROW, 09:00 AM", location: "Office Room 3B", category: "Work", imageName: "event4", isJoined: true)
        ]
    }
    
    var filteredEvents: [AppEvent] {
        events.filter { event in
            let matchesSearch = searchText.isEmpty || event.title.lowercased().contains(searchText.lowercased())
            let matchesCategory = selectedCategory == "All" || event.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }
}
