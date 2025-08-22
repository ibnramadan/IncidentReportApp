//
//  SubmitIncidentUseCase.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import Foundation
import Networking
protocol SubmitIncidentUseCaseProtocol {
    func execute(incident: IncidentRequestEntity) async throws -> IncidentEntity
}

struct SubmitIncidentUseCase: SubmitIncidentUseCaseProtocol {
    private let repo: IncidentsRepoProtocol
    
    init(repo: IncidentsRepoProtocol) {
        self.repo = repo
    }
    
    func execute(incident: IncidentRequestEntity) async throws -> IncidentEntity {
        
        let response = try await repo.submitIncident(incident: incident)
        return response.mapToEntity()
    }
}

