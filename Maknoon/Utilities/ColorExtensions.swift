import SwiftUI

extension Color {
    /// App theme colors accessible through this extension
    struct Theme {
        /// Primary brand color
        static let primary = Color(AppAssets.Colors.primary)
        
        /// Secondary brand color
        static let secondary = Color(AppAssets.Colors.secondary)
        
        /// Accent color for highlights
        static let accent = Color(AppAssets.Colors.accent)
        
        /// Main background color
        static let background = Color(AppAssets.Colors.background)
        
        /// Primary text color
        static let textPrimary = Color(AppAssets.Colors.textPrimary)
        
        /// Secondary/muted text color
        static let textSecondary = Color(AppAssets.Colors.textSecondary)
        
        /// Background color for Quran pages
        static let mushafBackground = Color(AppAssets.Colors.mushafBackground)
        
        /// Text color specific to Quran arabic text
        static let quranText = Color(red: 0.14, green: 0.27, blue: 0.37)
    }
}

// MARK: - Semantic Colors
extension Color {
    /// Predefined semantic colors for consistent usage
    struct Semantic {
        /// Color for success states and messages
        static let success = Color.green
        
        /// Color for warning states and messages
        static let warning = Color.yellow
        
        /// Color for error states and messages
        static let error = Color.red
        
        /// Color for informational states and messages
        static let info = Color.blue
    }
} 