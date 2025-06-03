import SwiftUI

enum AppAppearance: String, CaseIterable {
    case light, dark

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
    @State private var currentPage: Int = 11
    @State private var isFullscreen: Bool = false
    @State private var isPageMode: Bool = true

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

    private var quranTextColor: Color {
        colorScheme == .dark ? Constants.DarkModeTextColor : Color(red: 0.14, green: 0.27, blue: 0.37)
    }

    private var headerTextColor: Color {
        Constants.DarkModeHederColor
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? Constants.DarkModeBackground : Color(white: 0.98)
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea(edges: isFullscreen ? [] : .all)

            VStack(spacing: 0) {
                if !isFullscreen { header }
                content
                if !isFullscreen { footer } else { fullscreenFooter }
            }
        }
        .gesture(swipeGesture)
        .onAppear { viewModel.loadPage(currentPage) }
        .animation(.easeInOut(duration: 0.3), value: isFullscreen)
        .preferredColorScheme(selectedColorScheme)
    }

    // MARK: - Header
    private var header: some View {
            ZStack {
                headerBackground
                VStack {
                    HStack {
                        appearanceToggle
                        Spacer()
                        
                        surahInfo
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .frame(height: 109)
    }

    private var headerBackground: some View {
        Group {
            if appAppearance == .dark {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#333844"), Color(.sRGB, white: 0.11, opacity: 1)]),
                    startPoint: .top, endPoint: .bottom
                )
            } else {
                LinearGradientBackground(
                    colors: [Color(hex: "#BCDEF9"), Color(white: 0.98)],
                    height: 109
                )
            }
        }
        .edgesIgnoringSafeArea(.top)
    }

    private var appearanceToggle: some View {
        Toggle("", isOn: Binding(
            get: { appAppearance == .dark },
            set: { appAppearance = $0 ? .dark : .light }
        ))
        .tint(colorScheme == .dark ? Color.gray : Color.indigo)
        .labelsHidden()
    }

    private var headerButton: some View {
        Button(action: {}) {
            Image(AppAssets.Images.rectangleYellowBackGround)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 30)
        }
        .cornerRadius(8)
        .shadow(color: .clear, radius: 0, x: 0, y: 0)
        
    }

    private var surahInfo: some View {
        HStack {
            VStack(alignment: .trailing, spacing: 2) {
                Text(viewModel.currentSurahName)
                    .font(.custom("IBM Plex Sans Arabic", size: SizeScaler.scaledFont(14)))
                    .fontWeight(.semibold)
                    .foregroundColor(appAppearance == .light ? headerTextColor : .white)

                HStack(spacing: SizeScaler.scaledPadding(2)) {
                    ForEach(infoItems, id: \.self) { item in
                        Text(item)
                            .font(.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                            .foregroundColor(quranTextColor)
                    }
                }
            }

            Image(AppAssets.Icons.arrowHeader)
                .frame(width: 32, height: 32)
        }
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

    // MARK: - Content
    private var content: some View {
        
        VStack {
            ZStack(alignment: .center) {
                Image(AppAssets.Images.quranFrame)
                    .resizable()
                    .frame(height: SizeScaler.scaledPadding(60.18598175048828))
                    .padding(.horizontal, 16)
                Text( viewModel.currentSurahName)
                    .font(Font.custom("RTL-Maghfira", size: 18))
                    .foregroundColor(appAppearance == .light ? headerTextColor : Color.white)

            }
            .padding(.horizontal, 16)
            
            ZStack(alignment: .top) {
                backgroundColor
                Group {
                    if isPageMode {
                        QuranTextView(
                            text: viewModel.pageText,
                            fontSize: fontSize,
                            isFullscreen: $isFullscreen,
                            textColor: quranTextColor
                        )
                    } else {
                        VersePlaceholderView(
                            fontSize: fontSize,
                            textColor: quranTextColor,
                            isFullscreen: $isFullscreen
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(2)
            .ignoresSafeArea()
        }
    }

    // MARK: - Footer
    private var footer: some View {
        HStack(spacing: SizeScaler.scaledPadding(12)) {
            nextButton
            previousButton
            Spacer()
            QuranFooterToggleButton(isPageMode: $isPageMode) {
                isPageMode.toggle()
            }
        }
        .frame(height: SizeScaler.scaledPadding(64))
        .padding(.horizontal, SizeScaler.scaledPadding(16))
    }

    private var fullscreenFooter: some View {
        HStack(spacing: SizeScaler.scaledPadding(16)) {
            Spacer()
            ForEach(infoItems, id: \.self) {
                Text($0)
                    .font(.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                    .foregroundColor(quranTextColor)
            }
        }
        .padding(5)
    }

    private var nextButton: some View {
        Button(action: goToNextPage) {
            HStack(spacing: SizeScaler.scaledPadding(8)) {
                Image(AppAssets.Icons.arrowLeftIcon)
                    .resizable()
                    .frame(width: SizeScaler.scaledPadding(10), height: SizeScaler.scaledPadding(10))
                Text("الصفحة التالية")
            }
            .commonFooterButtonStyle()
        }
        .disabled(currentPage >= 604)
    }

    private var previousButton: some View {
        Button(action: goToPreviousPage) {
            HStack(spacing: SizeScaler.scaledPadding(8)) {
                Text("الصفحة السابقة")
                Image(AppAssets.Icons.arrowLeftIcon)
                    .resizable()
                    .frame(width: SizeScaler.scaledPadding(10), height: SizeScaler.scaledPadding(10))
                    .scaleEffect(x: -1, y: 1)
            }
            .commonFooterButtonStyle()
        }
        .disabled(currentPage <= 1)
    }

    // MARK: - Gesture
    private var swipeGesture: some Gesture {
        DragGesture().onEnded { value in
            let threshold: CGFloat = 50
            if value.translation.width > threshold {
                goToPreviousPage()
            } else if value.translation.width < -threshold {
                goToNextPage()
            }
        }
    }

    // MARK: - Navigation
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

// MARK: - View Modifier for Reuse
private extension View {
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
