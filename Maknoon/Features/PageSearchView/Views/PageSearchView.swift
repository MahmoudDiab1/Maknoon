import SwiftUI

struct PageEntryView: View {
    // MARK: - Properties
    @StateObject private var viewModel = PageEntryViewModel()
    @AppStorage("appAppearance") private var appAppearance: AppAppearance = .light
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Computed Properties
    private var theme: QuranTheme {
        QuranTheme.theme(for: colorScheme)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                theme.backgroundColor.ignoresSafeArea()
                mainContent
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - View Components
    private var mainContent: some View {
        VStack(spacing: 20) {
            titleView
            pageNumberTextField
            if let page = viewModel.pageInt {
                readButton(for: page)
            }
        }
        .padding()
    }
    
    private var titleView: some View {
        Text(AppConstants.Text.enterPageNumber)
            .font(.custom(AppConstants.Fonts.maghfira, size: 24))
            .foregroundColor(theme.textColor)
    }
    
    private var pageNumberTextField: some View {
        TextField(AppConstants.Text.pageNumberPlaceholder, text: $viewModel.pageNumber)
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .onChange(of: viewModel.pageNumber) { newValue in
                viewModel.filterAndValidatePageNumber(newValue)
            }
    }
    
    private func readButton(for page: Int) -> some View {
        NavigationLink {
            QuranReaderFactory.makeQuranReaderView(page: page)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            Text(AppConstants.Text.read)
                .font(.custom(AppConstants.Fonts.maghfira, size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isValidPage ? theme.headerColor : Color.gray)
                .cornerRadius(10)
        }
        .disabled(!viewModel.isValidPage)
    }
}

// MARK: - Preview
#Preview {
    PageEntryView()
}
