import SwiftUI

struct PageEntryView: View {
    @State private var pageNumber: String = ""
    @State private var showQuranReader: Bool = false
    @State private var selectedPage: Int = 1
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter Page Number")
                    .font(.title)
                    .foregroundColor(.primary)
                
                TextField("Page Number (1-604)", text: $pageNumber)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: pageNumber) { newValue in
                        // Only allow numbers
                        pageNumber = newValue.filter { $0.isNumber }
                    }
                
                Button(action: {
                    if let page = Int(pageNumber), page >= 1, page <= 604 {
                        selectedPage = page
                        showQuranReader = true
                    }
                }) {
                    Text("Open Page")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Color.blue
                                .opacity(isValidPage ? 1.0 : 0.5)
                        )
                        .cornerRadius(10)
                }
                .disabled(!isValidPage)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 50)
            .navigationBarTitle("Quran Reader", displayMode: .inline)
            .fullScreenCover(isPresented: $showQuranReader) {
                QuranReaderView(viewModel: QuranReaderViewModel(), initialPage: selectedPage)
            }
        }
    }
    
    private var isValidPage: Bool {
        guard let page = Int(pageNumber) else { return false }
        return page >= 1 && page <= 604
    }
}

struct PageEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PageEntryView()
    }
}
