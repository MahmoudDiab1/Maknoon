import Foundation

protocol Router {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum QuranRouter: Router {
    case fetchPage(page: Int)
    case fetchSurah(surahNumber: Int)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.alquran.cloud"
    }
    
    var path: String {
        switch self {
        case .fetchPage(let page):
            return "/v1/page/\(page)/quran-uthmani"
        case .fetchSurah(let surahNumber):
            return "/v1/surah/\(surahNumber)/ar.alafasy"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPage, .fetchSurah:
            return .get
        }
    }
    
    var queryParameters: [URLQueryItem]? {
        switch self {
        case .fetchPage, .fetchSurah:
            return nil
        }
    }
    
    var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}

extension Router {
    func asURLRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryParameters
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryParameters
        return components.url
    }
} 