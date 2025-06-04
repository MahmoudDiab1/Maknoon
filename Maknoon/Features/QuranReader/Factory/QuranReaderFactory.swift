import Foundation
import SwiftUI

struct QuranReaderFactory {
    static func makeQuranReaderView(page: Int) -> some View {
        let viewModel = makeQuranReaderViewModel(page: page)
        viewModel.currentPage = page
        return QuranReaderView(viewModel: viewModel)
    }
    
    static func makeQuranReaderViewModel(page: Int) -> QuranReaderViewModel {
        let networkService = NetworkService()
        let api = QuranAPIImpl(networkService: networkService)
        return QuranReaderViewModel(api: api, currentPage: page)
    }
    
    static func makeQuranAPI() -> QuranAPI {
        let networkService = NetworkService()
        return QuranAPIImpl(networkService: networkService)
    }
    
    static func makeNetworkService() -> NetworkServiceProtocol {
        return NetworkService()
    }
} 
