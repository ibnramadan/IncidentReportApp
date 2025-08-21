//
//  IncidentsRepo.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
import Networking

class IncidentsRepo: IncidentsRepoProtocol {
    private let apiManager: ApiManagerProtocol
    
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func login(email: String) async throws -> String {
        let userData = ["email": email]
        let body = try ApiManager.createBody(from: userData)
        
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.login,
            method: .post,
            body: body
        )
        
        return try await apiManager.requestPlainString(endpoint)
    }
    
    func verifyOtp(email: String, otp: String) async throws -> OtpDTO {
        let userData = ["email": email, "otp": otp]
        let body = try ApiManager.createBody(from: userData)
        
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.verifyOtp,
            method: .post,
            body: body
        )
        
        return try await apiManager.request(endpoint,responseType: OtpDTO.self)
    }
    
}
