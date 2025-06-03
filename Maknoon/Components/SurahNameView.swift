import SwiftUI

/// A decorative frame component displaying a Surah name with Islamic design elements
struct SurahNameView: View {
    /// The Arabic name of the Surah to display
    let surahName: String
    
    /// Optional width to constrain the component
    var width: CGFloat?
    
    var body: some View {
        ZStack {
            // Background for better contrast
            RoundedRectangle(cornerRadius: 6)
                .fill(AppTheme.Colors.mushafBackground)
                .frame(width: width ?? 260, height: 60)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppTheme.Colors.secondary, lineWidth: 1.5)
                )
            
            // Decorative borders
            VStack(spacing: 0) {
                // Top border
                HStack(spacing: 2) {
                    ForEach(0..<14, id: \.self) { _ in
                        IslamicDesignElement()
                    }
                }
                .padding(.top, 6)
                
                Spacer()
                
                // Bottom border
                HStack(spacing: 2) {
                    ForEach(0..<14, id: \.self) { _ in
                        IslamicDesignElement()
                    }
                }
                .padding(.bottom, 6)
            }
            .padding(.horizontal, 10)
            
            // Text
            Text(surahName)
                .font(AppTheme.TextStyles.surahName())
                .environment(\.layoutDirection, .rightToLeft)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, 8)
        }
    }
}

/// A small decorative element used in Islamic designs
struct IslamicDesignElement: View {
    var body: some View {
        ZStack {
            // Small circle
            Circle()
                .fill(AppTheme.Colors.secondary)
                .frame(width: 6, height: 6)
            
            // Diamond shape
            DiamondShape()
                .stroke(AppTheme.Colors.secondary, lineWidth: 1)
                .frame(width: 12, height: 12)
        }
    }
}

/// A diamond-shaped geometry element
struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let midX = rect.midX
        let midY = rect.midY
        
        path.move(to: CGPoint(x: midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: midY))
        path.addLine(to: CGPoint(x: midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: midY))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        SurahNameView(surahName: "سورة الفاتحة")
        SurahNameView(surahName: "سورة البقرة", width: 200)
        SurahNameView(surahName: "سورة آل عمران", width: 300)
    }
    .padding()
    .background(AppTheme.Colors.mushafBackground)
} 
