//
//  HomeViewHelpers.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI
import DesignSystem

// MARK: - Home View Helper Methods
public struct HomeViewHelpers {
    
    public static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    public static func convertToIncidentData(_ incident: IncidentEntity) -> DSIncidentRowView.IncidentData {
        return DSIncidentRowView.IncidentData(
            id: incident.id,
            description: incident.description,
            status: "\(incident.status)",
            statusTitle: incident.statusEnum.title,
            statusIcon: incident.statusEnum.icon,
            statusColor: incident.statusEnum.color,
            createdDate: incident.createdDate,
            priority: incident.priority ?? 0
        )
    }
} 
