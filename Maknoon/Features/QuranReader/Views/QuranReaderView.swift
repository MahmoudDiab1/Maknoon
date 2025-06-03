import SwiftUI
 
enum AppAppearance: String, CaseIterable {
    case light
    case dark
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}


struct QuranReaderView: View {
    @StateObject private var viewModel: QuranReaderViewModel
    @AppStorage("appAppearance") private var appAppearance: AppAppearance = .light
    @Environment(\.colorScheme) private var colorScheme
    
    init(viewModel: QuranReaderViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
 

    
    @State private var currentPage: Int = 11
    @State private var isFullscreen: Bool = false
    @State private var isPageMode: Bool = true

    // MARK: - Font sizes based on screen size
    private var defaultFontSize: CGFloat { SizeScaler.scaledFont(16) }
    private var fullscreenFontSize: CGFloat { SizeScaler.scaledFont(18) }
    
    private var quranTextColor: Color {
        colorScheme == .dark ? Constants.DarkModeTextColor : Color(red: 0.14, green: 0.27, blue: 0.37)
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Constants.DarkModeBackground : Color(white: 0.98)
    }
    
    private var lightGrayBackground: Color {
        colorScheme == .dark ? Color(white: 0.15) : Color(white: 0.95)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: isFullscreen ? [] : .all)

            VStack(spacing: 0) {
                if !isFullscreen {
                    header
                }
                surahTitle
                content
                if !isFullscreen {
                    footer
                } else {
                    fullscreenFooter
                }
            }
        }
        .gesture(swipeGesture)
        .onAppear { viewModel.loadPage(currentPage) }
        .animation(.easeInOut(duration: 0.3), value: isFullscreen)
        .preferredColorScheme(selectedColorScheme)
    }

    private var selectedColorScheme: ColorScheme? {
        switch AppAppearance(rawValue: appAppearance.rawValue) ?? .light {
        case .light: return .light
        case .dark: return .dark
        }
    }

    // MARK: - Components

    private var header: some View {
        VStack(spacing: SizeScaler.scaledPadding(8)) {
            // Dark Mode Toggle
            HStack {
                Spacer()
                Toggle("", isOn: Binding(
                    get: { appAppearance == .dark },
                    set: { newValue in
                        appAppearance = newValue ? .dark : .light
                    }
                ))
                .labelsHidden()
            }
            .padding(.horizontal, SizeScaler.scaledPadding(16))
            .padding(.vertical, SizeScaler.scaledPadding(8))
            .background(colorScheme == .dark ? Constants.DarkModeBackground : Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            
              
        }
        .transition(.opacity)
    }

    private var surahTitle: some View {
        SurahNameView(
            surahName: viewModel.currentSurahName,
            backgroundColor: Color.black,
            textColor: quranTextColor
        )
        .frame(height: SizeScaler.scaledPadding(60))
        .transition(.opacity)
    }

    private var content: some View {
        ZStack(alignment: .top) {
            backgroundColor
            
            Group {
                if isPageMode {
                    QuranTextView(
                        text: viewModel.pageText,
                        fontSize: isFullscreen ? fullscreenFontSize : defaultFontSize,
                        isFullscreen: $isFullscreen,
                        textColor: quranTextColor
                    )
                } else {
                    VersePlaceholderView(
                        fontSize: isFullscreen ? fullscreenFontSize : defaultFontSize,
                        textColor: quranTextColor,
                        isFullscreen: $isFullscreen
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var footer: some View {
        HStack(spacing: SizeScaler.scaledPadding(12)) {
            Button(action: goToNextPage) {
                HStack(spacing: SizeScaler.scaledPadding(8)) {
                    Image(AppAssets.Icons.arrowLeftIcon)
                        .resizable()
                        .frame(width: SizeScaler.scaledPadding(10), height: SizeScaler.scaledPadding(10))

                    Text("الصفحة التالية")
                        .font(Font.custom("IBM Plex Sans Arabic", size: SizeScaler.scaledFont(10)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white)
                }
                .frame(width: SizeScaler.scaledPadding(100), height: SizeScaler.scaledPadding(32))
                .padding(SizeScaler.scaledPadding(6))
                .background(Constants.ButtonsSecodaryButtonColor)
                .cornerRadius(40)
            }
            .disabled(currentPage >= 640)

            Button(action: goToPreviousPage) {
                HStack(spacing: SizeScaler.scaledPadding(8)) {
                    Text("الصفحة السابقة")
                        .font(Font.custom("IBM Plex Sans Arabic", size: SizeScaler.scaledFont(10)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white)

                    Image(AppAssets.Icons.arrowLeftIcon)
                        .resizable()
                        .frame(width: SizeScaler.scaledPadding(10), height: SizeScaler.scaledPadding(10))
                        .scaleEffect(x: -1, y: 1) // Flips left to right
                }
                .frame(width: SizeScaler.scaledPadding(100), height: SizeScaler.scaledPadding(32))
                .padding(SizeScaler.scaledPadding(6))
                .background(Constants.ButtonsSecodaryButtonColor)
                .cornerRadius(40)
            }
            .disabled(currentPage <= 1)

            Spacer()

            QuranFooterToggleButton(
                isPageMode: $isPageMode,
                toggleAction: { isPageMode.toggle() }
            )
        }
        .frame(height: SizeScaler.scaledPadding(64))
        .padding(.horizontal, SizeScaler.scaledPadding(16))
        .transition(.opacity)
    }

    private var fullscreenFooter: some View {
        HStack(spacing: SizeScaler.scaledPadding(16)) {
            Spacer()
            Text("جزء \(String(viewModel.currentJuz).toArabicIndic())")
                .font(Font.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                .foregroundColor(quranTextColor)

            Text("-")
                .font(Font.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                .foregroundColor(quranTextColor)

            Text("حزب \(String(viewModel.currentHizb).toArabicIndic())")
                .font(Font.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                .foregroundColor(quranTextColor)

            Text("-")
                .font(Font.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                .foregroundColor(quranTextColor)

            Text("صفحة \(String(currentPage).toArabicIndic())")
                .font(Font.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                .foregroundColor(quranTextColor)
        }
        .padding(5)
    }

    // MARK: - Gesture

    private var swipeGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                let threshold: CGFloat = 50
                if value.translation.width > threshold {
                    goToPreviousPage()
                } else if value.translation.width < -threshold {
                    goToNextPage()
                }
            }
    }

    // MARK: - Navigation Logic

    private func goToNextPage() {
        guard currentPage < 604 else { return }
        currentPage += 1
        viewModel.loadPage(currentPage)
    }

    private func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        viewModel.loadPage(currentPage)
    }
}

struct QuranReaderView_Previews: PreviewProvider {
    static var previews: some View {
        let networkService = NetworkService()
        let api = QuranAPIImpl(networkService: networkService)
        let viewModel = QuranReaderViewModel(api: api)
        return QuranReaderView(viewModel: viewModel)
    }
}
