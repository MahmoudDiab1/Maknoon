//
//  Footer.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 04/06/2025.
//
import SwiftUI

// MARK: - Footer Components
struct FooterView: View {
    let currentPage: Int
    @Binding var isPageMode: Bool
    let infoItems: [String]
    let textColor: Color
    let onNext: () -> Void
    let onPrevious: () -> Void
    let onToggleMode: () -> Void
    
    var body: some View {
        HStack(spacing: SizeScaler.scaledPadding(12)) {
            nextButton
            previousButton
            Spacer()
            QuranFooterToggleButton(isPageMode: $isPageMode) {
                onToggleMode()
            }
        }
        .frame(height: SizeScaler.scaledPadding(64))
        .padding(.horizontal, SizeScaler.scaledPadding(16))
    }
    
    private var nextButton: some View {
        Button(action: onNext) {
            HStack(spacing: SizeScaler.scaledPadding(8)) {
                Image(AppAssets.Icons.arrowLeftIcon)
                    .resizable()
                    .frame(width: SizeScaler.scaledPadding(10), height: SizeScaler.scaledPadding(10))
                Text("الصفحة التالية")
            }
            .commonFooterButtonStyle()
        }
        .disabled(currentPage >= 604)
    }
    
    private var previousButton: some View {
        Button(action: onPrevious) {
            HStack(spacing: SizeScaler.scaledPadding(8)) {
                Text("الصفحة السابقة")
                Image(AppAssets.Icons.arrowLeftIcon)
                    .resizable()
                    .frame(width: SizeScaler.scaledPadding(10), height: SizeScaler.scaledPadding(10))
                    .scaleEffect(x: -1, y: 1)
            }
            .commonFooterButtonStyle()
        }
        .disabled(currentPage <= 1)
    }
}
