import SwiftUI

// MARK: - Summary Card Component
public struct DSSummaryCard: View {
    public enum SummaryCardStyle {
        case standard
        case elevated
        case outlined
    }
    
    private let title: String
    private let value: String
    private let subtitle: String?
    private let icon: String?
    private let color: Color
    private let style: SummaryCardStyle
    
    public init(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String? = nil,
        color: Color = Colors.primary,
        style: SummaryCardStyle = .standard
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.style = style
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(Typography.captionLarge)
                        .foregroundColor(Colors.textSecondary)
                    
                    Text(value)
                        .font(Typography.heading2)
                        .fontWeight(.bold)
                        .foregroundColor(Colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(Typography.captionMedium)
                            .foregroundColor(Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
            }
        }
        .padding(Spacing.md)
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
        case .standard:
            return Colors.background
        case .elevated:
            return Colors.background
        case .outlined:
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .standard:
            return Color.clear
        case .elevated:
            return Color.clear
        case .outlined:
            return Colors.border
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .standard, .elevated:
            return 0
        case .outlined:
            return 1
        }
    }
    
    private var shadow: Shadow {
        switch style {
        case .standard:
            return Shadows.xs
        case .elevated:
            return Shadows.md
        case .outlined:
            return Shadows.none
        }
    }
}

// MARK: - Summary Card Modifiers
public extension View {
    func dsSummaryCard(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String? = nil,
        color: Color = Colors.primary,
        style: DSSummaryCard.SummaryCardStyle = .standard
    ) -> some View {
        DSSummaryCard(
            title: title,
            value: value,
            subtitle: subtitle,
            icon: icon,
            color: color,
            style: style
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        HStack(spacing: Spacing.sm) {
            DSSummaryCard(
                title: "Total Users",
                value: "1,234",
                subtitle: "+12% from last month",
                icon: "person.3.fill",
                color: Colors.primary
            )
            
            DSSummaryCard(
                title: "Active Users",
                value: "567",
                subtitle: "45% of total",
                icon: "person.fill",
                color: Colors.success
            )
        }
        
        HStack(spacing: Spacing.sm) {
            DSSummaryCard(
                title: "Revenue",
                value: "$12,345",
                subtitle: "+8% from last month",
                icon: "dollarsign.circle.fill",
                color: Colors.warning,
                style: .elevated
            )
            
            DSSummaryCard(
                title: "Orders",
                value: "89",
                subtitle: "23 pending",
                icon: "bag.fill",
                color: Colors.info,
                style: .outlined
            )
        }
    }
    .padding()
} 
