import SwiftUI

struct QuranReaderView: View {
    @ObservedObject var viewModel: QuranReaderViewModel
    @State private var currentPage: Int = 11
    @State private var isFullscreen: Bool = false
    @State private var isPageMode: Bool = true
    @AppStorage("appAppearance") private var appAppearance: String = AppAppearance.system.rawValue
    @Environment(\.colorScheme) private var colorScheme

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

    init(viewModel: QuranReaderViewModel) {
        self.viewModel = viewModel
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
        switch AppAppearance(rawValue: appAppearance) ?? .system {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    // MARK: - Components

    private var header: some View {
        VStack(spacing: SizeScaler.scaledPadding(8)) {
            // Appearance Picker
            Picker("Appearance", selection: $appAppearance) {
                ForEach(AppAppearance.allCases, id: \.self) { appearance in
                    Text(appearance.displayName).tag(appearance.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, SizeScaler.scaledPadding(16))
            .background(colorScheme == .dark ? Constants.DarkModeBackground : Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            
            // Navigation Controls
            HStack {
                Button(action: goToPreviousPage) {
                    HStack(spacing: SizeScaler.scaledPadding(5)) {
                        Text("الصفحة السابقة")
                            .font(Font.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)

                        Image(AppAssets.Icons.arrowLeftIcon)
                            .resizable()
                            .frame(width: SizeScaler.scaledPadding(11.5), height: SizeScaler.scaledPadding(11.5))
                    }
                    .frame(width: SizeScaler.scaledPadding(116), height: SizeScaler.scaledPadding(40))
                    .padding(SizeScaler.scaledPadding(6))
                    .background(Constants.ButtonsSecodaryButtonColor)
                    .cornerRadius(50)
                }
                .disabled(currentPage <= 1)

                Spacer()

                Text("\(currentPage)")
                    .font(Font.custom("IBMPlexSansArabic-Regular", size: SizeScaler.scaledFont(14)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? Constants.DarkModeTextColor : Color.black)
                    .frame(width: SizeScaler.scaledPadding(40), height: SizeScaler.scaledPadding(40))
                    .background(colorScheme == .dark ? Color(white: 0.2) : Color.white)
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.1), radius: 2)
            }
            .frame(height: SizeScaler.scaledPadding(64))
            .padding(.horizontal, SizeScaler.scaledPadding(16))
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
