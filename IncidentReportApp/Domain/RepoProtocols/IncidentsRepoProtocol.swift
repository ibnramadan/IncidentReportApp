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
}
