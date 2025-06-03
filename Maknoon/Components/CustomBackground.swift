//
//  CustomBackground.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 04/06/2025.
//

import SwiftUI

struct LinearGradientBackground: View {
    var colors: [Color]
    var startPoint: UnitPoint = .top
    var endPoint: UnitPoint = .bottom
    var height: CGFloat

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: startPoint,
                       endPoint: endPoint)
            .frame(height: height)
    }
}
