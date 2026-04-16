import Foundation
import Combine
import SwiftUI

struct AppEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let location: String
    let category: String
    let imageUrl: String
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
            AppEvent(title: "iOS Development Summit", date: "JUL 18, 2026", location: "San Francisco, CA", category: "Workshop", imageUrl: "https://images.unsplash.com/photo-1540575861501-7ad05823c93b?auto=format&fit=crop&q=80&w=800", isJoined: false),
            AppEvent(title: "Annual Tech Conference", date: "AUG 05, 2026", location: "Online", category: "Education", imageUrl: "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?auto=format&fit=crop&q=80&w=800", isJoined: true),
            AppEvent(title: "Music Festival 2026", date: "SEPT 12, 2026", location: "London, UK", category: "Social", imageUrl: "https://images.unsplash.com/photo-1459749411177-042180ce673f?auto=format&fit=crop&q=80&w=800", isJoined: false),
            AppEvent(title: "Morning Team Sync", date: "TOMORROW, 09:00 AM", location: "Office Room 3B", category: "Work", imageUrl: "https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&q=80&w=800", isJoined: true)
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
