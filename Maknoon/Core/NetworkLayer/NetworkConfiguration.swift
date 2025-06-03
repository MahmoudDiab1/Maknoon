//
//  NetworkConfiguration.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 01/06/2025.
//

import Foundation

struct NetworkConfiguration {
    static let shared = NetworkConfiguration()
    
    let baseURL = "https://api.alquran.cloud/v1"
    let timeoutInterval: TimeInterval = 30
    let resourceTimeoutInterval: TimeInterval = 300
    let cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
    
    var defaultHeaders: [String: String] {
        [
            "Accept": "application/json; charset=utf-8",
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
    
    var sessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = resourceTimeoutInterval
        configuration.waitsForConnectivity = true
        return configuration
    }
    
    private init() {}
}

