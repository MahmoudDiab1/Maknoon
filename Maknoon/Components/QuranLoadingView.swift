import SwiftUI

/// A view displaying the app's loading state with progress information
struct QuranLoadingView: View {
    /// The loading progress as a value between 0 and 1
    let progress: Double
    
    /// The descriptive text to display below the progress bar
    let infoText: String
    
    /// Optional custom icon (defaults to book.fill)
    var iconName: String = "book.fill"
    
    /// Optional app title (defaults to "مكنون")
    var appTitle: String = "مكنون"
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // App icon
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(AppTheme.Colors.primary)
            
            // App title
            Text(appTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            // Progress indicator
            progressView
                .padding(.top, 10)
            
            // Information text
            Text(infoText)
                .font(AppTheme.TextStyles.quranText())
                .multilineTextAlignment(.center)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.horizontal)
                .padding(.top, 5)
            
            Spacer()
        }
        .padding()
        .background(AppTheme.Colors.mushafBackground.ignoresSafeArea())
    }
    
    /// Progress view with percentage
    private var progressView: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: 250)
            
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .foregroundColor(AppTheme.Colors.primary)
        }
    }
}

// MARK: - Alternative Loading Views

/// A compact loading indicator for inline usage
struct CompactLoadingView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Layout.cornerRadius)
                .fill(Color.white.opacity(0.9))
        )
        .shadow(radius: 2)
    }
}

/// A loading overlay that can be placed above content
struct OverlayLoadingView: View {
    let message: String
    let progress: Double?
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            if let progress = progress {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 150)
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Layout.cornerRadius)
                .fill(Color.white.opacity(0.9))
        )
        .shadow(radius: 4)
    }
}

#Preview {
    Group {
        QuranLoadingView(
            progress: 0.65,
            infoText: "جاري تحميل القرآن الكريم ... "
        )
        
        CompactLoadingView(message: "جاري التحميل ...")
            .padding()
        
        OverlayLoadingView(message: "جاري تحميل القرآن الكريم...", progress: 0.35)
            .padding()
    }
} 
