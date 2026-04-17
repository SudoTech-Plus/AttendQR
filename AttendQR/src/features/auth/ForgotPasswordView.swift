import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    @State private var email = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground(isDarkMode: themeManager.isDarkMode)
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Button(action: { router.navigate(to: .login) }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    CustomText(
                        title: "Reset Password",
                        fontSize: 32,
                        fontColor: .white,
                        weight: .bold
                    )
                    
                    CustomText(
                        title: "Enter your email to receive recovery instructions",
                        fontSize: 16,
                        fontColor: AppColors.textTertiary,
                        weight: .medium
                    )
                }
                .padding(.top, 40)
                
                // Input Card
                VStack(spacing: 24) {
                    CustomInputField(
                        icon: "envelope.fill",
                        placeholder: "Email Address",
                        text: $email,
                    )
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.accent))
                            .padding()
                    } else {
                        CustomButton(label: "Send Link", onPressed: {
                            sendResetLink()
                        })
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(AppColors.surface.opacity(0.8))
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    private func sendResetLink() {
        guard !email.isEmpty else { return }
        
        isLoading = true
        // Simulated network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            router.navigate(to: .otp)
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(ThemeManager())
        .environmentObject(Router())
}
