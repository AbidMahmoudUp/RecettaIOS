//
//  ApiErrors.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation

enum ApiError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case other(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse: return "Invalid response from server."
        case .serverError(let code): return "Server error with status code \(code)."
        case .decodingError: return "Failed to decode the response."
        case .other(let error): return error.localizedDescription
        }
    }
}
