//
//  SubmitIncidentView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI
struct SubmitIncidentView: View {
    @State private var viewModel: SubmitIncidentViewModel
    @FocusState private var isDescriptionFocused: Bool
    
    init(viewModel: SubmitIncidentViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if viewModel.showingSuccessView {
                successView
            } else {
                mainContentView
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if viewModel.incidentTypes.isEmpty {
                Task {
                    await viewModel.loadIncidentTypes()
                }
            }
        }
    }
    
    // MARK: - Main Content View
    
    private var mainContentView: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            navigationBar
            
            if viewModel.isLoading {
                loadingView
            } else {
                // Form Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Description Section
                        descriptionSection
                        
                        // Location Section
                        locationSection
                        
                        // Type Section
                        typeSection
                        
                        // Priority Section
                        prioritySection
                        
                    }
                    .padding()
                }
                
                // Submit Button
                submitButtonSection
            }
        }
        .sheet(isPresented: $viewModel.showingTypePicker) {
            typePickerSheet
        }
        .sheet(isPresented: $viewModel.showingLocationPicker) {
            locationPickerSheet
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Navigation Bar
    
    private var navigationBar: some View {
        HStack {
            Button(action: {
                viewModel.dismissView()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(.body)
                }
                .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text("New Incident")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Invisible button for balance
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(.body)
                }
            }
            .opacity(0)
            .disabled(true)
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Form Sections
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Description", systemImage: "text.alignleft")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("Enter incident description...", text: $viewModel.description, axis: .vertical)
                .focused($isDescriptionFocused)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...6)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Location", systemImage: "location.fill")
                .font(.headline)
                .foregroundColor(.primary)
            
            Button(action: {
                viewModel.showingLocationPicker = true
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GPS Coordinates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.locationText)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Type", systemImage: "tag.fill")
                .font(.headline)
                .foregroundColor(.primary)
            
            Button(action: {
                viewModel.showingTypePicker = true
            }) {
                HStack {
                    if let selectedType = viewModel.selectedType {
                        HStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(selectedType.englishName)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                    } else {
                        Text("Select incident type")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Priority", systemImage: "exclamationmark.circle.fill")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text("Priority Level: \(viewModel.priority)")
                    .font(.body)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.updatePriority(viewModel.priority - 1)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(viewModel.priority > 1 ? .blue : .gray)
                    }
                    .disabled(viewModel.priority <= 1)
                    
                    Text("\(viewModel.priority)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 30)
                    
                    Button(action: {
                        viewModel.updatePriority(viewModel.priority + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(viewModel.priority < 5 ? .blue : .gray)
                    }
                    .disabled(viewModel.priority >= 5)
                }
            }
            
            // Priority scale indicator
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { level in
                    Rectangle()
                        .fill(level <= viewModel.priority ? priorityColor(for: level) : Color(.systemGray5))
                        .frame(height: 8)
                        .cornerRadius(4)
                }
            }
            
            Text("1 = Low, 5 = Critical")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    // MARK: - Submit Button Section
    
    private var submitButtonSection: some View {
        VStack(spacing: 16) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: {
                Task {
                    await viewModel.submitIncident()
                }
            }) {
                HStack {
                    if viewModel.isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.9)
                        Text("Submitting...")
                    } else {
                        Text("Submit Incident")
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.isFormValid && !viewModel.isSubmitting ? Color.blue : Color.gray)
                .cornerRadius(12)
            }
            .disabled(!viewModel.isFormValid || viewModel.isSubmitting)
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading incident types...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Success View
    
    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Success Icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            // Success Message
            VStack(spacing: 12) {
                Text("Incident Submitted!")
                    .font(.title)
                    .fontWeight(.bold)
                
                if let incidentId = viewModel.submittedIncidentId {
                    Text("Incident ID: \(incidentId)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("Your incident has been successfully submitted and is now being processed.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Back to Home Button
            Button(action: {
                viewModel.goBackToHome()
            }) {
                Text("Back to Home")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Type Picker Sheet
    
    private var typePickerSheet: some View {
        NavigationStack {
            List {
                ForEach(viewModel.incidentTypes) { type in
                    typeCell(type: type)
                }
            }
            .navigationTitle("Select Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        viewModel.showingTypePicker = false
                    }
                }
            }
        }
    }
    
    private func typeCell(type: IncidentsTypeEntity) -> some View {
        Button(action: {
            viewModel.selectIncidentType(type)
        }) {
            HStack(spacing: 12) {
                typeInfoView(type: type)
                
                Spacer()
                
                selectionIndicator(type: type)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func typeInfoView(type: IncidentsTypeEntity) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(type.englishName)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
    
    private func selectionIndicator(type: IncidentsTypeEntity) -> some View {
        Group {
            if viewModel.selectedType?.id == type.id {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Location Picker Sheet
    
    private var locationPickerSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter GPS Coordinates")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Latitude:")
                            .frame(width: 80, alignment: .leading)
                        TextField("0.000000", value: $viewModel.latitude, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Longitude:")
                            .frame(width: 80, alignment: .leading)
                        TextField("0.000000", value: $viewModel.longitude, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }
                }
                .padding(.horizontal)
                
                Text("Or use current location")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button("Use Current Location") {
                    // This would integrate with Core Location
                    // For now, set sample coordinates
                    viewModel.updateLocation(latitude: 37.7749, longitude: -122.4194)
                }
                .foregroundColor(.blue)
                
                Spacer()
            }
            .navigationTitle("Set Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.showingLocationPicker = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.showingLocationPicker = false
                    }
                    .disabled(viewModel.latitude == 0.0 || viewModel.longitude == 0.0)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func priorityColor(for level: Int) -> Color {
        switch level {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4: return .red
        case 5: return .purple
        default: return .gray
        }
    }
}

