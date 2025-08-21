//
//  OTPUseCase.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//
import Foundation
import Networking
protocol OTPUseCaseProtocol {
    func execute(email: String, otp: String) async throws -> OtpEntity
}

struct OTPUseCase: OTPUseCaseProtocol {
    private let repo: IncidentsRepoProtocol
    
    init(repo: IncidentsRepoProtocol) {
        self.repo = repo
    }
    
    func execute(email: String, otp: String) async throws -> OtpEntity {
      let response = try await repo.verifyOtp(email: email, otp: otp)
        return response.mapToEntity()
    }
}
