//
//  ApiEndpoint.swift
//  Networking
//
//  Created by mohamed ramadan on 21/08/2025.
//


import Foundation

/// Represents an API endpoint
public struct ApiEndpoint {
    let path: String
    let method: HttpMethod
    let parameters: [String: Any]?
    let body: Data?
    let queryItems: [URLQueryItem]?
    
    public init(
        path: String,
        method: HttpMethod = .get,
        parameters: [String: Any]? = nil,
        body: Data? = nil,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.body = body
        self.queryItems = queryItems
    }
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
}
