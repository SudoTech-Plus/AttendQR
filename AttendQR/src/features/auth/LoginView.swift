import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background
            AppColors.adaptiveBackground(isDarkMode: themeManager.isDarkMode)
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header Area
                    VStack(spacing: 16) {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        VStack(spacing: 8) {
                            CustomText(
                                title: "AttendQR",
                                fontSize: 32,
                                fontColor: .white,
                                weight: .bold
                            )
                            
                            CustomText(
                                title: "Intelligent Attendance Tracking",
                                fontSize: 16,
                                fontColor: AppColors.textTertiary,
                                weight: .medium
                            )
                        }
                    }
                    .padding(.top, 60)
                    
                    // Login Card
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 20) {
                            CustomInputField(
                                icon: "envelope.fill",
                                placeholder: "Email",
                                text: $viewModel.email,
                            )
                            
                            CustomInputField(
                                icon: "lock.fill",
                                placeholder: "Password",
                                text: $viewModel.password,
                                isSecure: true
                            )
                            
                            HStack {
                                Spacer()
                                Button(action: { router.navigate(to: .forgotPassword) }) {
                                    Text("Forgot Password?")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppColors.secondary)
                                }
                            }
                        }
                        
                        // Error Message
                        if let error = viewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(error)
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(AppColors.error)
                            .padding(.top, 4)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        
                        // Login Button
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primary))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            CustomButton(label: "Sign In", onPressed: {
                                viewModel.login()
                            })
                        }
                        
                        // Social Login Divider
                        HStack {
                            Rectangle()
                                .fill(AppColors.textTertiary.opacity(0.3))
                                .frame(height: 1)
                            Text("OR")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppColors.textTertiary)
                                .padding(.horizontal, 8)
                            Rectangle()
                                .fill(AppColors.textTertiary.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8)
                        
                        // Social Login Icons
                        HStack(spacing: 20) {
                            SocialButton(icon: "apple.logo", action: {})
                            SocialButton(icon: "googlesvg", isSystem: false, action: {}) // Assuming you might have a google svg or just another icon
                        }
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(AppColors.surface.opacity(0.8))
                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    
                    // Footer
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                        Button(action: { router.navigate(to: .register) }) {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppColors.accent)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            
            // No longer needed: Theme Toggle removed since app is now Dark Mode Only.
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
        .onChange(of: viewModel.loginSuccess) { success in
            if success {
                router.navigate(to: .main)
            }
        }
    }
}

// Internal component for social buttons
struct SocialButton: View {
    let icon: String
    var isSystem: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if isSystem {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                } else {
                    // Placeholder for non-system icons (e.g. Google)
                    Image(systemName: "g.circle.fill")
                        .font(.system(size: 24))
                }
            }
            .frame(width: 60, height: 60)
            .background(Color.white.opacity(0.1))
            .clipShape(Circle())
            .overlay(Circle().stroke(AppColors.border, lineWidth: 1))
            .foregroundColor(AppColors.textPrimary)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(ThemeManager())
}
