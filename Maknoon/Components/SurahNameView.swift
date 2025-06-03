import SwiftUI

struct SurahNameView: View {
    let surahName: String
    let backgroundColor: Color
    let textColor: Color
    let fontName: String
    
    var body: some View {
        
        ZStack(alignment: .center) {
            Image(AppAssets.Images.quranFrame)
                .resizable()
                .frame(height: SizeScaler.scaledPadding(60.18598175048828))
                .padding(.horizontal, 16)
            Text(surahName)
                .font(Font.custom(fontName, size: 18))
                .foregroundColor(textColor)
                .padding(.horizontal, 16)

        }
        .padding(.horizontal, SizeScaler.scaledPadding(20))
    }
}
