//
//  DashboardEntity.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

struct DashboardEntity: Identifiable {
    let status: Int
    let count: Int
    
    var id: Int { status }
    
    var statusEnum: IncidentStatus {
        IncidentStatus(rawValue: status) ?? .inProgress
       }
}

