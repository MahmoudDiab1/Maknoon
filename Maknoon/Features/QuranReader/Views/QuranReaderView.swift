import SwiftUI


// MARK: - Main View
struct QuranReaderView: View {
    @StateObject private var viewModel: QuranReaderViewModel
    @AppStorage("appAppearance") private var appAppearance: AppAppearance = .light
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale
    @State private var isFullscreen: Bool = false
    @State private var isPageMode: Bool = true
    @State private var selectedTab: Tab = .quran
    
    enum Tab {
        case quran
        case empty
    }
    
    init(viewModel: QuranReaderViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
    
    private var isRTL: Bool {
        locale.languageCode == "ar"
    }
    
    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea(edges: isFullscreen ? [.top, .bottom] : .all)
            
            VStack(spacing: 0) {
                if !isFullscreen {
                    VStack(spacing: 0) {
                        HeaderView(
                            appAppearance: appAppearance,
                            colorScheme: colorScheme,
                            surahName: viewModel.currentSurahName,
                            juz: viewModel.currentJuz,
                            hizb: viewModel.currentHizb,
                            page: viewModel.currentPage,
                            isDarkMode: Binding(
                                get: { appAppearance == .dark },
                                set: { appAppearance = $0 ? .dark : .light }
                            ),
                            onBack: {
                                dismiss()
                            }
                        )
                        .frame(height: SizeScaler.scaledPadding(60))
                        
                        CustomTabBar(selectedTab: $selectedTab, theme: theme)
                            .frame(width: UIScreen.main.bounds.width, height: SizeScaler.scaledPadding(30))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 0)
                        .background(appAppearance == .dark ? Constants.DarkModeBackground : Color.white)
                    }
                    .padding(.horizontal, 0)
                }
                content
                
                if !isFullscreen {
                    FooterView(
                        currentPage: viewModel.currentPage,
                        isPageMode: $isPageMode,
                        infoItems: infoItems,
                        textColor: theme.textColor,
                        onNext: viewModel.goToNextPage,
                        onPrevious: viewModel.goToPreviousPage,
                        onToggleMode: { isPageMode.toggle() }
                    )
                } else {
                    fullscreenFooter
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .gesture(swipeGesture)
        .onAppear { viewModel.loadPage() }
        .animation(.easeInOut(duration: 0.3), value: isFullscreen)
        .preferredColorScheme(selectedColorScheme)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
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
            .padding(.top, SizeScaler.scaledPadding(20))
            
            ZStack(alignment: .top) {
                theme.backgroundColor
                Group {
                    if selectedTab == .quran {
                        if isPageMode {
                            QuranTextView(
                                text: viewModel.pageText,
                                isFullscreen: $isFullscreen,
                                textColor: theme.textColor
                            )
                        }
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
            ForEach(0..<infoItems.count, id: \.self) { index in
                Text(infoItems[index])
                    .font(.custom(isRTL ? "RTL-Maghfira" : "IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                    .foregroundColor(theme.textColor)
            }
        }
        .padding(5)
    }
    
    private var infoItems: [String] {
        [
            String(format: NSLocalizedString("juz %@", comment: ""), viewModel.currentJuz.toArabicIndic()),
            NSLocalizedString("-", comment: ""),
            String(format: NSLocalizedString("hizb %@", comment: ""), viewModel.currentHizb.toArabicIndic()),
            NSLocalizedString("-", comment: ""),
            String(format: NSLocalizedString("page %@", comment: ""), viewModel.currentPage.toArabicIndic())
        ]
    }
    
    private var swipeGesture: some Gesture {
        DragGesture().onEnded { value in
            let threshold: CGFloat = 50
            if value.translation.width > threshold {
                viewModel.goToNextPage()
            } else if value.translation.width < -threshold {
                viewModel.goToPreviousPage()
            }
        }
    }
}
