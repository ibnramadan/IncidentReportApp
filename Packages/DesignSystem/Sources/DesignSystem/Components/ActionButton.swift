//
//  ActionButton.swift
//  DesignSystem
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI

// MARK: - Action Button Component
public struct DSActionButton: View {
    public enum ActionButtonStyle {
        case primary
        case secondary
        case ghost
        case danger
    }
    
    private let icon: String
    private let color: Color
    private let style: ActionButtonStyle
    private let size: CGFloat
    private let action: () -> Void
    
    public init(
        icon: String,
        color: Color,
        style: ActionButtonStyle = .ghost,
        size: CGFloat = 44,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.color = color
        self.style = style
        self.size = size
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundColor(foregroundColor)
                .frame(width: size, height: size)
                .background(backgroundColor)
                .cornerRadius(size / 2)
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return color
        case .secondary:
            return color.opacity(0.1)
        case .ghost:
            return color.opacity(0.1)
        case .danger:
            return Colors.error.opacity(0.1)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return Colors.textInverse
        case .secondary:
            return color
        case .ghost:
            return color
        case .danger:
            return Colors.error
        }
    }
}

// MARK: - View Extension
public extension View {
    func dsActionButton(
        icon: String,
        color: Color,
        style: DSActionButton.ActionButtonStyle = .ghost,
        size: CGFloat = 44,
        action: @escaping () -> Void
    ) -> some View {
        DSActionButton(
            icon: icon,
            color: color,
            style: style,
            size: size,
            action: action
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        HStack(spacing: Spacing.sm) {
            DSActionButton(icon: "chart.bar.fill", color: Colors.primary) {}
            DSActionButton(icon: "plus.circle.fill", color: Colors.statusResolved) {}
            DSActionButton(icon: "trash.fill", color: Colors.error, style: .danger) {}
        }
        
        HStack(spacing: Spacing.sm) {
            DSActionButton(icon: "heart.fill", color: Colors.primary, style: .primary) {}
            DSActionButton(icon: "star.fill", color: Colors.statusPending, style: .secondary) {}
            DSActionButton(icon: "gear", color: Colors.textSecondary, size: 36) {}
        }
    }
    .padding()
} 