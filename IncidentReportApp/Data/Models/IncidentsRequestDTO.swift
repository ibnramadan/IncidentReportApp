//
//  IncidentsRequestDTO.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

struct IncidentsRequestDTO: Codable {
    let description: String
    let latitude: Double
    let longitude: Double
    let status: Int
    let priority: Int?
    let typeId: Int
    let issuerId: String
}
