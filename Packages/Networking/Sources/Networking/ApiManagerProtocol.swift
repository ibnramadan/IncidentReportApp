//
//  ApiManagerProtocol.swift
//  Networking
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation

// MARK: - ApiManagerProtocol

/// Protocol defining the API manager interface
public protocol ApiManagerProtocol {
    /// Performs a network request and returns decoded data
    /// - Parameters:
    ///   - endpoint: The endpoint to call
    ///   - responseType: The type to decode the response into
    /// - Returns: Decoded response object
    func request<T: Decodable>(
        _ endpoint: ApiEndpoint,
        responseType: T.Type
    ) async throws -> T
    
    /// Performs a network request without expecting a response body
    /// - Parameter endpoint: The endpoint to call
    func request(_ endpoint: ApiEndpoint) async throws
    
    /// Performs a network request with custom headers
    /// - Parameters:
    ///   - endpoint: The endpoint to call
    ///   - headers: Additional headers for the request
    ///   - responseType: The type to decode the response into
    func request<T: Decodable>(
        _ endpoint: ApiEndpoint,
        headers: [String: String],
        responseType: T.Type
    ) async throws -> T
    
    /// Cancels all ongoing requests
    func cancelAllRequests()
    
    /// Sets authentication token for requests
    /// - Parameter token: The authentication token
    func setAuthToken(_ token: String?)
    
    func requestPlainString(_ endpoint: ApiEndpoint) async throws -> String

}
