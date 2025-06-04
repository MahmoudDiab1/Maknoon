import SwiftUI

struct PageEntryView: View {
    @AppStorage("appAppearance") private var appAppearance: AppAppearance = .light
    @Environment(\.colorScheme) private var colorScheme
    @State private var pageNumber: String = ""
    @State private var isValidPage: Bool = false
    @State private var shouldNavigate: Bool = false
    
    private var theme: QuranTheme {
        QuranTheme.theme(for: colorScheme)
    }
    
    private var pageInt: Int? {
        // Convert Arabic numerals to English before parsing
        let englishNumber = pageNumber
            .replacingOccurrences(of: "٠", with: "0")
            .replacingOccurrences(of: "١", with: "1")
            .replacingOccurrences(of: "٢", with: "2")
            .replacingOccurrences(of: "٣", with: "3")
            .replacingOccurrences(of: "٤", with: "4")
            .replacingOccurrences(of: "٥", with: "5")
            .replacingOccurrences(of: "٦", with: "6")
            .replacingOccurrences(of: "٧", with: "7")
            .replacingOccurrences(of: "٨", with: "8")
            .replacingOccurrences(of: "٩", with: "9")
        return Int(englishNumber)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("ادخل رقم الصفحة")
                        .font(.custom("RTL-Maghfira", size: 24))
                        .foregroundColor(theme.textColor)
                    
                    TextField("رقم الصفحة (١ - ٦٠٤)", text: $pageNumber)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .onChange(of: pageNumber) { newValue in
                            // Allow both Arabic and English numbers
                            let filtered = newValue.filter { char in
                                let arabicNumbers = "٠١٢٣٤٥٦٧٨٩"
                                let englishNumbers = "0123456789"
                                return arabicNumbers.contains(char) || englishNumbers.contains(char)
                            }
                            pageNumber = filtered
                            validatePage()
                        }
                    
                    if let page = pageInt {
                        NavigationLink(
                            destination: QuranReaderFactory.makeQuranReaderView(page: page),
                            isActive: $shouldNavigate
                        ) {
                            Button(action: {
                                if isValidPage {
                                    shouldNavigate = true
                                }
                            }) {
                                Text("اقرا")
                                    .font(.custom("RTL-Maghfira", size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isValidPage ? theme.headerColor : Color.gray)
                                    .cornerRadius(10)
                            }
                            .disabled(!isValidPage)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    private func validatePage() {
        guard let page = pageInt else {
            isValidPage = false
            return
        }
        isValidPage = page >= 1 && page <= 604
    }
}

#Preview {
    PageEntryView()
}
