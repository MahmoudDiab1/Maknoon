import Foundation
import SwiftUI

final class QuranReaderFactory {
    static func makeQuranReaderView() -> some View {
        let networkService = NetworkService()
        let api = QuranAPIImpl(networkService: networkService)
        let viewModel = QuranReaderViewModel(api: api)
        return QuranReaderView(viewModel: viewModel)
    }
    
    static func makeQuranReaderViewModel() -> QuranReaderViewModel {
        let networkService = NetworkService()
        let api = QuranAPIImpl(networkService: networkService)
        return QuranReaderViewModel(api: api)
    }
    
    static func makeQuranAPI() -> QuranAPI {
        let networkService = NetworkService()
        return QuranAPIImpl(networkService: networkService)
    }
    
    static func makeNetworkService() -> NetworkServiceProtocol {
        return NetworkService()
    }
} 