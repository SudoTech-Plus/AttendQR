import Foundation
import SwiftUI
import Combine

struct OrgSettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    var detail: String? = nil
}

class OrganizerProfileViewModel: ObservableObject {
    @Published var orgName: String = "Wenlance Tech Inc."
    @Published var orgEmail: String = "admin@wenlance.com"
    @Published var plan: String = "Enterprise"
    @Published var teamMembers: Int = 12
    
    let settingsGroups: [[OrgSettingsItem]] = [
        [
            OrgSettingsItem(title: "Organization Profile", icon: "building.2.fill", color: .blue),
            OrgSettingsItem(title: "Team Management", icon: "person.2.fill", color: .orange, detail: "12 members"),
            OrgSettingsItem(title: "Billing & Subscription", icon: "creditcard.fill", color: .green, detail: "Active")
        ],
        [
            OrgSettingsItem(title: "API Keys & Integration", icon: "key.fill", color: .yellow),
            OrgSettingsItem(title: "Data Export", icon: "tray.and.arrow.down.fill", color: .purple),
            OrgSettingsItem(title: "Global App Settings", icon: "gearshape.fill", color: .gray)
        ],
        [
            OrgSettingsItem(title: "Help Center", icon: "questionmark.circle.fill", color: .blue),
            OrgSettingsItem(title: "Contact Support", icon: "envelope.fill", color: .red)
        ]
    ]
}
