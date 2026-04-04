import SwiftUI

struct CustomText: View {
    let title: String
    let fontSize: CGFloat
    let fontColor: Color
    let weight: Font.Weight
    
    // The font family name registered in Info.plist
    var fontFamily: String = "ElmsSans"
    
    var body: some View {
        Text(title)
            // Try to use the custom font, fallback to system if not found
            .font(.custom(fontFamily, size: fontSize).weight(weight))
            .foregroundColor(fontColor)
    }
}

#Preview {
    VStack {
        CustomText(
            title: "Hello Wenlance",
            fontSize: 24,
            fontColor: .blue,
            weight: .bold
        )
    }
}
