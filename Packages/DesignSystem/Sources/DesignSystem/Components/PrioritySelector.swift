import SwiftUI

// MARK: - PrioritySelector Component
public struct DSPrioritySelector: View {
    @Binding private var priority: Int
    private let minPriority: Int
    private let maxPriority: Int
    private let showLabels: Bool
    private let onPriorityChange: (Int) -> Void
    
    public init(
        priority: Binding<Int>,
        minPriority: Int = 1,
        maxPriority: Int = 5,
        showLabels: Bool = true,
        onPriorityChange: @escaping (Int) -> Void = { _ in }
    ) {
        self._priority = priority
        self.minPriority = minPriority
        self.maxPriority = maxPriority
        self.showLabels = showLabels
        self.onPriorityChange = onPriorityChange
    }
    
    public var body: some View {
        VStack(spacing: Spacing.md) {
            // Priority Display
            HStack {
                Text("Priority Level: \(priority)")
                    .font(Typography.bodyMedium)
                    .foregroundColor(Colors.textPrimary)
                
                Spacer()
                
                // Priority Controls
                HStack(spacing: Spacing.md) {
                    Button(action: {
                        updatePriority(priority - 1)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(priority > minPriority ? Colors.primary : Colors.textSecondary)
                    }
                    .disabled(priority <= minPriority)
                    
                    Text("\(priority)")
                        .font(Typography.heading3)
                        .fontWeight(.semibold)
                        .frame(width: 30)
                        .foregroundColor(Colors.priorityColor(for: priority))
                    
                    Button(action: {
                        updatePriority(priority + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(priority < maxPriority ? Colors.primary : Colors.textSecondary)
                    }
                    .disabled(priority >= maxPriority)
                }
            }
            
            // Priority Scale Indicator
            VStack(spacing: Spacing.xs) {
                HStack(spacing: Spacing.xs) {
                    ForEach(minPriority...maxPriority, id: \.self) { level in
                        Rectangle()
                            .fill(level <= priority ? Colors.priorityColor(for: level) : Colors.secondaryBackground)
                            .frame(height: 8)
                            .cornerRadius(Corners.xs)
                    }
                }
                
                if showLabels {
                    HStack {
                        Text("\(minPriority) = Low")
                            .font(Typography.captionSmall)
                            .foregroundColor(Colors.textSecondary)
                        
                        Spacer()
                        
                        Text("\(maxPriority) = Critical")
                            .font(Typography.captionSmall)
                            .foregroundColor(Colors.textSecondary)
                    }
                }
            }
            
            // Priority Description
            priorityDescription
        }
        .padding(Spacing.md)
        .background(Colors.secondaryBackground.opacity(0.5))
        .cornerRadius(Corners.lg)
    }
    
    @ViewBuilder
    private var priorityDescription: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(priorityDescriptionText)
                .font(Typography.labelMedium)
                .fontWeight(.medium)
                .foregroundColor(Colors.priorityColor(for: priority))
            
            Text(priorityDescriptionText)
                .font(Typography.captionMedium)
                .foregroundColor(Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.sm)
        .background(Colors.priorityColor(for: priority).opacity(0.1))
        .cornerRadius(Corners.md)
    }
    
    private var priorityTitle: String {
        switch priority {
        case 1: return "Low Priority"
        case 2: return "Medium Priority"
        case 3: return "High Priority"
        case 4: return "Critical Priority"
        case 5: return "Emergency Priority"
        default: return "Unknown Priority"
        }
    }
    
    private var priorityDescriptionText: String {
        switch priority {
        case 1: return "Minor issues that don't affect operations"
        case 2: return "Issues that should be addressed soon"
        case 3: return "Important issues requiring attention"
        case 4: return "Critical issues affecting operations"
        case 5: return "Emergency situations requiring immediate action"
        default: return "Unknown priority level"
        }
    }
    
    private func updatePriority(_ newPriority: Int) {
        let clampedPriority = max(minPriority, min(maxPriority, newPriority))
        priority = clampedPriority
        onPriorityChange(clampedPriority)
    }
}

// MARK: - PrioritySelector Modifiers
public extension View {
    func dsPrioritySelector(
        priority: Binding<Int>,
        minPriority: Int = 1,
        maxPriority: Int = 5,
        showLabels: Bool = true,
        onPriorityChange: @escaping (Int) -> Void = { _ in }
    ) -> some View {
        DSPrioritySelector(
            priority: priority,
            minPriority: minPriority,
            maxPriority: maxPriority,
            showLabels: showLabels,
            onPriorityChange: onPriorityChange
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        DSPrioritySelector(
            priority: .constant(3)
        ) { newPriority in
            print("Priority changed to: \(newPriority)")
        }
        
        DSPrioritySelector(
            priority: .constant(1),
            showLabels: false
        ) { newPriority in
            print("Priority changed to: \(newPriority)")
        }
        
        DSPrioritySelector(
            priority: .constant(5),
            minPriority: 1,
            maxPriority: 3
        ) { newPriority in
            print("Priority changed to: \(newPriority)")
        }
    }
    .padding()
} 
