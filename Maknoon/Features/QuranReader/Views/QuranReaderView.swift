import SwiftUI


// MARK: - Main View
struct QuranReaderView: View {
    @StateObject private var viewModel: QuranReaderViewModel
    @AppStorage("appAppearance") private var appAppearance: AppAppearance = .light
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentPage: Int
    @State private var isFullscreen: Bool = false
    @State private var isPageMode: Bool = true
    
    init(viewModel: QuranReaderViewModel, currentPage: Int) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.currentPage = currentPage
    }
    
    private var selectedColorScheme: ColorScheme? {
        switch appAppearance {
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    private var fontSize: CGFloat {
        isFullscreen ? SizeScaler.scaledFont(18) : SizeScaler.scaledFont(16)
    }
    
    private var theme: QuranTheme {
        QuranTheme.theme(for: colorScheme)
    }
    
    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea(edges: isFullscreen ? [] : .all)
            
            VStack(spacing: 0) {
                if !isFullscreen {
                    HeaderView(
                        appAppearance: appAppearance,
                        colorScheme: colorScheme,
                        surahName: viewModel.currentSurahName,
                        juz: viewModel.currentJuz,
                        hizb: viewModel.currentHizb,
                        page: currentPage,
                        isDarkMode: Binding(
                            get: { appAppearance == .dark },
                            set: { appAppearance = $0 ? .dark : .light }
                        )
                    )
                }
                content
                if !isFullscreen {
                    FooterView(
                        currentPage: currentPage,
                        isPageMode: $isPageMode,
                        infoItems: infoItems,
                        textColor: theme.textColor,
                        onNext: goToNextPage,
                        onPrevious: goToPreviousPage,
                        onToggleMode: { isPageMode.toggle() }
                    )
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
    
    private var content: some View {
        VStack {
            ZStack(alignment: .center) {
                Image(AppAssets.Images.quranFrame)
                    .resizable()
                    .frame(height: SizeScaler.scaledPadding(60.18598175048828))
                    .padding(.horizontal, 16)
                Text(viewModel.currentSurahName)
                    .font(Font.custom("RTL-Maghfira", size: 18))
                    .foregroundColor(appAppearance == .light ? theme.headerColor : Color.white)
            }
            .padding(.horizontal, 16)
            
            ZStack(alignment: .top) {
                theme.backgroundColor
                Group {
                    if isPageMode {
                        QuranTextView(
                            text: viewModel.pageText,
                            isFullscreen: $isFullscreen,
                            textColor: theme.textColor
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea()
        }
    }
    
    private var fullscreenFooter: some View {
        HStack(spacing: SizeScaler.scaledPadding(16)) {
            Spacer()
            ForEach(infoItems, id: \.self) {
                Text($0)
                    .font(.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                    .foregroundColor(theme.textColor)
            }
        }
        .padding(5)
    }
    
    private var infoItems: [String] {
        [
            "جزء \(viewModel.currentJuz.toArabicIndic())",
            "-",
            "حزب \(viewModel.currentHizb.toArabicIndic())",
            "-",
            "صفحة \(currentPage.toArabicIndic())"
        ]
    }
    
    private var swipeGesture: some Gesture {
        DragGesture().onEnded { value in
            let threshold: CGFloat = 50
            if value.translation.width > threshold {
                goToNextPage()
            } else if value.translation.width < -threshold {
                goToPreviousPage() 
            }
        }
    }
    
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

// MARK: - View Modifiers
internal extension View {
    func commonFooterButtonStyle() -> some View {
        self
            .font(.custom("IBM Plex Sans Arabic", size: SizeScaler.scaledFont(10)))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .frame(width: SizeScaler.scaledPadding(100), height: SizeScaler.scaledPadding(32))
            .padding(SizeScaler.scaledPadding(6))
            .background(Constants.ButtonsSecodaryButtonColor)
            .cornerRadius(40)
    }
}
