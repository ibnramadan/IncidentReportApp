//
//  HomeView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import SwiftUI
import DesignSystem

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with user info
                headerView
                
                // Status Tabs and Date Filter
                filtersView
                
                // Content
                if viewModel.isLoading && viewModel.incidents.isEmpty {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage: errorMessage)
                } else if viewModel.filteredIncidents.isEmpty {
                    emptyStateView
                } else {
                    incidentsList
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .refreshable {
                await viewModel.refreshIncidents()
            }
            .onAppear {
                if viewModel.incidents.isEmpty {
                    Task {
                        await viewModel.loadIncidents()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showStartDatePicker) {
                NavigationStack {
                    VStack {
                        DatePicker(
                            "",
                            selection: $viewModel.customStartDate,
                            in: ...viewModel.customEndDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        
                        Spacer()
                    }
                    .navigationTitle("Select Start Date")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                viewModel.showStartDatePicker = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                viewModel.updateCustomStartDate(viewModel.customStartDate)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showEndDatePicker) {
                NavigationStack {
                    VStack {
                        DatePicker(
                            "",
                            selection: $viewModel.customEndDate,
                            in: viewModel.customStartDate...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        
                        Spacer()
                    }
                    .navigationTitle("Select End Date")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                viewModel.showEndDatePicker = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                viewModel.updateCustomEndDate(viewModel.customEndDate)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Incidents")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let user = viewModel.currentUser {
                        Text("Logged in as: \(user)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 12) {
                    // Dashboard Button
                    Button(action: {
                        viewModel.openDashboard()
                    }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(22)
                    }
                    
                    // New Incident Button
                    Button(action: {
                        viewModel.openNewIncident()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.green)
                            .frame(width: 44, height: 44)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(22)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private var filtersView: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Status")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All",
                            isSelected: viewModel.selectedStatus == nil
                        ) {
                            viewModel.updateStatusFilter(nil)
                        }
                        
                        ForEach(IncidentStatus.allCases, id: \.self) { status in
                            FilterChip(
                                title: status.title,
                                isSelected: viewModel.selectedStatus == status
                            ) {
                                viewModel.updateStatusFilter(status)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Custom Date Range
            HStack(spacing: 12) {
                // Start Date Button
                Button(action: {
                    viewModel.toggleStartDatePicker()
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(HomeViewHelpers.formatDate(viewModel.customStartDate))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1) )
                    .cornerRadius(8)
                }
                .foregroundColor(.primary)
                
                // End Date Button
                Button(action: {
                    viewModel.toggleEndDatePicker()
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(HomeViewHelpers.formatDate(viewModel.customEndDate))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background( Color.blue.opacity(0.1) )
                    .cornerRadius(8)
                }
                .foregroundColor(.primary)
                
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Content Views
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading incidents...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
    }
    
    private func errorView(errorMessage: String) -> some View {
        DSErrorView(
            title: "Error Loading Incidents",
            message: errorMessage,
            retryAction: {
                Task {
                    await viewModel.refreshIncidents()
                }
            }
        )
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.fill")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No Incidents Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Try adjusting your filters or search criteria")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if viewModel.selectedStatus != nil {
                Button("Clear Filters") {
                    withAnimation {
                        viewModel.clearFilters()
                    }
                }
                .foregroundColor(.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var incidentsList: some View {
        List(viewModel.filteredIncidents) { incident in
            DSIncidentRowView(
                incident: HomeViewHelpers.convertToIncidentData(incident)
            )
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowSeparator(.hidden)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                // Status change buttons
                ForEach(IncidentStatus.allCases.filter { $0.rawValue != incident.status }, id: \.self) { status in
                    Button(status.title) {
                        Task {
                            await viewModel.updateIncidentStatus(incident: incident, newStatus: status)
                        }
                    }
                    .tint(status.color)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
