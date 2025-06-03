import SwiftUI

struct SizeScaler {
    static let baseWidth: CGFloat = 375 // Base width (iPhone 11)
    static let baseHeight: CGFloat = 812 // Base height (iPhone 11)

    static var widthRatio: CGFloat {
        UIScreen.main.bounds.width / baseWidth
    }

    static var heightRatio: CGFloat {
        UIScreen.main.bounds.height / baseHeight
    }

    static func scaledFont(_ size: CGFloat) -> CGFloat {
        size * min(widthRatio, heightRatio)
    }

    static func scaledPadding(_ value: CGFloat) -> CGFloat {
        value * widthRatio
    }
}

struct Constants {
    static let ButtonsSecodaryButtonColor: Color = Color(red: 0.14, green: 0.27, blue: 0.37)
}

struct QuranReaderView: View {
    @ObservedObject var viewModel: QuranReaderViewModel
    @State private var currentPage: Int = 11
    @State private var isFullscreen: Bool = false
    @State private var isPageMode: Bool = true

    // MARK: - Font sizes based on screen size
    private var defaultFontSize: CGFloat { SizeScaler.scaledFont(16) }
    private var fullscreenFontSize: CGFloat { SizeScaler.scaledFont(18) }
    private let quranTextColor = Color(red: 0.14, green: 0.27, blue: 0.37)
    private let backgroundColor = Color(white: 0.98)
    private let lightGrayBackground = Color(white: 0.95)

    init(viewModel: QuranReaderViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.white
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
    }

    // MARK: - Components

    private var header: some View {
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
                .foregroundColor(Color.black)
                .frame(width: SizeScaler.scaledPadding(40), height: SizeScaler.scaledPadding(40))
                .background(Color.white)
                .cornerRadius(50)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
        }
        .frame(height: SizeScaler.scaledPadding(64))
        .padding(.horizontal, SizeScaler.scaledPadding(16))
        .transition(.opacity)
    }

    private var surahTitle: some View {
        SurahTitleView(
            title: viewModel.currentSurahName,
            backgroundColor: Color.black,
            textColor: quranTextColor
        )
        .frame(height: SizeScaler.scaledPadding(60))
        .transition(.opacity)
    }

    private var content: some View {
        ZStack(alignment: .top) {
            Color.white
            
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

struct QuranTextView: View {
    let text: String
    let fontSize: CGFloat
    @Binding var isFullscreen: Bool
    let textColor: Color
    
    init(text: String, fontSize: CGFloat, isFullscreen: Binding<Bool>, textColor: Color) {
        self.text = text
        self.fontSize = fontSize
        self._isFullscreen = isFullscreen
        self.textColor = textColor
        
        // Verify font loading
        if UIFont.familyNames.contains("TE HAFS2 Tharwat Emara") {
            print("Font 'TE HAFS2 Tharwat Emara' is available")
        } else {
            print("Font 'TE HAFS2 Tharwat Emara' is NOT available")
            print("Available fonts: \(UIFont.familyNames.joined(separator: ", "))")
        }
    }

    var body: some View {
        Text(text)
            .font(Font.custom("TE HAFS2 Tharwat Emara", size: fontSize))
            .foregroundColor(textColor)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            .lineSpacing(SizeScaler.scaledPadding(3))
            .padding(.horizontal, SizeScaler.scaledPadding(16))
            .padding(.vertical, SizeScaler.scaledPadding(8))
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFullscreen.toggle()
                }
            }
    }
}

struct VersePlaceholderView: View {
    let fontSize: CGFloat
    let textColor: Color
    @Binding var isFullscreen: Bool

    var body: some View {
        Text("Verses view: To be implemented")
            .font(.system(size: fontSize))
            .foregroundColor(textColor)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .lineSpacing(isFullscreen ? SizeScaler.scaledPadding(3) : SizeScaler.scaledPadding(2))
            .padding(SizeScaler.scaledPadding(16))
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFullscreen.toggle()
                }
            }
    }
}

struct QuranFooterToggleButton: View {
    @Binding var isPageMode: Bool
    let toggleAction: () -> Void

    var body: some View {
        let icon = isPageMode ? AppAssets.Icons.listIcon : AppAssets.Icons.bookIcon

        FooterButton(
            backgroundIcon: AppAssets.Icons.polygonIcon,
            foregroundIcon: icon,
            action: toggleAction
        )
        .frame(height: SizeScaler.scaledPadding(64))
    }
}

struct FooterButton: View {
    let backgroundIcon: String
    let foregroundIcon: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation { action() }
        }) {
            ZStack {
                Image(backgroundIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: SizeScaler.scaledPadding(64), height: SizeScaler.scaledPadding(64))
                    .shadow(color: Color(red: 0.96, green: 0.8, blue: 0.52).opacity(0.49), radius: 11, x: 0, y: 8)

                Image(foregroundIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: SizeScaler.scaledPadding(18), height: SizeScaler.scaledPadding(18))
            }
        }
        .frame(height: SizeScaler.scaledPadding(64))
    }
}


struct SurahTitleView: View {
    let title: String
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
            
            Text(title)
                .font(Font.custom("RTL-Maghfira-Ramadan", size: 18))
                .foregroundColor(textColor)
                .padding(.horizontal, 16)
        }
        .padding(.horizontal, SizeScaler.scaledPadding(20))
    }
}
