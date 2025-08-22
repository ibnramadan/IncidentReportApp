//
//  DashboardViewModel.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import Foundation

@MainActor
@Observable
final class DashboardViewModel {
    private let coordinator: AppCoordinator
    private let getDashboardUseCase: DashboardUseCaseProtocol
    
    // State
    var dashboardEntities: [DashboardEntity] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    var currentUser: String? {
        coordinator.currentUser
    }
    
    var totalIncidents: Int {
        dashboardEntities.reduce(0) { $0 + $1.count }
    }
    
    init(coordinator: AppCoordinator, repo: IncidentsRepoProtocol) {
        self.coordinator = coordinator
        self.getDashboardUseCase = DashboardUseCase(repo: repo)
    }
    
    func loadDashboard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            dashboardEntities = try await getDashboardUseCase.execute()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func refreshDashboard() async {
        await loadDashboard()
    }
    
    // Helper methods for chart data
    func getPercentage(for entity: DashboardEntity) -> Double {
        guard totalIncidents > 0 else { return 0 }
        return Double(entity.count) / Double(totalIncidents) * 100
    }
    
    func getFormattedPercentage(for entity: DashboardEntity) -> String {
        let percentage = getPercentage(for: entity)
        return String(format: "%.1f%%", percentage)
    }
}
