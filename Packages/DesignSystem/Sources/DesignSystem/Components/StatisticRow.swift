import SwiftUI

// MARK: - Statistic Row Component
public struct DSStatisticRow: View {
    public enum StatisticRowStyle {
        case standard
        case compact
        case detailed
    }
    
    private let title: String
    private let value: String
    private let subtitle: String?
    private let color: Color
    private let style: StatisticRowStyle
    private let action: (() -> Void)?
    
    public init(
        title: String,
        value: String,
        subtitle: String? = nil,
        color: Color = Colors.primary,
        style: StatisticRowStyle = .standard,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: Spacing.sm) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(titleFont)
                        .foregroundColor(Colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(subtitleFont)
                            .foregroundColor(Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                Text(value)
                    .font(valueFont)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            .padding(padding)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var titleFont: Font {
        switch style {
        case .standard:
            return Typography.bodyMedium
        case .compact:
            return Typography.bodySmall
        case .detailed:
            return Typography.labelLarge
        }
    }
    
    private var subtitleFont: Font {
        switch style {
        case .standard:
            return Typography.captionMedium
        case .compact:
            return Typography.captionSmall
        case .detailed:
            return Typography.bodySmall
        }
    }
    
    private var valueFont: Font {
        switch style {
        case .standard:
            return Typography.labelLarge
        case .compact:
            return Typography.labelMedium
        case .detailed:
            return Typography.heading3
        }
    }
    
    private var padding: CGFloat {
        switch style {
        case .standard:
            return Spacing.sm
        case .compact:
            return Spacing.xs
        case .detailed:
            return Spacing.md
        }
    }
}

// MARK: - Statistic Row Modifiers
public extension View {
    func dsStatisticRow(
        title: String,
        value: String,
        subtitle: String? = nil,
        color: Color = Colors.primary,
        style: DSStatisticRow.StatisticRowStyle = .standard,
        action: (() -> Void)? = nil
    ) -> some View {
        DSStatisticRow(
            title: title,
            value: value,
            subtitle: subtitle,
            color: color,
            style: style,
            action: action
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.sm) {
        DSStatisticRow(
            title: "Active Users",
            value: "1,234",
            subtitle: "45% of total",
            color: Colors.success
        )
        
        DSStatisticRow(
            title: "Revenue",
            value: "$12,345",
            subtitle: "+8% from last month",
            color: Colors.warning,
            style: .compact
        )
        
        DSStatisticRow(
            title: "Orders",
            value: "89",
            subtitle: "23 pending",
            color: Colors.info,
            style: .detailed
        ) {
            print("Order row tapped")
        }
    }
    .padding()
    .background(Colors.secondaryBackground)
} 