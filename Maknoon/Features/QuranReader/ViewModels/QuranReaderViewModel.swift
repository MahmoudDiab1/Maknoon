import Foundation
import Combine
import SwiftUI
import os.log

extension String {
    func toArabicIndic() -> String {
        let arabicNumbers = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
        return self.map { char in
            if let number = Int(String(char)) {
                return arabicNumbers[number]
            }
            return String(char)
        }.joined()
    }
}

final class QuranReaderViewModel: ObservableObject {
    private let api: QuranAPI
    private let logger = Logger(subsystem: "com.maknoon.quran", category: "ViewModel")
    private var cancellables = Set<AnyCancellable>()
    
    @Published var pageText: String = ""
    @Published var ayahLines: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPageAyahs: [AyahModel] = []
    @Published var currentSurahName: String = ""
    @Published var currentJuz: Int = 1
    @Published var currentHizb: Int = 1
    
    init(api: QuranAPI = QuranAPIImpl(networkService: NetworkService())) {
        self.api = api
        logger.debug("QuranReaderViewModel initialized")
    }
    
    func loadPage(_ page: Int) {
        isLoading = true
        errorMessage = nil
        pageText = ""
        ayahLines = []
        
        logger.debug("Starting to load page \(page)")
        
        api.fetchPageAyahs(page: page)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.logger.error("Failed to load page \(page): \(error.localizedDescription)")
                    
                    if page > 1 {
                        self?.logger.info("Attempting to load previous page")
                        self?.loadPage(page - 1)
                    }
                }
            } receiveValue: { [weak self] ayahs in
                guard let self = self else { return }
                
                if ayahs.isEmpty {
                    self.logger.warning("No ayahs found for page \(page)")
                    self.errorMessage = "No ayahs found for page \(page)"
                    
                    if page > 1 {
                        self.logger.info("Attempting to load previous page")
                        self.loadPage(page - 1)
                    }
                    return
                }
                
                self.logger.debug("Received \(ayahs.count) ayahs for page \(page)")
                self.logger.debug("First ayah text: \(ayahs.first?.text ?? "nil")")
                
                self.ayahLines = ayahs.map { $0.text }
                                self.pageText = self.extractTextWithVerseNumbers(from: ayahs)

//                self.pageText = self.extractTextWithVerseNumbers(from: baq)

                
                self.logger.debug("Processed page text: \(self.pageText)")
                self.logger.debug("Number of ayah lines: \(self.ayahLines.count)")
                
                self.currentPageAyahs = ayahs
                
                if let firstAyah = ayahs.first {
                    self.currentSurahName = "سُورَة \(firstAyah.surahName)"
                    self.logger.debug("Updated surah name to: \(self.currentSurahName)")
                }
                
                self.logger.info("Successfully loaded page \(page) with \(ayahs.count) ayahs")
            }
            .store(in: &cancellables)
    }
    
    func toArabicIndic(_ number: Int) -> String {
        String(number).toArabicIndic()
    }

    private func extractTextWithVerseNumbers(from ayahs: [AyahModel]) -> String {
        let text = ayahs.map { ayah in
            "\(ayah.text) \(toArabicIndic(ayah.numberInSurah))"
        }.joined(separator: " ")
        logger.debug("Extracted text with verse numbers: \(text)")
        return text
    }
} 
