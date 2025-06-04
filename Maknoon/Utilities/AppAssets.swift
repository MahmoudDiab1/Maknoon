import SwiftUI

/// Contains all the asset names used in the app
/// Provides type-safe access to app assets
enum AppAssets {
    
    /// System and custom icons used throughout the app
    enum Icons {
        // System SF Symbols
        static let bookDisabled = "bookDisabled"
        static let bookEnabled = "bookEnabled"
        static let surahFrameDark = "SurahFrameDark"
        static let arrowLeft = "arrow.left"
        static let arrowRight = "arrow.right"
        static let arrowHeader = "arrow-right-header"
        static let book = "book"
        static let bookFill = "book.fill"
        static let gear = "gear"
        static let magnifyingglass = "magnifyingglass"
        static let list = "list.bullet"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let share = "square.and.arrow.up"
        static let bookmark = "bookmark"
        static let bookmarkFill = "bookmark.fill"
        static let moon = "moon"
        static let sun = "sun.max"
        static let xmark = "xmark"
        static let plus = "plus"
        static let person = "person"
        static let chevronRight = "chevron.right"
        static let chevronLeft = "chevron.left"
        static let chevronUp = "chevron.up"
        static let chevronDown = "chevron.down"
        static let fullscreen = "arrow.up.left.and.arrow.down.right"
        static let exitFullscreen = "arrow.down.right.and.arrow.up.left"
        static let polygonIcon = "polygon-icon"
        static let listIcon = "list-view-icon"
        static let arrowLeftIcon = "arrow-left-icon"
        static let bookIcon = "book-icon"
        // Custom icons (if any)
        static let quranIcon = "quran-icon"
        static let madinahMushaf = "madina-mushaf"
    }
    
    /// Images used throughout the app
    enum Images {
        // App branding
        static let appLogo = "app-logo"
        
        static let appBackground = "app-background"
        static let splashBackground = "splash-background"
        static let  rectangleYellowBackGround = "rectangleYellowBackGround"
        // Decorative elements
        static let islamicPattern = "islamic-pattern"
        static let bismillah = "bismillah"
        static let ornamentalDivider = "ornamental-divider"
        static let surahHeader = "surah-header"
        static let quranFrame =  "SurahFrameDark"
        // Illustrations
        static let emptyState = "empty-state"
        static let notFound = "not-found"
        
    }
    
    /// Colors from the asset catalog
    enum Colors {
        static let primary = "PrimColor"
        static let secondary = "SecondaryColor"
        static let accent = "AccentColor"
        static let background = "BackgroundColor"
        static let textPrimary = "TextPrimaryColor"
        static let textSecondary = "TextSecondaryColor"
        static let mushafBackground = "MushafBackgroundColor"
    }
}
