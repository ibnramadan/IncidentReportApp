//
//  AppCoordinatorView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//


import SwiftUI
import Coordinator

struct AppCoordinatorView: View {
    @EnvironmentObject private var appCoordinator: AppCoordinator
    @EnvironmentObject private var dependencies: AppDependencies
    
    var body: some View {
        CoordinatorView(coordinator: appCoordinator) {
            initialView
        } destination: { route in
            destinationView(for: route)
        }
    }
    
    @ViewBuilder
    private var initialView: some View {
        if appCoordinator.isAuthenticated {
            HomeView(viewModel: HomeViewModel(coordinator: appCoordinator))
        } else {
            LoginView(viewModel: LoginViewModel(repo: dependencies.incidentsRepo, coordinator: appCoordinator))
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView(viewModel: HomeViewModel(coordinator: appCoordinator))
        case .login:
            LoginView(viewModel: LoginViewModel(repo: dependencies.incidentsRepo, coordinator: appCoordinator))
        case .otp(let email):
            OTPView(viewModel: OTPViewModel(email: email, repo: dependencies.incidentsRepo, coordinator: appCoordinator))
        }
    }
}
