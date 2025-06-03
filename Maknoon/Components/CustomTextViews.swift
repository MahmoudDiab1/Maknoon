//
//  CustomTextViews.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 03/06/2025.
//

import SwiftUI

struct QuranTextView: View {
    let text: String
    let fontSize: CGFloat
    @Binding var isFullscreen: Bool
    let textColor: Color
    
    init(text: String, fontSize: CGFloat, isFullscreen: Binding<Bool>, textColor: Color) {
        self.text = text
        self.fontSize = fontSize
        self._isFullscreen = isFullscreen
        self.textColor = textColor
        
        // Verify font loading
        if UIFont.familyNames.contains("TE HAFS2 Tharwat Emara") {
            print("Font 'TE HAFS2 Tharwat Emara' is available")
        } else {
            print("Font 'TE HAFS2 Tharwat Emara' is NOT available")
            print("Available fonts: \(UIFont.familyNames.joined(separator: ", "))")
        }
    }

    var body: some View {
        Text(text)
            .font(Font.custom("TE HAFS2 Tharwat Emara", size: fontSize))
            .foregroundColor(textColor)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            .lineSpacing(SizeScaler.scaledPadding(3))
            .padding(.horizontal, SizeScaler.scaledPadding(16))
            .padding(.vertical, SizeScaler.scaledPadding(8))
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFullscreen.toggle()
                }
            }
    }
}

struct VersePlaceholderView: View {
    let fontSize: CGFloat
    let textColor: Color
    @Binding var isFullscreen: Bool

    var body: some View {
        Text("Verses view: To be implemented")
            .font(.system(size: fontSize))
            .foregroundColor(textColor)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .lineSpacing(isFullscreen ? SizeScaler.scaledPadding(3) : SizeScaler.scaledPadding(2))
            .padding(SizeScaler.scaledPadding(16))
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFullscreen.toggle()
                }
            }
    }
}
