import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    
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
                                title: "Create Account",
                                fontSize: 32,
                                fontColor: .white,
                                weight: .bold
                            )
                            
                            CustomText(
                                title: "Join the intelligent network",
                                fontSize: 16,
                                fontColor: AppColors.textTertiary,
                                weight: .medium
                            )
                        }
                    }
                    .padding(.top, 40)
                    
                    // Register Card
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            CustomInputField(
                                icon: "person.fill",
                                placeholder: "Full Name",
                                text: $viewModel.fullName
                            )
                            
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
                            
                            CustomInputField(
                                icon: "lock.shield.fill",
                                placeholder: "Confirm Password",
                                text: $viewModel.confirmPassword,
                                isSecure: true
                            )
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
                        }
                        
                        // Register Button
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.accent))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            CustomButton(label: "Sign Up", onPressed: {
                                viewModel.register()
                            })
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
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.textSecondary)
                        Button(action: { 
                            router.navigate(to: .login)
                        }) {
                            Text("Log In")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppColors.accent)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
        .onChange(of: viewModel.registerSuccess) { success in
            if success {
                router.pendingEmail = viewModel.email
                router.pendingUsername = viewModel.fullName
                router.navigate(to: .otp)
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(ThemeManager())
        .environmentObject(Router())
}
