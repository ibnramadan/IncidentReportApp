//
//  HomeViewModel.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
import Coordinator
@MainActor
@Observable
final class HomeViewModel {
    private let coordinator: AppCoordinator
    private let getIncidentsUseCase: GetIncidentsUseCaseProtocol
    private let changeIncidentStatusUseCase: ChangeIncidentStatusUseCaseProtocol
    // State
    var incidents: [IncidentEntity] = []
    var filteredIncidents: [IncidentEntity] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    // Filters
    var selectedStatus: IncidentStatus?
    var customStartDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    var customEndDate: Date = Date()
    var showStartDatePicker: Bool = false
    var showEndDatePicker: Bool = false
    
    var currentUser: String? {
        coordinator.currentUser
    }
    
    var authToken: String? {
        coordinator.authToken
    }
    
    init(coordinator: AppCoordinator, getIncidentsUseCase: GetIncidentsUseCaseProtocol, changeIncidentStatusUseCase: ChangeIncidentStatusUseCaseProtocol) {
        self.coordinator = coordinator
        self.getIncidentsUseCase = getIncidentsUseCase
        self.changeIncidentStatusUseCase = changeIncidentStatusUseCase
    }
    
    // Convenience initializer
    convenience init(coordinator: AppCoordinator, repo: IncidentsRepoProtocol) {
        self.init(coordinator: coordinator, getIncidentsUseCase: GetIncidentsUseCase(repo: repo), changeIncidentStatusUseCase: ChangeIncidentStatusUseCase(repo: repo))
    }
    
    func loadIncidents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            incidents = try await getIncidentsUseCase.execute()
            applyFilters()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func applyFilters() {
        var filtered = incidents
        
        // Filter by status
        if let status = selectedStatus {
            filtered = filtered.filter { $0.status == status.rawValue }
        }
        
        filteredIncidents = filtered.sorted { $0.createdDate > $1.createdDate }
    }
    
    func updateSearchText(_ text: String) {
        applyFilters()
    }
    
    func updateStatusFilter(_ status: IncidentStatus?) {
        selectedStatus = status
        applyFilters()
    }
    
    func updateCustomStartDate(_ date: Date) {
        customStartDate = date
        showStartDatePicker = false
        // Ensure end date is not before start date
        if date > customEndDate {
            customEndDate = date
        }
        applyFilters()
    }
    
    func updateCustomEndDate(_ date: Date) {
        customEndDate = date
        showEndDatePicker = false
        applyFilters()
    }
    
    func updateCustomDateRange(start: Date, end: Date) {
        customStartDate = start
        customEndDate = end
        applyFilters()
    }
    
    func clearFilters() {
        selectedStatus = nil
        customStartDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        customEndDate = Date()
        applyFilters()
    }
    
    func toggleStartDatePicker() {
        showStartDatePicker.toggle()
    }
    
    func toggleEndDatePicker() {
        showEndDatePicker.toggle()
    }
    
    func openDashboard() {
        coordinator.navigateToDashboard()
    }
    
    func openNewIncident() {
        coordinator.navigateToSubmitIncident()
    }
    
    func updateIncidentStatus(incident: IncidentEntity, newStatus: IncidentStatus) async {
        if let index = incidents.firstIndex(where: { $0.id == incident.id }) {
            do { try await incidents[index] = changeIncidentStatusUseCase.execute(incidentId: incident.id, status: newStatus.rawValue)
            } catch {
                print(error)
            }
        }
        applyFilters()
    }
    
    func refreshIncidents() async {
        await loadIncidents()
    }
    
    func logout() {
        coordinator.logout()
    }
    
    // Formatted date range for display
    var dateRangeText: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "\(formatter.string(from: customStartDate)) - \(formatter.string(from: customEndDate))"
    }
}
