import SwiftUI

// MARK: - NavigationBar Component
public struct DSNavigationBar: View {
    public enum NavigationBarStyle {
        case standard
        case transparent
        case elevated
    }
    
    private let title: String
    private let leftButton: NavigationButton?
    private let rightButton: NavigationButton?
    private let style: NavigationBarStyle
    private let showShadow: Bool
    
    public init(
        title: String,
        leftButton: NavigationButton? = nil,
        rightButton: NavigationButton? = nil,
        style: NavigationBarStyle = .standard,
        showShadow: Bool = true
    ) {
        self.title = title
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.style = style
        self.showShadow = showShadow
    }
    
    public var body: some View {
        HStack {
            // Left Button
            if let leftButton = leftButton {
                Button(action: leftButton.action) {
                    HStack(spacing: Spacing.xs) {
                        if let icon = leftButton.icon {
                            Image(systemName: icon)
                                .font(.system(size: 16, weight: .medium))
                        }
                        if let text = leftButton.text {
                            Text(text)
                                .font(Typography.bodyMedium)
                        }
                    }
                    .foregroundColor(Colors.primary)
                }
            } else {
                Spacer()
                    .frame(width: 44)
            }
            
            Spacer()
            
            // Title
            Text(title)
                .font(Typography.heading2)
                .fontWeight(.semibold)
                .foregroundColor(Colors.textPrimary)
                .lineLimit(1)
            
            Spacer()
            
            // Right Button
            if let rightButton = rightButton {
                Button(action: rightButton.action) {
                    HStack(spacing: Spacing.xs) {
                        if let text = rightButton.text {
                            Text(text)
                                .font(Typography.bodyMedium)
                        }
                        if let icon = rightButton.icon {
                            Image(systemName: icon)
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                    .foregroundColor(Colors.primary)
                }
            } else {
                Spacer()
                    .frame(width: 44)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(backgroundColor)
        .shadow(color: showShadow ? Colors.border.opacity(0.1) : .clear, radius: 1, x: 0, y: 1)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .standard:
            return Colors.background
        case .transparent:
            return Color.clear
        case .elevated:
            return Colors.background
        }
    }
}

// MARK: - Navigation Button
public struct NavigationButton {
    public let text: String?
    public let icon: String?
    public let action: () -> Void
    
    public init(text: String? = nil, icon: String? = nil, action: @escaping () -> Void) {
        self.text = text
        self.icon = icon
        self.action = action
    }
    
    public static func back(action: @escaping () -> Void) -> NavigationButton {
        NavigationButton(
            text: "Back",
            icon: "chevron.left",
            action: action
        )
    }
    
    public static func close(action: @escaping () -> Void) -> NavigationButton {
        NavigationButton(
            icon: "xmark",
            action: action
        )
    }
    
    public static func done(action: @escaping () -> Void) -> NavigationButton {
        NavigationButton(
            text: "Done",
            action: action
        )
    }
    
    public static func cancel(action: @escaping () -> Void) -> NavigationButton {
        NavigationButton(
            text: "Cancel",
            action: action
        )
    }
    
    public static func save(action: @escaping () -> Void) -> NavigationButton {
        NavigationButton(
            text: "Save",
            action: action
        )
    }
    
    public static func edit(action: @escaping () -> Void) -> NavigationButton {
        NavigationButton(
            icon: "pencil",
            action: action
        )
    }
    
    public static func refresh(action: @escaping () -> Void) -> NavigationButton {
        NavigationButton(
            icon: "arrow.clockwise",
            action: action
        )
    }
}

// MARK: - NavigationBar Modifiers
public extension View {
    func dsNavigationBar(
        title: String,
        leftButton: NavigationButton? = nil,
        rightButton: NavigationButton? = nil,
        style: DSNavigationBar.NavigationBarStyle = .standard,
        showShadow: Bool = true
    ) -> some View {
        DSNavigationBar(
            title: title,
            leftButton: leftButton,
            rightButton: rightButton,
            style: style,
            showShadow: showShadow
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 0) {
        DSNavigationBar(
            title: "Dashboard",
            rightButton: .refresh { print("Refresh tapped") }
        )
        
        DSNavigationBar(
            title: "New Incident",
            leftButton: .back { print("Back tapped") },
            rightButton: .save { print("Save tapped") }
        )
        
        DSNavigationBar(
            title: "Settings",
            leftButton: .close { print("Close tapped") },
            rightButton: .edit { print("Edit tapped") }
        )
        
        DSNavigationBar(
            title: "Profile",
            style: .transparent,
            showShadow: false
        )
    }
    .background(Colors.secondaryBackground)
} 
