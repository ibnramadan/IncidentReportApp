//
//  IncidentReportAppApp.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import SwiftUI
import Coordinator

@main
struct IncidentReportAppApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    @StateObject private var dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environmentObject(appCoordinator)
                .environmentObject(dependencies)
        }
    }
}
