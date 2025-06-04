import SwiftUI

enum AppConstants {
    enum Fonts {
        static let maghfira = "RTL-Maghfira"
        static let ibmPlexSansArabic = "IBM Plex Sans Arabic"
        static let ibmPlexSansArabicRegular = "IBMPlexSansArabic-Regular"
    }
    
    enum Colors {
        static let darkModeBackground = Color(hex: "#333844")
        static let lightModeBackground = Color(hex: "#BCDEF9")
        static let lightModeEndBackground = Color(white: 0.98)
        static let darkModeEndBackground = Color(.sRGB, white: 0.11, opacity: 1)
        static let selectedTabColor = Color(red: 231/255, green: 182/255, blue: 102/255)
        static let unselectedTabColor = Color(red: 83/255, green: 106/255, blue: 123/255)
    }
    
    enum TabTitles {
        static let normalReading = "قراءة عادية"
        static let interactiveReading = "قراءة تفاعلية"
    }
    
    enum Icons {
        static let bookEnabled = "bookEnabled"
        static let bookDisabled = "bookDisabled"
    }
    
    enum Layout {
        static let headerHeight: CGFloat = 109
        static let tabBarHeight: CGFloat = 44
        static let borderOpacity: Double = 0.2
        static let borderHeight: CGFloat = 1
    }
    
    enum Text {
        static let juz = "جزء"
        static let hizb = "حزب"
        static let page = "صفحة"
        static let separator = "-"
        
        // Page Entry View
        static let enterPageNumber = "ادخل رقم الصفحة"
        static let pageNumberPlaceholder = "رقم الصفحة (١ - ٦٠٤)"
        static let read = "اقرا"
        
        // Navigation
        static let back = "رجوع"
        static let next = "التالي"
        static let previous = "السابق"
        
        // Settings
        static let settings = "الإعدادات"
        static let appearance = "المظهر"
        static let darkMode = "الوضع الليلي"
        static let lightMode = "الوضع النهاري"
        
        // Quran Reader
        static let surah = "سورة"
        static let ayah = "آية"
        static let bookmark = "إضافة إشارة مرجعية"
        static let removeBookmark = "إزالة الإشارة المرجعية"
    }
    
    enum Numbers {
        static let minPage = 1
        static let maxPage = 604
        static let arabicNumbers = "٠١٢٣٤٥٦٧٨٩"
        static let englishNumbers = "0123456789"
    }
    
    enum Animation {
        static let duration: Double = 0.3
    }
    
    enum Gesture {
        static let threshold: CGFloat = 50
    }
} 
