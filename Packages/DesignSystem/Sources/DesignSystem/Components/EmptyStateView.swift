import SwiftUI

// MARK: - EmptyStateView Component
public struct DSEmptyStateView: View {
    public enum EmptyStateStyle {
        case standard
        case compact
        case fullscreen
    }
    
    private let icon: String
    private let title: String
    private let message: String
    private let style: EmptyStateStyle
    private let actionTitle: String?
    private let action: (() -> Void)?
    
    public init(
        icon: String,
        title: String,
        message: String,
        style: EmptyStateStyle = .standard,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.style = style
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: spacing) {
            Image(systemName: icon)
                .font(.system(size: iconSize))
                .foregroundColor(Colors.textSecondary)
            
            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(titleFont)
                    .fontWeight(.semibold)
                    .foregroundColor(Colors.textPrimary)
                
                Text(message)
                    .font(messageFont)
                    .foregroundColor(Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                DSButton(actionTitle, style: .primary) {
                    action()
                }
            }
        }
        .padding(padding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var spacing: CGFloat {
        switch style {
        case .standard:
            return Spacing.md
        case .compact:
            return Spacing.sm
        case .fullscreen:
            return Spacing.lg
        }
    }
    
    private var iconSize: CGFloat {
        switch style {
        case .standard:
            return 60
        case .compact:
            return 40
        case .fullscreen:
            return 100
        }
    }
    
    private var titleFont: Font {
        switch style {
        case .standard:
            return Typography.heading3
        case .compact:
            return Typography.labelLarge
        case .fullscreen:
            return Typography.heading1
        }
    }
    
    private var messageFont: Font {
        switch style {
        case .standard:
            return Typography.bodyMedium
        case .compact:
            return Typography.bodySmall
        case .fullscreen:
            return Typography.bodyLarge
        }
    }
    
    private var padding: CGFloat {
        switch style {
        case .standard:
            return Spacing.lg
        case .compact:
            return Spacing.md
        case .fullscreen:
            return Spacing.xxl
        }
    }
}

// MARK: - EmptyStateView Modifiers
public extension View {
    func dsEmptyStateView(
        icon: String,
        title: String,
        message: String,
        style: DSEmptyStateView.EmptyStateStyle = .standard,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        DSEmptyStateView(
            icon: icon,
            title: title,
            message: message,
            style: style,
            actionTitle: actionTitle,
            action: action
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        DSEmptyStateView(
            icon: "tray",
            title: "No Data",
            message: "No data available at the moment",
            actionTitle: "Refresh"
        ) {
            print("Refresh tapped")
        }
        
        DSEmptyStateView(
            icon: "magnifyingglass",
            title: "No Results",
            message: "Try adjusting your search criteria",
            style: .compact
        )
        
        DSEmptyStateView(
            icon: "chart.bar",
            title: "No Analytics Data",
            message: "Analytics data will appear here once you start using the app.",
            style: .fullscreen,
            actionTitle: "Get Started"
        ) {
            print("Get Started tapped")
        }
    }
    .padding()
} 