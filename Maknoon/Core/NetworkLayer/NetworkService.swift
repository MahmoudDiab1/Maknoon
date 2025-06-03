//
//  NetworkService.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 01/06/2025.
// 

import Foundation
import Combine
import os.log

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ router: Router, type: T.Type) -> AnyPublisher<T, Error>
}

final class NetworkService: NetworkServiceProtocol {
    private let logger = Logger(subsystem: "com.maknoon.quran", category: "Network")
    
    func request<T: Decodable>(_ router: Router, type: T.Type) -> AnyPublisher<T, Error> {
        guard let request = router.asURLRequest() else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        logger.debug("Making request to URL: \(request.url?.absoluteString ?? "unknown")")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .handleEvents(receiveOutput: { [weak self] data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    self?.logger.debug("Raw response: \(jsonString)")
                }
            })
            .decode(type: type, decoder: JSONDecoder())
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.logger.debug("Starting request to \(request.url?.absoluteString ?? "unknown")")
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.logger.error("Request failed: \(error.localizedDescription)")
                } else {
                    self?.logger.debug("Request completed successfully")
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
