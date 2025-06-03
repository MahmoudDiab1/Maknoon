//
//  ScreenSizeScaller.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 03/06/2025.
//

import SwiftUI

struct SizeScaler {
    static let baseWidth: CGFloat = 375 // Base width (iPhone 11)
    static let baseHeight: CGFloat = 812 // Base height (iPhone 11)

    static var widthRatio: CGFloat {
        UIScreen.main.bounds.width / baseWidth
    }

    static var heightRatio: CGFloat {
        UIScreen.main.bounds.height / baseHeight
    }

    static func scaledFont(_ size: CGFloat) -> CGFloat {
        size * min(widthRatio, heightRatio)
    }

    static func scaledPadding(_ value: CGFloat) -> CGFloat {
        value * widthRatio
    }
}
