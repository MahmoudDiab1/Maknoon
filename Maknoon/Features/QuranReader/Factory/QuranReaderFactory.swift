import Foundation
import SwiftUI

struct QuranReaderFactory {
    static func makeQuranReaderView(page: Int) -> some View {
        let viewModel = makeQuranReaderViewModel(page: page)
        return QuranReaderView(viewModel: viewModel)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
    
    static func makeQuranReaderViewModel(page: Int) -> QuranReaderViewModel {
        let networkService = NetworkService()
        let api = QuranAPIImpl(networkService: networkService)
        let viewModel = QuranReaderViewModel(api: api, currentPage: page)
        viewModel.currentPage = page
        return viewModel
    }
    
    static func makeQuranAPI() -> QuranAPI {
        let networkService = NetworkService()
        return QuranAPIImpl(networkService: networkService)
    }
    
    static func makeNetworkService() -> NetworkServiceProtocol {
        return NetworkService()
    }
} 
