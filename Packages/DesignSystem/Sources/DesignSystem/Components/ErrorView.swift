import SwiftUI

// MARK: - Error View Component
public struct DSErrorView: View {
    public enum ErrorStyle {
        case standard
        case compact
        case fullscreen
    }
    
    private let title: String
    private let message: String
    private let icon: String
    private let style: ErrorStyle
    private let retryAction: (() -> Void)?
    private let dismissAction: (() -> Void)?
    
    public init(
        title: String,
        message: String,
        icon: String = "exclamationmark.triangle.fill",
        style: ErrorStyle = .standard,
        retryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.style = style
        self.retryAction = retryAction
        self.dismissAction = dismissAction
    }
    
    public var body: some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: iconSize))
                .foregroundColor(Colors.error)
            
            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(titleFont)
                    .fontWeight(.semibold)
                    .foregroundColor(Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(messageFont)
                    .foregroundColor(Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: Spacing.sm) {
                if let retryAction = retryAction {
                    DSButton("Try Again", icon: "arrow.clockwise", style: .primary) {
                        retryAction()
                    }
                }
                
                if let dismissAction = dismissAction {
                    DSButton("Dismiss", style: .ghost) {
                        dismissAction()
                    }
                }
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(Corners.lg)
        .overlay(
            RoundedRectangle(cornerRadius: Corners.lg)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    private var iconSize: CGFloat {
        switch style {
        case .standard:
            return 48
        case .compact:
            return 32
        case .fullscreen:
            return 80
        }
    }
    
    private var titleFont: Font {
        switch style {
        case .standard:
            return Typography.heading3
        case .compact:
            return Typography.labelMedium
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
            return Spacing.md
        case .compact:
            return Spacing.sm
        case .fullscreen:
            return Spacing.lg
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .standard, .compact:
            return Colors.errorLight
        case .fullscreen:
            return Colors.background
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .standard, .compact:
            return Colors.errorLight
        case .fullscreen:
            return Colors.background
        }
    }
}

// MARK: - Error View Modifiers
public extension View {
    func dsErrorView(
        title: String,
        message: String,
        icon: String = "exclamationmark.triangle.fill",
        style: DSErrorView.ErrorStyle = .standard,
        retryAction: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) -> some View {
        DSErrorView(
            title: title,
            message: message,
            icon: icon,
            style: style,
            retryAction: retryAction,
            dismissAction: dismissAction
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        DSErrorView(
            title: "Connection Error",
            message: "Unable to connect to the server. Please check your internet connection.",
            retryAction: {
                print("Retry tapped")
            }
        )
        
        DSErrorView(
            title: "Something went wrong",
            message: "An unexpected error occurred.",
            style: .compact,
            dismissAction: {
                print("Dismiss tapped")
            }
        )
        
        DSErrorView(
            title: "Critical Error",
            message: "The application encountered a critical error and needs to restart.",
            icon: "xmark.octagon.fill",
            style: .fullscreen,
            retryAction: {
                print("Retry tapped")
            },
            dismissAction: {
                print("Dismiss tapped")
            }
        )
    }
    .padding()
} 