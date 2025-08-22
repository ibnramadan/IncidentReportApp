//
//  IncidentStatus.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI
enum IncidentStatus: Int, CaseIterable {
    case submitted = 0
    case inProgress = 1
    case completed = 2
    case rejected = 3
    
    var title: String {
        switch self {
        case .submitted: return "Submitted"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .rejected: return "Rejected"
        }
    }
    
    var color: Color {
        switch self {
        case .submitted: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        case .rejected: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .submitted: return "paperplane.fill"
        case .inProgress: return "clock.fill"
        case .completed: return "checkmark.circle.fill"
        case .rejected: return "xmark.circle.fill"
        }
    }
}
