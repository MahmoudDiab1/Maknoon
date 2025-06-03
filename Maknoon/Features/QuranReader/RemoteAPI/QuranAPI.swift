import Foundation
import Combine
import os.log

protocol QuranAPI {
    func fetchPageAyahs(page: Int) -> AnyPublisher<[AyahModel], Error>
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

final class QuranAPIImpl: QuranAPI {
    private let networkService: NetworkServiceProtocol
    private let logger = Logger(subsystem: "com.maknoon.quran", category: "API")
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPageAyahs(page: Int) -> AnyPublisher<[AyahModel], Error> {
        logger.debug("Making API request for page \(page)")
        
        return networkService.request(QuranRouter.fetchPage(page: page), type: PageResponse.self)
            .map { response -> [AyahModel] in
                response.data.ayahs.map { ayah in
                    AyahModel(
                        number: ayah.number,
                        text: ayah.text,
                        numberInSurah: ayah.numberInSurah,
                        juz: ayah.juz,
                        manzil: ayah.manzil,
                        page: ayah.page,
                        ruku: ayah.ruku,
                        hizbQuarter: ayah.hizbQuarter,
                        sajda: ayah.sajda,
                        surahNumber: response.data.number,
                        surahName: ayah.surah.name
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
