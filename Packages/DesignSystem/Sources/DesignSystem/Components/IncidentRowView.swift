//
//  IncidentRowView.swift
//  DesignSystem
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI

// MARK: - Incident Row View Component
public struct DSIncidentRowView: View {
    public struct IncidentData {
        public let id: String
        public let description: String
        public let status: String
        public let statusTitle: String
        public let statusIcon: String
        public let statusColor: Color
        public let createdDate: Date
        public let priority: Int
        
        public init(
            id: String,
            description: String,
            status: String,
            statusTitle: String,
            statusIcon: String,
            statusColor: Color,
            createdDate: Date,
            priority: Int
        ) {
            self.id = id
            self.description = description
            self.status = status
            self.statusTitle = statusTitle
            self.statusIcon = statusIcon
            self.statusColor = statusColor
            self.createdDate = createdDate
            self.priority = priority
        }
    }
    
    private let incident: IncidentData
    private let onTap: (() -> Void)?
    
    public init(
        incident: IncidentData,
        onTap: (() -> Void)? = nil
    ) {
        self.incident = incident
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(incident.id)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text(incident.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            Image(systemName: incident.statusIcon)
                            Text(incident.statusTitle)
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(incident.statusColor.opacity(0.2))
                        .foregroundColor(incident.statusColor)
                        .cornerRadius(8)
                        
                        Text(formatDate(incident.createdDate))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - View Extension
public extension View {
    func dsIncidentRowView(
        incident: DSIncidentRowView.IncidentData,
        onTap: (() -> Void)? = nil
    ) -> some View {
        DSIncidentRowView(
            incident: incident,
            onTap: onTap
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        DSIncidentRowView(
            incident: DSIncidentRowView.IncidentData(
                id: "INC-001",
                description: "Network connectivity issue affecting multiple users in the office building",
                status: "pending",
                statusTitle: "Pending",
                statusIcon: "clock.fill",
                statusColor: .orange,
                createdDate: Date(),
                priority: 3
            )
        )
        
        DSIncidentRowView(
            incident: DSIncidentRowView.IncidentData(
                id: "INC-002",
                description: "Software bug causing application crashes",
                status: "in_progress",
                statusTitle: "In Progress",
                statusIcon: "arrow.triangle.2.circlepath",
                statusColor: .blue,
                createdDate: Date().addingTimeInterval(-3600),
                priority: 4
            )
        )
        
        DSIncidentRowView(
            incident: DSIncidentRowView.IncidentData(
                id: "INC-003",
                description: "Hardware failure in server room",
                status: "resolved",
                statusTitle: "Resolved",
                statusIcon: "checkmark.circle.fill",
                statusColor: .green,
                createdDate: Date().addingTimeInterval(-7200),
                priority: 5
            )
        )
    }
    .padding()
} 