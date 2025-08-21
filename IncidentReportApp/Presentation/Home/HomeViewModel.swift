//
//  HomeViewModel.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
@MainActor
@Observable
final class HomeViewModel {
    private let coordinator: AppCoordinator
    
    var currentUser: String? {
        coordinator.currentUser
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
}
