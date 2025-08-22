//
//  IncidentDTO.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import Foundation

struct IncidentsDTO: Codable {
    let incidents: [IncidentDTO]
}

struct IncidentDTO: Codable, Identifiable {
    let id: String?
    let description: String?
    let latitude: Double?
    let longitude: Double?
    let status: Int?
    let priority: Int?
    let typeId: Int?
    let issuerId: String?
    let assigneeId: String?
    let createdAt: String?
    let updatedAt: String?
    let medias: [IncidentMedia]?
    
    func mapToEntity() -> IncidentEntity {
        return IncidentEntity(id: id ?? "", description: description ?? "", latitude: latitude ?? 0, longitude: longitude ?? 0, status: status ?? 0, priority: priority ?? 0, typeId: typeId ?? 0, issuerId: issuerId ?? "", assigneeId: assigneeId ?? "", createdAt: createdAt ?? "", updatedAt: updatedAt ?? "")
    }
}

struct IncidentMedia: Codable, Identifiable {
    let id: String?
    let mimeType: String?
    let url: String?
    let type: Int?
    let incidentId: String?
}

