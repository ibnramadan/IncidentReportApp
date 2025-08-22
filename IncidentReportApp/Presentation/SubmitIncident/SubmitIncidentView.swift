//
//  SubmitIncidentView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI
import DesignSystem

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
            .onAppear {
                if viewModel.incidentTypes.isEmpty {
                    Task {
                        await viewModel.loadIncidentTypes()
                    }
                }
            }
            .navigationTitle("New Incident")
            .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Main Content View
    
    private var mainContentView: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                loadingView
            } else {
                // Form Content
                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        descriptionSection
                        locationSection
                        typeSection
                        prioritySection
                    }
                    .padding()
                }
                
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
    
    // MARK: - Form Sections
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Description")
                .labelMedium()
                .foregroundColor(Colors.textPrimary)
            
            DSTextField(
                text: $viewModel.description,
                placeholder: "Enter incident description...",
                icon: "text.bubble",
            )
        }
        .padding()
        .background(Colors.secondaryBackground.opacity(0.5))
        .cornerRadius(Corners.lg)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Location")
                .labelMedium()
                .foregroundColor(Colors.textPrimary)
            
            Button(action: {
                viewModel.showingLocationPicker = true
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("GPS Coordinates")
                            .captionMedium()
                            .foregroundColor(Colors.textSecondary)
                        Text(viewModel.locationText)
                            .bodyMedium()
                            .foregroundColor(Colors.textPrimary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .captionMedium()
                        .foregroundColor(Colors.textSecondary)
                }
                .padding()
                .background(Colors.background)
                .cornerRadius(Corners.md)
                .overlay(
                    RoundedRectangle(cornerRadius: Corners.md)
                        .stroke(Colors.border, lineWidth: 1)
                )
            }
        }
        .padding()
        .background(Colors.secondaryBackground.opacity(0.5))
        .cornerRadius(Corners.lg)
    }
    
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Type")
                .labelMedium()
                .foregroundColor(Colors.textPrimary)
            
            Button(action: {
                viewModel.showingTypePicker = true
            }) {
                HStack {
                    if let selectedType = viewModel.selectedType {
                        Text(selectedType.englishName)
                            .bodyMedium()
                            .foregroundColor(Colors.textPrimary)
                    } else {
                        Text("Select incident type")
                            .bodyMedium()
                            .foregroundColor(Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .captionMedium()
                        .foregroundColor(Colors.textSecondary)
                }
                .padding()
                .background(Colors.background)
                .cornerRadius(Corners.md)
                .overlay(
                    RoundedRectangle(cornerRadius: Corners.md)
                        .stroke(Colors.border, lineWidth: 1)
                )
            }
        }
        .padding()
        .background(Colors.secondaryBackground.opacity(0.5))
        .cornerRadius(Corners.lg)
    }
    
    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Priority")
                .labelMedium()
                .foregroundColor(Colors.textPrimary)
            
            DSPrioritySelector(
                priority: $viewModel.priority,
                onPriorityChange: { newPriority in
                    viewModel.updatePriority(newPriority)
                }
            )
        }
        .padding()
        .background(Colors.secondaryBackground.opacity(0.5))
        .cornerRadius(Corners.lg)
    }
    
    // MARK: - Submit Button Section
    
    private var submitButtonSection: some View {
        VStack(spacing: Spacing.md) {
            if let errorMessage = viewModel.errorMessage {
                DSErrorView(
                    title: "Submission Error",
                    message: errorMessage,
                    style: .compact,
                    dismissAction: {
                        viewModel.errorMessage = nil
                    }
                )
                .padding(.horizontal)
            }
            
            DSButton(
                "Submit Incident",
                style: .primary, isLoading: viewModel.isSubmitting
            ) {
                Task {
                    await viewModel.submitIncident()
                }
            }
            .disabled(!viewModel.isFormValid)
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Colors.background)
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        DSLoadingView(
            message: "Loading incident types...",
            style: .spinner
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Success View
    
    private var successView: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            // Success Icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Colors.success)
            
            // Success Message
            VStack(spacing: Spacing.sm) {
                Text("Incident Submitted!")
                    .heading1()
                    .fontWeight(.bold)
                    .foregroundColor(Colors.textPrimary)
                
                if let incidentId = viewModel.submittedIncidentId {
                    Text("Incident ID: \(incidentId)")
                        .bodyMedium()
                        .foregroundColor(Colors.primary)
                }
                
                Text("Your incident has been successfully submitted and is now being processed.")
                    .bodyMedium()
                    .foregroundColor(Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Back to Home Button
            DSButton("Back to Home", style: .primary) {
                viewModel.goBackToHome()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Colors.background)
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
            HStack(spacing: Spacing.sm) {
                typeInfoView(type: type)
                
                Spacer()
                
                selectionIndicator(type: type)
            }
            .padding(.vertical, Spacing.xs)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func typeInfoView(type: IncidentsTypeEntity) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(type.englishName)
                .bodyMedium()
                .fontWeight(.medium)
                .foregroundColor(Colors.textPrimary)
        }
    }
    
    private func selectionIndicator(type: IncidentsTypeEntity) -> some View {
        Group {
            if viewModel.selectedType?.id == type.id {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Colors.primary)
            }
        }
    }
    
    // MARK: - Location Picker Sheet
    
    private var locationPickerSheet: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                Text("Enter GPS Coordinates")
                    .heading3()
                    .padding(.top)
                
                VStack(spacing: Spacing.md) {
                    HStack {
                        Text("Latitude:")
                            .frame(width: 80, alignment: .leading)
                            .labelMedium()
                        DSTextField(
                            text: Binding(
                                get: { String(format: "%.6f", viewModel.latitude) },
                                set: { if let value = Double($0) { viewModel.latitude = value } }
                            ),
                            placeholder: "0.000000",
                            keyboardType: .decimalPad
                        )
                    }
                    
                    HStack {
                        Text("Longitude:")
                            .frame(width: 80, alignment: .leading)
                            .labelMedium()
                        DSTextField(
                            text: Binding(
                                get: { String(format: "%.6f", viewModel.longitude) },
                                set: { if let value = Double($0) { viewModel.longitude = value } }
                            ),
                            placeholder: "0.000000",
                            keyboardType: .decimalPad
                        )
                    }
                }
                .padding(.horizontal)
                
                Text("Or use current location")
                    .captionMedium()
                    .foregroundColor(Colors.textSecondary)
                
                DSButton("Use Current Location", style: .secondary) {
                    // This would integrate with Core Location
                    // For now, set sample coordinates
                    viewModel.updateLocation(latitude: 37.7749, longitude: -122.4194)
                }
                
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
}
