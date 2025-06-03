import SwiftUI

// Create a namespace for our app's constants
enum Maknoon {
    // Re-export the app assets
    typealias Assets = AppAssets
    
    // Define theme colors directly
    enum Theme {
        static let quranTextColor = Color(red: 0.14, green: 0.27, blue: 0.37)
        static let primaryColor = Color(red: 0.2, green: 0.4, blue: 0.65)
        static let secondaryColor = Color(red: 0.5, green: 0.3, blue: 0.2)
        static let backgroundColor = Color(white: 0.98)
        static let lightGrayBackground = Color(white: 0.95)
    }
    
    // Fonts used in the app
    enum Fonts {
        static let quranText = "TE HAFS2 Tharwat Emara"
        static let quranTitleArabic = "RTL-Maghfira"
        static let arabicUI = "Amiri-Regular"
    }
} 
