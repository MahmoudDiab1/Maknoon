//
//  QuranAPIError.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 01/06/2025.
//

import Foundation

enum QuranAPIError: LocalizedError {
   case invalidURL
   case networkError(Error)
   case decodingError(Error)
   case apiError(String)
   case unknown
   
   var errorDescription: String? {
       switch self {
       case .invalidURL:
           return "Invalid URL"
       case .networkError(let error):
           return "Network error: \(error.localizedDescription)"
       case .decodingError(let error):
           return "Failed to decode response: \(error.localizedDescription)"
       case .apiError(let message):
           return "API error: \(message)"
       case .unknown:
           return "An unknown error occurred"
       }
   }
}
