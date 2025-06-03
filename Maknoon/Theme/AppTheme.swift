import SwiftUI

/// Central theme definitions for the app
enum AppTheme {
    /// Color definitions
    enum Colors {
        /// Primary brand color
        static let primary = Color("PrimColor", bundle: nil)
        
        /// Secondary brand color
        static let secondary = Color("SecondaryColor", bundle: nil)
        
        /// Primary text color
        static let textPrimary = Color("TextPrimaryColor", bundle: nil)
        
        /// Secondary text color
        static let textSecondary = Color("TextSecondaryColor", bundle: nil)
        
        /// Background color for screens
        static let background = Color("BackgroundColor", bundle: nil)
        
        /// Background color for the mushaf (Quran pages)
        static let mushafBackground = Color("MushafBackgroundColor", bundle: nil)
        
        // Default color values if the named colors don't exist
        static func defaultTextPrimary() -> Color { Color.primary }
        static func defaultTextSecondary() -> Color { Color.secondary }
        static func defaultBackground() -> Color { Color(.systemBackground) }
        static func defaultMushafBackground() -> Color { Color(.systemBackground).opacity(0.97) }
        static func defaultPrimary() -> Color { Color.green }
        static func defaultSecondary() -> Color { Color.blue }
    }
    
    /// Layout definitions
    enum Layout {
        /// Standard corner radius for rounded elements
        static let cornerRadius: CGFloat = 8
        
        /// Standard padding for content containers
        static let padding: CGFloat = 16
        
        /// Content spacing between elements
        static let spacing: CGFloat = 12
    }
    
    /// Typography definitions
    enum Typography {
        /// Font for main titles
        static let titleFont = Font.title.weight(.bold)
        
        /// Font for section headings
        static let headingFont = Font.headline
        
        /// Font for body text
        static let bodyFont = Font.body
        
        /// Font for captions and small text
        static let captionFont = Font.caption
        
        /// Special font for Quran text
        static func quranFont(size: CGFloat = 22) -> Font {
            Font.custom("TE HAFS2 Tharwat Emara", size: size)
        }
    }
    
    // MARK: - Text Styles
    
    enum TextStyles {
        static func quranText() -> Font {
            .custom("TE HAFS2 Tharwat Emara", size: 24)
        }
        
        static func surahName() -> Font {
            .custom("TE HAFS2 Tharwat Emara", size: 32)
        }
        
        static func pageNumber() -> Font {
            .system(size: 16, weight: .medium)
        }
    }
    
    // MARK: - Animations
    
    enum Animations {
        static let pageTurn = Animation.easeInOut(duration: 0.3)
        static let fade = Animation.easeInOut(duration: 0.2)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(AppTheme.Colors.primary)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.Layout.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.white)
            .foregroundColor(AppTheme.Colors.primary)
            .cornerRadius(AppTheme.Layout.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Layout.cornerRadius)
                    .stroke(AppTheme.Colors.primary, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - View Extensions

extension View {
    func primaryButtonStyle() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButtonStyle() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }
} 


// MARK: - Appearance

enum AppAppearance: String, CaseIterable {
    case system
    case light
    case dark
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}
