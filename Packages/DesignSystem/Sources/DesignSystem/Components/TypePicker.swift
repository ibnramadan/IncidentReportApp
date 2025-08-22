import SwiftUI

// MARK: - TypePicker Component
public struct DSTypePicker: View {
    @Binding private var isPresented: Bool
    private let types: [IncidentType]
    private let selectedType: IncidentType?
    private let onTypeSelected: (IncidentType) -> Void
    
    public init(
        isPresented: Binding<Bool>,
        types: [IncidentType],
        selectedType: IncidentType?,
        onTypeSelected: @escaping (IncidentType) -> Void
    ) {
        self._isPresented = isPresented
        self.types = types
        self.selectedType = selectedType
        self.onTypeSelected = onTypeSelected
    }
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(types) { type in
                    TypeCell(
                        type: type,
                        isSelected: selectedType?.id == type.id,
                        onTap: {
                            onTypeSelected(type)
                            isPresented = false
                        }
                    )
                }
            }
            .navigationTitle("Select Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// MARK: - Type Cell
private struct TypeCell: View {
    let type: IncidentType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.sm) {
                typeInfoView
                
                Spacer()
                
                selectionIndicator
            }
            .padding(.vertical, Spacing.xs)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var typeInfoView: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(type.name)
                .font(Typography.bodyMedium)
                .fontWeight(.medium)
                .foregroundColor(Colors.textPrimary)
            
            if let description = type.description {
                Text(description)
                    .font(Typography.captionMedium)
                    .foregroundColor(Colors.textSecondary)
            }
        }
    }
    
    private var selectionIndicator: some View {
        Group {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Colors.primary)
            }
        }
    }
}

// MARK: - Incident Type Model
public struct IncidentType: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let description: String?
    public let icon: String?
    public let color: Color?
    
    public init(
        id: String,
        name: String,
        description: String? = nil,
        icon: String? = nil,
        color: Color? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.color = color
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: IncidentType, rhs: IncidentType) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - TypePicker Modifiers
public extension View {
    func dsTypePicker(
        isPresented: Binding<Bool>,
        types: [IncidentType],
        selectedType: IncidentType?,
        onTypeSelected: @escaping (IncidentType) -> Void
    ) -> some View {
        DSTypePicker(
            isPresented: isPresented,
            types: types,
            selectedType: selectedType,
            onTypeSelected: onTypeSelected
        )
    }
}

// MARK: - Preview
#Preview {
    let sampleTypes = [
        IncidentType(
            id: "1",
            name: "Technical Issue",
            description: "Hardware or software problems",
            icon: "laptopcomputer",
            color: Colors.error
        ),
        IncidentType(
            id: "2",
            name: "Network Problem",
            description: "Connectivity or network issues",
            icon: "wifi",
            color: Colors.warning
        ),
        IncidentType(
            id: "3",
            name: "Security Incident",
            description: "Security breaches or threats",
            icon: "shield",
            color: Colors.error
        ),
        IncidentType(
            id: "4",
            name: "General Inquiry",
            description: "General questions or requests",
            icon: "questionmark.circle",
            color: Colors.info
        )
    ]
    
    return DSTypePicker(
        isPresented: .constant(true),
        types: sampleTypes,
        selectedType: sampleTypes.first
    ) { selectedType in
        print("Selected type: \(selectedType.name)")
    }
} 
