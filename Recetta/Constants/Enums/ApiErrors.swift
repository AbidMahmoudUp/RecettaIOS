//
//  ApiErrors.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case serverError(Int)
    case decodingError
    case encodingError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .serverError(let statusCode): return "Server returned error code: \(statusCode)."
        case .decodingError: return "Failed to decode response."
        case .encodingError(let error): return "Failed to encode request body: \(error.localizedDescription)."
        case .unknown: return "An unknown error occurred."
        }
    }
}


