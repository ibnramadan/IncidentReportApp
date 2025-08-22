//
//  DashboardUseCase.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

protocol DashboardUseCaseProtocol {
    func execute() async throws -> [DashboardEntity]
}

class DashboardUseCase: DashboardUseCaseProtocol {
    private let repo: IncidentsRepoProtocol
    
    init(repo: IncidentsRepoProtocol) {
        self.repo = repo
    }
    
    func execute() async throws -> [DashboardEntity] {
        let response = try await repo.dashboard()
        return response.incidents.map { $0.mapToEntity() }
    }
}
