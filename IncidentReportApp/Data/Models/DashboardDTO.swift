//
//  DashboardDTO.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import Foundation

struct DashboardDTO: Codable {
    let incidents: [DashboardIncident]
}

struct DashboardIncident: Codable {
    let status: Int
    let count: Count

    enum CodingKeys: String, CodingKey {
        case status
        case count = "_count"
    }
    
    func mapToEntity() -> DashboardEntity {
        DashboardEntity(status: status, count: count.status)
    }
}

struct Count: Codable {
    let status: Int
}
