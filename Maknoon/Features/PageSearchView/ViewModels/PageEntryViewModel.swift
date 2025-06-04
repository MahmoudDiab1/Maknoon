import Foundation
import SwiftUI

class PageEntryViewModel: ObservableObject {
    @Published var pageNumber: String = ""
    @Published var isValidPage: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    var pageInt: Int? {
        convertToEnglishNumber(pageNumber)
    }
    
    func filterAndValidatePageNumber(_ newValue: String) {
        let filtered = newValue.filter { char in
            AppConstants.Numbers.arabicNumbers.contains(char) ||
            AppConstants.Numbers.englishNumbers.contains(char)
        }
        pageNumber = filtered
        validatePage()
    }
    
    private func validatePage() {
        guard let page = pageInt else {
            isValidPage = false
            return
        }
        
        if page < AppConstants.Numbers.minPage || page > AppConstants.Numbers.maxPage {
            isValidPage = false
            showToastMessage("الرجاء إدخال رقم صفحة بين ١ و ٦٠٤")
        } else {
            isValidPage = true
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        
        // Hide toast after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showToast = false
        }
    }
    
    private func convertToEnglishNumber(_ arabicNumber: String) -> Int? {
        let mapping = Dictionary(uniqueKeysWithValues: zip(
            Array(AppConstants.Numbers.arabicNumbers),
            Array(AppConstants.Numbers.englishNumbers)
        ))
        
        let englishNumber = arabicNumber.map { String(mapping[$0] ?? $0) }.joined()
        return Int(englishNumber)
    }
} 