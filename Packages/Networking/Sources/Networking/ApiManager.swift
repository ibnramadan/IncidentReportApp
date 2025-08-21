//
//  ApiManager.swift
//  Networking
//
//  Created by mohamed ramadan on 21/08/2025.
//


import Foundation

/// Concrete implementation of ApiManagerProtocol
public final class ApiManager: ApiManagerProtocol {
    
    // MARK: - Properties
    
    private let session: URLSession
    private var authToken: String?
    private var defaultHeaders: [String: String]
    
    private var ongoingTasks: [URLSessionTask] = []
    private let taskQueue = DispatchQueue(label: "com.network.apimanager.tasks", attributes: .concurrent)
    
    // MARK: - Initialization
    
    public init(
        session: URLSession = .shared,
        defaultHeaders: [String: String] = [:]
    ) {
        self.session = session
        self.defaultHeaders = defaultHeaders
        
        // Set common headers
        self.defaultHeaders[ApiConstants.Headers.contentType] = ApiConstants.HeaderValues.applicationJson
        self.defaultHeaders[ApiConstants.Headers.accept] = ApiConstants.HeaderValues.applicationJson
        
    }
    
    // MARK: - Public Methods
    
    public func request<T: Decodable>(
        _ endpoint: ApiEndpoint,
        responseType: T.Type
    ) async throws -> T {
        return try await performRequest(endpoint, responseType: responseType)
    }
    
    public func request(_ endpoint: ApiEndpoint) async throws {
        let _: EmptyResponse = try await performRequest(endpoint, responseType: EmptyResponse.self)
    }
    
    public func request<T: Decodable>(
        _ endpoint: ApiEndpoint,
        headers: [String: String],
        responseType: T.Type
    ) async throws -> T {
        return try await performRequest(endpoint, customHeaders: headers, responseType: responseType)
    }
    
    public func cancelAllRequests() {
        taskQueue.sync(flags: .barrier) {
            ongoingTasks.forEach { $0.cancel() }
            ongoingTasks.removeAll()
        }
    }
    
    public func setAuthToken(_ token: String?) {
        self.authToken = token
        if let token = token {
            defaultHeaders[ApiConstants.Headers.authorization] = "\(ApiConstants.HeaderValues.bearer) \(token)"
        } else {
            defaultHeaders.removeValue(forKey: ApiConstants.Headers.authorization)
        }
    }
    
    // MARK: - Private Methods
    
    private func performRequest<T: Decodable>(
        _ endpoint: ApiEndpoint,
        customHeaders: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        let request = try createRequest(from: endpoint, customHeaders: customHeaders)
        
        let task: URLSessionTask = session.dataTask(with: request)
        
        // Track the task
        taskQueue.sync(flags: .barrier) {
            ongoingTasks.append(task)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Remove task from tracking
            taskQueue.sync(flags: .barrier) {
                ongoingTasks.removeAll { $0 == task }
            }
            
            try validateResponse(response)
            
            // Handle empty response for types that don't expect data
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            
            guard !data.isEmpty else {
                throw ApiError.noData
            }
            
            do {
                return try decodeData(data, as: T.self)
            } catch {
                throw ApiError.decodingError(error)
            }
            
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError.networkError(error)
        }
    }
    
    private func createRequest(
        from endpoint: ApiEndpoint,
        customHeaders: [String: String]? = nil
    ) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: ApiConstants.baseURL) else {
            throw ApiError.invalidURL
        }
        
        urlComponents.path = urlComponents.path.appending(endpoint.path)
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = ApiConstants.Timeout.request
        
        // Set headers
        var allHeaders = defaultHeaders
        customHeaders?.forEach { allHeaders[$0.key] = $0.value }
        allHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Set body if provided
        if let body = endpoint.body {
            request.httpBody = body
        } else if let parameters = endpoint.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return // Success
        case 401, 403:
            throw ApiError.unauthorized
        default:
            throw ApiError.statusCode(httpResponse.statusCode)
        }
    }
    
    private func decodeData<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601 // Handle ISO 8601 dates
        return try decoder.decode(type, from: data)
    }
}

// MARK: - Convenience Extensions

public extension ApiManager {
    /// Convenience method for creating JSON body from encodable object
    static func createBody<T: Encodable>(from object: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(object)
    }
    
    /// Convenience method for creating query items from dictionary
    static func createQueryItems(from parameters: [String: Any]?) -> [URLQueryItem]? {
        guard let parameters = parameters else { return nil }
        
        return parameters.map { key, value in
            URLQueryItem(
                name: key,
                value: String(describing: value)
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            )
        }
    }
}

public extension ApiManager {
    func requestPlainString(_ endpoint: ApiEndpoint) async throws -> String {
        let request = try createRequest(from: endpoint)
        
        let task: URLSessionTask = session.dataTask(with: request)
        
        // Track the task
        taskQueue.sync(flags: .barrier) {
            ongoingTasks.append(task)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Remove task from tracking
            taskQueue.sync(flags: .barrier) {
                ongoingTasks.removeAll { $0 == task }
            }
            
            try validateResponse(response)
            
            guard let string = String(data: data, encoding: .utf8) else {
                throw ApiError.decodingError(NSError(domain: "StringDecoding", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot convert response to string"]))
            }
            
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError.networkError(error)
        }
    }
}
