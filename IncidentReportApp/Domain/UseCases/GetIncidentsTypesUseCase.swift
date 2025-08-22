//
//  GetIncidentsTypesUseCase.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//


protocol GetIncidentTypesUseCaseProtocol {
    func execute() async throws -> [IncidentsTypeEntity]
}

final class GetIncidentTypesUseCase: GetIncidentTypesUseCaseProtocol {
    private let repo: IncidentsRepoProtocol
    
    init(repo: IncidentsRepoProtocol) {
        self.repo = repo
    }
    
    func execute() async throws -> [IncidentsTypeEntity] {
        do {  let response = try await repo.getIncidentsType()
            return response.map { $0.maptoEntity()
            }
        } catch {
            throw error
        }
    }
}
