//
//  CustomButtons.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 03/06/2025.
//

import SwiftUI

struct QuranFooterToggleButton: View {
    @Binding var isPageMode: Bool
    let toggleAction: () -> Void

    var body: some View {
        let icon = isPageMode ? AppAssets.Icons.listIcon : AppAssets.Icons.bookIcon

        FooterButton(
            backgroundIcon: AppAssets.Icons.polygonIcon,
            foregroundIcon: icon,
            action: toggleAction
        )
        .frame(height: SizeScaler.scaledPadding(64))
    }
}

struct FooterButton: View {
    let backgroundIcon: String
    let foregroundIcon: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation { action() }
        }) {
            ZStack {
                Image(backgroundIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: SizeScaler.scaledPadding(64), height: SizeScaler.scaledPadding(64))
                    .shadow(color: Color(red: 0.96, green: 0.8, blue: 0.52).opacity(0.49), radius: 11, x: 0, y: 8)

                Image(foregroundIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: SizeScaler.scaledPadding(18), height: SizeScaler.scaledPadding(18))
            }
        }
        .frame(height: SizeScaler.scaledPadding(64))
    }
}
