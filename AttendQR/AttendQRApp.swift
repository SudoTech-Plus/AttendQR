//
//  AttendQRApp.swift
//  AttendQR
//
//  Created by Frouen on 3/17/26.
//

import SwiftUI

@main
struct AttendQRApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var router = Router()
    var body: some Scene {
        
        WindowGroup {
                Group {
                    switch router.currentRoot {
                    case .splash:
                        SplashView()
                    case .login:
                       LoginView()
                    case .register:
                        RegisterView()
                    case .otp:
                        OTPView()
                    case .forgotPassword:
                        ForgotPasswordView()
                    case .main:
                        UserMainView()
                    case .organizerMain:
                        OrganizerMainView()
                    }
                }
                .environmentObject(themeManager)
                .environmentObject(router)
                .preferredColorScheme(.dark)
        }
    }
}
