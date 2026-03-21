import SwiftUI

struct CustomButton: View {
    let label: String
    let onPressed: () -> Void
    
    var body: some View {
        Button(action: onPressed) {
            CustomText(
                title: label,
                fontSize: 20,
                fontColor: AppColors.textOnPrimary,
                weight: .semibold
            )
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppColors.primary)
            .cornerRadius(12)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(label: "Log In", onPressed: {})
    }
    .padding()
}
