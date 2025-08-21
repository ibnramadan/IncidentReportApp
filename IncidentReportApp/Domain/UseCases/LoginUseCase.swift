//
//  LoginUseCase.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
import Networking
protocol LoginUseCaseProtocol {
    func execute(email: String) async throws -> String
}

struct LoginUseCase: LoginUseCaseProtocol {
    private let repo: IncidentsRepoProtocol
    
    init(repo: IncidentsRepoProtocol) {
        self.repo = repo
    }
    
    func execute(email: String) async throws -> String {
        let response: String = try await repo.login(email: email)
        guard response.uppercased() == "OK" else {
            throw ApiError.custom("Login failed: \(response)")
        }
        return response
    }
}
