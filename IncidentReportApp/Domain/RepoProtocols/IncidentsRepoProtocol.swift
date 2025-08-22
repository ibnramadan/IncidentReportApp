//
//  IncidentsRepoProtocol.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
protocol IncidentsRepoProtocol {
    func login(email: String) async throws -> String
    func verifyOtp(email: String, otp: String) async throws -> OtpDTO
    func getIncidents() async throws -> IncidentsDTO
    func changeIncidentStatus(id: String, status: Int) async throws -> IncidentDTO
    func dashboard() async throws -> DashboardDTO
    func submitIncident(incident: IncidentRequestEntity) async throws -> IncidentDTO
    func getIncidentsType() async throws -> [IncidentsTypeDTO]
}
