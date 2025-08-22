//
//  SubmitIncidentViewModel.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import Foundation
@MainActor
@Observable
final class SubmitIncidentViewModel {
    private let coordinator: AppCoordinator
    private let getIncidentTypesUseCase: GetIncidentTypesUseCaseProtocol
    private let submitIncidentUseCase: SubmitIncidentUseCaseProtocol
    
    // Form State
    var description: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var selectedType: IncidentsTypeEntity?
    var priority: Int = 1
    
    // UI State
    var incidentTypes: [IncidentsTypeEntity] = []
    var isLoading: Bool = false
    var isSubmitting: Bool = false
    var errorMessage: String?
    var showingTypePicker: Bool = false
    var showingLocationPicker: Bool = false
    var showingSuccessView: Bool = false
    var submittedIncidentId: String?
    
    // Location
    var locationText: String {
        if latitude == 0.0 && longitude == 0.0 {
            return "Tap to set location"
        }
        return "\(String(format: "%.6f", latitude)), \(String(format: "%.6f", longitude))"
    }
    
    // Validation
    var isFormValid: Bool {
        !description.trimmedString.isEmpty &&
        selectedType != nil &&
        latitude != 0.0 &&
        longitude != 0.0 &&
        priority >= 1 && priority <= 5
    }
    
    init(coordinator: AppCoordinator, getIncidentTypesUseCase: GetIncidentTypesUseCaseProtocol, submitIncidentUseCase: SubmitIncidentUseCaseProtocol) {
        self.coordinator = coordinator
        self.getIncidentTypesUseCase = getIncidentTypesUseCase
        self.submitIncidentUseCase = submitIncidentUseCase
    }
    
    // Convenience initializer
    convenience init(coordinator: AppCoordinator, repo: IncidentsRepoProtocol) {
        self.init(
            coordinator: coordinator,
            getIncidentTypesUseCase: GetIncidentTypesUseCase(repo: repo),
            submitIncidentUseCase: SubmitIncidentUseCase(repo: repo)
        )
    }
    
    func loadIncidentTypes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            incidentTypes = try await getIncidentTypesUseCase.execute()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func submitIncident() async {
        guard isFormValid else { return }
        
        isSubmitting = true
        errorMessage = nil
        
        do {
            let incidentRequest = IncidentRequestEntity(
                description: description.trimmedString,
                latitude: latitude,
                longitude: longitude,
                status: 0,
                priority: priority,
                typeId: selectedType!.id
            )
            
            let submittedIncident = try await submitIncidentUseCase.execute(incident: incidentRequest)
            submittedIncidentId = submittedIncident.id
            isSubmitting = false
            showingSuccessView = true
        } catch {
            errorMessage = error.localizedDescription
            isSubmitting = false
        }
    }
    
    func updateLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func selectIncidentType(_ type: IncidentsTypeEntity) {
        selectedType = type
        showingTypePicker = false
    }
    
    func updatePriority(_ newPriority: Int) {
        priority = max(1, min(5, newPriority))
    }
    
    func resetForm() {
        description = ""
        latitude = 0.0
        longitude = 0.0
        selectedType = nil
        priority = 1
        errorMessage = nil
        submittedIncidentId = nil
    }
    
    func goBackToHome() {
        showingSuccessView = false
        coordinator.navigateBack()
    }
    
    func dismissView() {
        coordinator.navigateBack()
    }
}
