//
//  IncidentEntity.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import Foundation
import SwiftUI

public struct IncidentEntity: Identifiable {
    public let id: String
    let description: String
    let latitude: Double
    let longitude: Double
    let status: Int
    let priority: Int?
    let typeId: Int
    let issuerId: String
    let assigneeId: String?
    let createdAt: String
    let updatedAt: String
    
    var statusEnum: IncidentStatus {
        IncidentStatus(rawValue: status) ?? .submitted
    }
    
    var createdDate: Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: createdAt) ?? Date()
    }
    
    var updatedDate: Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: updatedAt) ?? Date()
    }
}

struct IncidentMediaEntity: Identifiable {
    let id: String
    let mimeType: String
    let url: String
    let type: Int
    let incidentId: String
}

