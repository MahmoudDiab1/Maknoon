import Foundation

// MARK: - API Models
struct APIQuranPage: Codable {
    let pageNumber: Int
    let surahName: String
    let juzNumber: Int
    let hizbNumber: Int
    let text: String
}

// MARK: - Domain Models
struct QuranPage {
    let pageNumber: Int
    let surahName: String
    let juzNumber: Int
    let hizbNumber: Int
    let text: String
}

// MARK: - Adapter Protocol
protocol QuranDataAdapterProtocol {
    func adaptToDomain(apiModel: APIQuranPage) -> QuranPage
    func adaptToAPI(domainModel: QuranPage) -> APIQuranPage
}

// MARK: - Concrete Adapter
final class QuranDataAdapter: QuranDataAdapterProtocol {
    func adaptToDomain(apiModel: APIQuranPage) -> QuranPage {
        return QuranPage(
            pageNumber: apiModel.pageNumber,
            surahName: apiModel.surahName,
            juzNumber: apiModel.juzNumber,
            hizbNumber: apiModel.hizbNumber,
            text: apiModel.text
        )
    }
    
    func adaptToAPI(domainModel: QuranPage) -> APIQuranPage {
        return APIQuranPage(
            pageNumber: domainModel.pageNumber,
            surahName: domainModel.surahName,
            juzNumber: domainModel.juzNumber,
            hizbNumber: domainModel.hizbNumber,
            text: domainModel.text
        )
    }
} 