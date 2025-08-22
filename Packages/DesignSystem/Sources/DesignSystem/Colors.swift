import SwiftUI

// MARK: - Color System
public struct Colors {
    public init() {}
}

// MARK: - Primary Colors
public extension Colors {
    static let primary = Color.blue
    static let secondary = Color.gray
}

// MARK: - Semantic Colors
public extension Colors {
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    static let errorLight = Color.red.opacity(0.1)
}

// MARK: - Background Colors
public extension Colors {
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
}

// MARK: - Text Colors
public extension Colors {
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textInverse = Color(.systemBackground)
}

// MARK: - Border Colors
public extension Colors {
    static let border = Color(.separator)
}

// MARK: - Status Colors
public extension Colors {
    static let statusPending = Color.orange
    static let statusInProgress = Color.blue
    static let statusResolved = Color.green
    static let statusClosed = Color.gray
}

// MARK: - Priority Colors
public extension Colors {
    static let priorityLow = Color.green
    static let priorityMedium = Color.yellow
    static let priorityHigh = Color.orange
    static let priorityCritical = Color.red
    static let priorityEmergency = Color.purple
    
    static func priorityColor(for level: Int) -> Color {
        switch level {
        case 1: return priorityLow
        case 2: return priorityMedium
        case 3: return priorityHigh
        case 4: return priorityCritical
        case 5: return priorityEmergency
        default: return priorityMedium
        }
    }
} 