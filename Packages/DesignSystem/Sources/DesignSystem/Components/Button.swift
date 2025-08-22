import SwiftUI

// MARK: - Button Component
public struct DSButton: View {
    public enum ButtonStyle {
        case primary
        case secondary
        case outline
        case ghost
        case danger
        case success
    }
    
    public enum ButtonSize {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 44
            case .large: return 52
            }
        }
        
        var fontSize: Font {
            switch self {
            case .small: return Typography.labelSmall
            case .medium: return Typography.labelMedium
            case .large: return Typography.labelLarge
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return Spacing.sm
            case .medium: return Spacing.md
            case .large: return Spacing.lg
            }
        }
    }
    
    private let title: String
    private let icon: String?
    private let style: ButtonStyle
    private let size: ButtonSize
    private let isLoading: Bool
    private let isDisabled: Bool
    private let action: () -> Void
    
    public init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        size: ButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(size.fontSize)
                    }
                    
                    Text(title)
                        .font(size.fontSize)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .padding(.horizontal, size.padding)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(Corners.md)
            .overlay(
                RoundedRectangle(cornerRadius: Corners.md)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity((isDisabled || isLoading) ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
    
    private var backgroundColor: Color {
        if isDisabled {
            return Colors.secondaryBackground
        }
        
        switch style {
        case .primary:
            return Colors.primary
        case .secondary:
            return Colors.secondaryBackground
        case .outline:
            return Colors.background
        case .ghost:
            return Color.clear
        case .danger:
            return Colors.error
        case .success:
            return Colors.success
        }
    }
    
    private var textColor: Color {
        if isDisabled {
            return Colors.textSecondary
        }
        
        switch style {
        case .primary, .danger, .success:
            return Colors.textInverse
        case .secondary, .outline, .ghost:
            return Colors.textPrimary
        }
    }
    
    private var borderColor: Color {
        if isDisabled {
            return Colors.border
        }
        
        switch style {
        case .primary, .secondary, .ghost, .danger, .success:
            return Color.clear
        case .outline:
            return Colors.border
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline:
            return 1
        default:
            return 0
        }
    }
}

// MARK: - Button Modifiers
public extension View {
    func dsButton(
        _ title: String,
        icon: String? = nil,
        style: DSButton.ButtonStyle = .primary,
        size: DSButton.ButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        DSButton(
            title,
            icon: icon,
            style: style,
            size: size,
            isLoading: isLoading,
            isDisabled: isDisabled,
            action: action
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        DSButton("Primary Button", style: .primary) {}
        DSButton("Secondary Button", style: .secondary) {}
        DSButton("Outline Button", style: .outline) {}
        DSButton("Ghost Button", style: .ghost) {}
        DSButton("Danger Button", style: .danger) {}
        DSButton("Success Button", style: .success) {}
        DSButton("Loading Button", isLoading: true) {}
        DSButton("Disabled Button", isDisabled: true) {}
    }
    .padding()
} 
