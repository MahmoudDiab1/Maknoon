import SwiftUI


// MARK: - Main View
struct QuranReaderView: View {
    @StateObject private var viewModel: QuranReaderViewModel
    @AppStorage("appAppearance") private var appAppearance: AppAppearance = .light
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
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
                            .frame(height: SizeScaler.scaledPadding(40))
                            .padding(.vertical, 5)
                    }
                    .background(appAppearance == .dark ? Constants.DarkModeBackground : Color.white)
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
            "صفحة \(viewModel.currentPage.toArabicIndic())"
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

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: QuranReaderView.Tab
    let theme: QuranTheme
    
    var body: some View {
        HStack(spacing: 20) {
            TabButton(
                title: "قراءة عادية",
                isSelected: selectedTab == .quran,
                theme: theme
            ) {
                withAnimation {
                    selectedTab = .quran
                }
            }
            
            TabButton(
                title: "قراءة تفاعلية",
                isSelected: selectedTab == .empty,
                theme: theme
            ) {
                withAnimation {
                    selectedTab = .empty
                }
            }
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let theme: QuranTheme
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 5) {
                Spacer()
                Image(isSelected ? AppAssets.Icons.bookEnabled : AppAssets.Icons.bookDisabled)
                
                Text(title)
                    .font(.custom("IBM Plex Sans Arabic", size: 14))
                    .foregroundColor(isSelected ? Color(red: 231/255, green: 182/255, blue: 102/255) : Color(red: 83/255, green: 106/255, blue: 123/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                Spacer()
            }.background(
                VStack {
                    Spacer()
                    if isSelected {
                        Rectangle()
                            .fill(Color(red: 231/255, green: 182/255, blue: 102/255))
                            .frame(height: 3)
                            .clipShape(
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                            )
                    }
                }
            )
        }
        .frame(width: 127)
    }
}
