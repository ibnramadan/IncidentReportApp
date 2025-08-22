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
    var selectedDateFilter: DateFilter = .all
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
        
        // Filter by date
        filtered = filterByDate(filtered)
        
        filteredIncidents = filtered.sorted { $0.createdDate > $1.createdDate }
    }
    
    private func filterByDate(_ incidents: [IncidentEntity]) -> [IncidentEntity] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedDateFilter {
        case .all:
            return incidents
        case .today:
            return incidents.filter { calendar.isDate($0.createdDate, inSameDayAs: now) }
        case .thisWeek:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return incidents.filter { $0.createdDate >= weekAgo }
        case .thisMonth:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return incidents.filter { $0.createdDate >= monthAgo }
        case .custom:
            let startOfStartDate = calendar.startOfDay(for: customStartDate)
            let endOfEndDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: customEndDate)) ?? customEndDate
            return incidents.filter { incident in
                incident.createdDate >= startOfStartDate && incident.createdDate < endOfEndDate
            }
        }
    }
    
    func updateSearchText(_ text: String) {
        applyFilters()
    }
    
    func updateStatusFilter(_ status: IncidentStatus?) {
        selectedStatus = status
        applyFilters()
    }
    
    func updateDateFilter(_ dateFilter: DateFilter) {
        selectedDateFilter = dateFilter
        if dateFilter == .custom {
            showStartDatePicker = true
        }
        applyFilters()
    }
    
    func updateCustomStartDate(_ date: Date) {
        customStartDate = date
        selectedDateFilter = .custom
        showStartDatePicker = false
        // Ensure end date is not before start date
        if date > customEndDate {
            customEndDate = date
        }
        applyFilters()
    }
    
    func updateCustomEndDate(_ date: Date) {
        customEndDate = date
        selectedDateFilter = .custom
        showEndDatePicker = false
        applyFilters()
    }
    
    func updateCustomDateRange(start: Date, end: Date) {
        customStartDate = start
        customEndDate = end
        selectedDateFilter = .custom
        applyFilters()
    }
    
    func clearFilters() {
        selectedStatus = nil
        selectedDateFilter = .all
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
        if selectedDateFilter == .custom {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "\(formatter.string(from: customStartDate)) - \(formatter.string(from: customEndDate))"
        }
        return selectedDateFilter.title
    }
}

// MARK: - Updated Date Filter Enum

enum DateFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case custom = "Custom Range"
    
    var title: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .all: return "calendar"
        case .today: return "calendar.circle"
        case .thisWeek: return "calendar.badge.clock"
        case .thisMonth: return "calendar.badge.plus"
        case .custom: return "calendar.badge.exclamationmark"
        }
    }
}
