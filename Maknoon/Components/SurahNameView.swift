import SwiftUI

struct SurahNameView: View {
    let surahName: String
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
            
            Text(surahName)
                .font(Font.custom("RTL-Maghfira-Ramadan", size: 18))
                .foregroundColor(textColor)
                .padding(.horizontal, 16)

        }
        .padding(.horizontal, SizeScaler.scaledPadding(20))
    }
}
