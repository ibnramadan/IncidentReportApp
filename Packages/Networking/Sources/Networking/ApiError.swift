//
//  ApiError.swift
//  Networking
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
public enum ApiError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case networkError(Error)
    case unauthorized
    case noData
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response from server"
        case .statusCode(let code): return "HTTP error: \(code)"
        case .decodingError(let error): return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .unauthorized: return "Unauthorized access"
        case .noData: return "No data received"
        case .custom(let message): return message
        }
    }
}
