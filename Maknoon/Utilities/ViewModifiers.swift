import SwiftUI

// MARK: - Common View Modifiers

/// Adds a card-like appearance to a view
struct CardStyle: ViewModifier {
    var backgroundColor: Color = .white
    var cornerRadius: CGFloat = AppTheme.Layout.cornerRadius
    var shadowRadius: CGFloat = 4
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
}

/// Adds a rounded border to a view
struct RoundedBorder: ViewModifier {
    var color: Color = AppTheme.Colors.secondary
    var lineWidth: CGFloat = 1.5
    var cornerRadius: CGFloat = AppTheme.Layout.cornerRadius
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}

/// Creates a responsive frame that adapts to device size
struct ResponsiveFrame: ViewModifier {
    var idealWidth: CGFloat
    var maxWidth: CGFloat? = nil
    var alignment: Alignment = .center
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth ?? (idealWidth * 1.5))
            .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
    }
}

/// Adds a standard loading overlay to a view
struct LoadingOverlay: ViewModifier {
    var isLoading: Bool
    var message: String = "جاري التحميل..."
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)
            
            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Layout.cornerRadius)
                        .fill(Color.white.opacity(0.9))
                )
                .shadow(radius: 4)
                .transition(.opacity)
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// Apply a card-like style to the view
    func cardStyle(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = AppTheme.Layout.cornerRadius,
        shadowRadius: CGFloat = 4
    ) -> some View {
        self.modifier(CardStyle(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius
        ))
    }
    
    /// Apply a rounded border to the view
    func roundedBorder(
        color: Color = AppTheme.Colors.secondary,
        lineWidth: CGFloat = 1.5,
        cornerRadius: CGFloat = AppTheme.Layout.cornerRadius
    ) -> some View {
        self.modifier(RoundedBorder(
            color: color,
            lineWidth: lineWidth,
            cornerRadius: cornerRadius
        ))
    }
    
    /// Apply a responsive frame to the view
    func responsiveFrame(
        idealWidth: CGFloat,
        maxWidth: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        self.modifier(ResponsiveFrame(
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            alignment: alignment
        ))
    }
    
    /// Apply a loading overlay to the view
    func loadingOverlay(
        isLoading: Bool,
        message: String = "جاري التحميل..."
    ) -> some View {
        self.modifier(LoadingOverlay(
            isLoading: isLoading,
            message: message
        ))
    }
} 