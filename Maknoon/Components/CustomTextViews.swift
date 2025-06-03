import CoreFoundation
import SwiftUI

struct QuranTextView: View {
    let text: String
    @Binding var isFullscreen: Bool
    let textColor: Color

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let calculatedFontSize = computeFontSize(for: height)

            VStack {
                Text(text)
                    .font(Font.custom("TE HAFS2 Tharwat Emara", size: calculatedFontSize))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(SizeScaler.scaledPadding(3))
                    .padding(.horizontal, SizeScaler.scaledPadding(16))
                    .padding(.vertical, SizeScaler.scaledPadding(6))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isFullscreen.toggle()
                        }
                    }
                Spacer(minLength: 0)
            }
        }
    }

    private func computeFontSize(for height: CGFloat) -> CGFloat {
        if isFullscreen {
            return min(SizeScaler.scaledFont(18.2), height / 28)
        } else {
            return min(SizeScaler.scaledFont(15), height / 30)
        }
    }
}
