//
//  HeaderView.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 04/06/2025.
//

import SwiftUI

// MARK: - Header Components
struct HeaderView: View {
    let appAppearance: AppAppearance
    let colorScheme: ColorScheme
    let surahName: String
    let juz: Int
    let hizb: Int
    let page: Int
    @Binding var isDarkMode: Bool
    
    var body: some View {
        ZStack {
            headerBackground
            VStack {
                HStack {
                    appearanceToggle
                    Spacer()
                    surahInfo
                }
                Spacer()
            }
            .padding()
        }
        .frame(height: 109)
    }
    
    private var headerBackground: some View {
        Group {
            if appAppearance == .dark {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#333844"), Color(.sRGB, white: 0.11, opacity: 1)]),
                    startPoint: .top, endPoint: .bottom
                )
            } else {
                LinearGradientBackground(
                    colors: [Color(hex: "#BCDEF9"), Color(white: 0.98)],
                    height: 109
                )
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private var appearanceToggle: some View {
        Toggle("", isOn: $isDarkMode)
            .tint(colorScheme == .dark ? Color.gray : Color.indigo)
            .labelsHidden()
    }
    
    private var surahInfo: some View {
        HStack {
            VStack(alignment: .trailing, spacing: 2) {
                Text(surahName)
                    .font(.custom("IBM Plex Sans Arabic", size: SizeScaler.scaledFont(14)))
                    .fontWeight(.semibold)
                    .foregroundColor(appAppearance == .light ? Constants.DarkModeHederColor : .white)
                
                HStack(spacing: SizeScaler.scaledPadding(2)) {
                    ForEach(infoItems, id: \.self) { item in
                        Text(item)
                            .font(.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                            .foregroundColor(theme.textColor)
                    }
                }
            }
            
            Image(AppAssets.Icons.arrowHeader)
                .frame(width: 32, height: 32)
        }
    }
    
    private var infoItems: [String] {
        [
            "جزء \(juz.toArabicIndic())",
            "-",
            "حزب \(hizb.toArabicIndic())",
            "-",
            "صفحة \(page.toArabicIndic())"
        ]
    }
    
    private var theme: QuranTheme {
        QuranTheme.theme(for: colorScheme)
    }
}
