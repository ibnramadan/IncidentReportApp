//
//  GetIncidentsUseCase.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

protocol GetIncidentsUseCaseProtocol {
    func execute() async throws -> [IncidentEntity]
}

class GetIncidentsUseCase: GetIncidentsUseCaseProtocol {
    private let repo: IncidentsRepoProtocol
    
    init(repo: IncidentsRepoProtocol) {
        self.repo = repo
    }
    
    func execute() async throws -> [IncidentEntity] {
        let response = try await repo.getIncidents()
        return response.incidents.map { $0.mapToEntity() }
    }
}
