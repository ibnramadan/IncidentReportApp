//
//  ApiConstants.swift
//  Networking
//
//  Created by mohamed ramadan on 21/08/2025.
//


import Foundation

public enum ApiConstants {
    /// Base URL for all API requests
    public static let baseURL = "https://ba4caf56-6e45-4662-bbfb-20878b8cd42e.mock.pstmn.io" // Replace with your actual base URL
    
    /// Common headers
    public enum Headers {
        public static let contentType = "Content-Type"
        public static let authorization = "Authorization"
        public static let accept = "Accept"
        public static let userAgent = "User-Agent"
    }
    
    /// Header values
    public enum HeaderValues {
        public static let applicationJson = "application/json"
        public static let bearer = "Bearer"
    }
    
    /// Timeout intervals
    public enum Timeout {
        public static let request: TimeInterval = 30
        public static let resource: TimeInterval = 60
    }
    
    /// API paths
    public enum Paths {
        public static let login = "/login"
        public static let verifyOtp = "/verify-otp"
        public static let getIncidentList = "/incident"
    }
}
