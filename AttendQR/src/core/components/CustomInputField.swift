import SwiftUI
import Combine

struct CustomInputField: View {
    let icon: String?
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    #if os(iOS)
    var keyboardType: UIKeyboardType = .default
    var autoCapitalization: TextInputAutocapitalization = .never
    #endif
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(isFocused ? AppColors.secondary : AppColors.textTertiary)
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 24)
                }
                
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(AppColors.textTertiary))
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(AppColors.textTertiary))
                    }
                }
                .focused($isFocused)
                .font(.custom("ElmsSans", size: 16))
                .foregroundColor(isFocused ? .white : AppColors.textPrimary)
                
                if isSecure {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(isFocused ? AppColors.secondary : AppColors.textTertiary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? AppColors.secondary : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: isFocused ? AppColors.secondary.opacity(0.1) : Color.clear, radius: 8, x: 0, y: 4)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomInputField(
            icon: "envelope.fill",
            placeholder: "Email Address",
            text: Binding.constant("")
        )
        
        CustomInputField(
            icon: "lock.fill",
            placeholder: "Password",
            text: Binding.constant("password"),
            isSecure: true
        )
    }
    .padding()
    .background(AppColors.softBackground)
}
