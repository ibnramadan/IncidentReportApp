import SwiftUI

// MARK: - Card Component
public struct DSCard<Content: View>: View {
    public enum CardStyle {
        case standard
        case elevated
        case outlined
        case filled
    }
    
    private let style: CardStyle
    private let padding: CGFloat
    private let content: Content
    
    public init(
        style: CardStyle = .standard,
        padding: CGFloat = Spacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(Corners.lg)
            .overlay(
                RoundedRectangle(cornerRadius: Corners.lg)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(shadow)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .standard, .elevated:
            return Colors.background
        case .outlined:
            return Colors.background
        case .filled:
            return Colors.secondaryBackground
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .standard, .elevated, .filled:
            return Color.clear
        case .outlined:
            return Colors.border
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outlined:
            return 1
        default:
            return 0
        }
    }
    
    private var shadow: Shadow {
        switch style {
        case .standard:
            return Shadows.xs
        case .elevated:
            return Shadows.md
        case .outlined, .filled:
            return Shadows.none
        }
    }
}

// MARK: - Card Modifiers
public extension View {
    func dsCard(
        style: DSCard<AnyView>.CardStyle = .standard,
        padding: CGFloat = Spacing.md
    ) -> some View {
        DSCard(style: style, padding: padding) {
            AnyView(self)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Standard Card")
                    .heading3()
                Text("This is a standard card with default styling")
                    .bodyMedium()
                    .foregroundColor(Colors.textSecondary)
            }
        }
        
        DSCard(style: .elevated) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Elevated Card")
                    .heading3()
                Text("This card has elevated shadow")
                    .bodyMedium()
                    .foregroundColor(Colors.textSecondary)
            }
        }
        
        DSCard(style: .outlined) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Outlined Card")
                    .heading3()
                Text("This card has an outline border")
                    .bodyMedium()
                    .foregroundColor(Colors.textSecondary)
            }
        }
        
        DSCard(style: .filled) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Filled Card")
                    .heading3()
                Text("This card has a filled background")
                    .bodyMedium()
                    .foregroundColor(Colors.textSecondary)
            }
        }
    }
    .padding()
} 
