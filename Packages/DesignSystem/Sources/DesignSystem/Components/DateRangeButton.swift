//
//  DateRangeButton.swift
//  DesignSystem
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI

// MARK: - Date Range Button Component
public struct DSDateRangeButton: View {
    private let label: String
    private let date: Date
    private let isSelected: Bool
    private let action: () -> Void
    
    public init(
        label: String,
        date: Date,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.date = date
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(label)
                    .captionMedium()
                    .foregroundColor(Colors.textSecondary)
                Text(formatDate(date))
                    .bodyMedium()
                    .fontWeight(.medium)
                    .foregroundColor(Colors.textPrimary)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Colors.primary.opacity(0.1) : Colors.secondaryBackground)
            .cornerRadius(Corners.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - View Extension
public extension View {
    func dsDateRangeButton(
        label: String,
        date: Date,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        DSDateRangeButton(
            label: label,
            date: date,
            isSelected: isSelected,
            action: action
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        HStack(spacing: Spacing.sm) {
            DSDateRangeButton(
                label: "From",
                date: Date(),
                isSelected: true
            ) {}
            
            DSDateRangeButton(
                label: "To",
                date: Date().addingTimeInterval(86400 * 7)
            ) {}
        }
        
        HStack(spacing: Spacing.sm) {
            DSDateRangeButton(
                label: "Start Date",
                date: Date()
            ) {}
            
            DSDateRangeButton(
                label: "End Date",
                date: Date().addingTimeInterval(86400 * 30)
            ) {}
        }
    }
    .padding()
} 