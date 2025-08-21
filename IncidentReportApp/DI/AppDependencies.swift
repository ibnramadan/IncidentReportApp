//
//  AppDependencies.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//
import SwiftUI
import Networking

class AppDependencies: ObservableObject {
    lazy var apiManager: ApiManagerProtocol = {
        ApiManager()
    }()
    
    lazy var incidentsRepo: IncidentsRepoProtocol = {
        IncidentsRepo(apiManager: apiManager)
    }()
}
