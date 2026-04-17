//
//  router.swift
//  AttendQR
//
//  Created by Frouen on 4/4/26.
//

import SwiftUI
import Foundation
import Combine

/// Defines all possible root screens in the application
enum AppRoute: Hashable {
    case splash
    case login
    case register
    case otp
    case forgotPassword
    case main
    case organizerMain
}

/// Centralized router for managing global application state and navigation
class Router: ObservableObject {
    @Published var currentRoot: AppRoute = .splash
    
    // Transient state for registration flow
    @Published var pendingEmail: String = ""
    @Published var pendingUsername: String = ""
    
    /// Navigate to a new root view with an animation
    func navigate(to route: AppRoute) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.currentRoot = route
            }
        }
    }
}
