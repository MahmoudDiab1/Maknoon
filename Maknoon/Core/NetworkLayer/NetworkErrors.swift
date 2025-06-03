//
//  NetworkErrors.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 01/06/2025.
//

import Foundation

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    case networkError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response type"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
 
