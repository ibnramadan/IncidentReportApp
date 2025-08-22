//
//  ChangeIncidentStatusUseCase.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//
import Foundation
import Networking
protocol ChangeIncidentStatusUseCaseProtocol {
    func execute(incidentId: String, status: Int) async throws -> IncidentEntity
}

struct ChangeIncidentStatusUseCase: ChangeIncidentStatusUseCaseProtocol {
    private let repo: IncidentsRepoProtocol
    
    init(repo: IncidentsRepoProtocol) {
        self.repo = repo
    }
    
    func execute(incidentId: String, status: Int) async throws -> IncidentEntity {
        let response = try await repo.changeIncidentStatus(id: incidentId, status: status)
        return response.mapToEntity()
    }
}

