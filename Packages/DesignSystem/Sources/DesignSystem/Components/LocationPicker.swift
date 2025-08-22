import SwiftUI

// MARK: - LocationPicker Component
public struct DSLocationPicker: View {
    @Binding private var isPresented: Bool
    @Binding private var latitude: Double
    @Binding private var longitude: Double
    private let onLocationSelected: (Double, Double) -> Void
    private let onUseCurrentLocation: (() -> Void)?
    
    public init(
        isPresented: Binding<Bool>,
        latitude: Binding<Double>,
        longitude: Binding<Double>,
        onLocationSelected: @escaping (Double, Double) -> Void,
        onUseCurrentLocation: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self._latitude = latitude
        self._longitude = longitude
        self.onLocationSelected = onLocationSelected
        self.onUseCurrentLocation = onUseCurrentLocation
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: Spacing.lg) {
                // Header
                VStack(spacing: Spacing.sm) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Colors.primary)
                    
                    Text("Enter GPS Coordinates")
                        .font(Typography.heading3)
                        .fontWeight(.semibold)
                        .foregroundColor(Colors.textPrimary)
                }
                .padding(.top, Spacing.lg)
                
                // Coordinate Input Fields
                VStack(spacing: Spacing.md) {
                    coordinateField(
                        title: "Latitude:",
                        value: $latitude,
                        placeholder: "0.000000"
                    )
                    
                    coordinateField(
                        title: "Longitude:",
                        value: $longitude,
                        placeholder: "0.000000"
                    )
                }
                .padding(.horizontal, Spacing.lg)
                
                // Use Current Location Option
                if let onUseCurrentLocation = onUseCurrentLocation {
                    VStack(spacing: Spacing.sm) {
                        Text("Or use current location")
                            .font(Typography.captionMedium)
                            .foregroundColor(Colors.textSecondary)
                        
                        DSButton(
                            "Use Current Location",
                            icon: "location.circle.fill",
                            style: .outline
                        ) {
                            onUseCurrentLocation()
                        }
                    }
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: Spacing.sm) {
                    DSButton(
                        "Done",
                        style: .primary
                    ) {
                        onLocationSelected(latitude, longitude)
                        isPresented = false
                    }
                    .disabled(latitude == 0.0 || longitude == 0.0)
                    
                    DSButton(
                        "Cancel",
                        style: .ghost
                    ) {
                        isPresented = false
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.lg)
            }
            .navigationTitle("Set Location")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    private func coordinateField(
        title: String,
        value: Binding<Double>,
        placeholder: String
    ) -> some View {
        HStack {
            Text(title)
                .font(Typography.bodyMedium)
                .foregroundColor(Colors.textPrimary)
                .frame(width: 80, alignment: .leading)
            
            DSTextField(
                text: Binding(
                    get: { String(format: "%.6f", value.wrappedValue) },
                    set: { newValue in
                        if let doubleValue = Double(newValue) {
                            value.wrappedValue = doubleValue
                        }
                    }
                ),
                placeholder: placeholder,
                keyboardType: .decimalPad
            )
        }
    }
}

// MARK: - LocationPicker Modifiers
public extension View {
    func dsLocationPicker(
        isPresented: Binding<Bool>,
        latitude: Binding<Double>,
        longitude: Binding<Double>,
        onLocationSelected: @escaping (Double, Double) -> Void,
        onUseCurrentLocation: (() -> Void)? = nil
    ) -> some View {
        DSLocationPicker(
            isPresented: isPresented,
            latitude: latitude,
            longitude: longitude,
            onLocationSelected: onLocationSelected,
            onUseCurrentLocation: onUseCurrentLocation
        )
    }
}

// MARK: - Preview
#Preview {
    DSLocationPicker(
        isPresented: .constant(true),
        latitude: .constant(37.7749),
        longitude: .constant(-122.4194)
    ) { lat, lon in
        print("Location selected: \(lat), \(lon)")
    } onUseCurrentLocation: {
        print("Use current location tapped")
    }
} 