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
        let data = ["email": email]
        let body = try ApiManager.createBody(from: data)
        
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.login,
            method: .post,
            body: body
        )
        
        return try await apiManager.requestPlainString(endpoint)
    }
    
    func verifyOtp(email: String, otp: String) async throws -> OtpDTO {
        let data = ["email": email, "otp": otp]
        let body = try ApiManager.createBody(from: data)
        
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.verifyOtp,
            method: .post,
            body: body
        )
        
        return try await apiManager.request(endpoint,responseType: OtpDTO.self)
    }
    
    func getIncidents() async throws -> IncidentsDTO {
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.incidents,
            method: .get,
            body: nil
        )
        
        return try await apiManager.request(endpoint, responseType: IncidentsDTO.self)
    }
    
    func changeIncidentStatus(id: String, status: Int) async throws -> IncidentDTO {
        let data = ChangeIncidentStatusDTO(incidentId: id, status: status)
        let body = try ApiManager.createBody(from: data)
        
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.changeIncidentStatus,
            method: .put,
            body: body
        )
        
        return try await apiManager.request(endpoint,responseType: IncidentDTO.self)
    }
    
    func dashboard() async throws -> DashboardDTO {
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.dashboard,
            method: .get,
            body: nil
        )
        
        return try await apiManager.request(endpoint, responseType: DashboardDTO.self)
    }
    
    func submitIncident(incident: IncidentRequestEntity) async throws -> IncidentDTO {
        let requestData = IncidentsRequestDTO(description: incident.description, latitude: incident.latitude, longitude: incident.longitude, status: incident.status, priority: incident.priority, typeId: incident.typeId)
        let body = try ApiManager.createBody(from: requestData)
        
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.verifyOtp,
            method: .post,
            body: body
        )
        
        return try await apiManager.request(endpoint,responseType: IncidentDTO.self)
    }
    
    func getIncidentsType() async throws -> [IncidentsTypeDTO] {
        let endpoint = ApiEndpoint(
            path: ApiConstants.Paths.incidentsType,
            method: .get,
            body: nil
        )
        
        return try await apiManager.request(endpoint, responseType: [IncidentsTypeDTO].self)
    }
}
