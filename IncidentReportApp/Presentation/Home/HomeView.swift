//
//  HomeView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with user info
                headerView
                
                // Status Tabs and Date Filter
                searchAndFiltersView
                
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
                NavigationView {
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
                NavigationView {
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
    
    // MARK: - Status Tabs and Date Filter
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 12) {
            // Status Filter Tabs (Always Visible)
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
                        Text(formatDate(viewModel.customStartDate))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(viewModel.selectedDateFilter == .custom ? Color.blue.opacity(0.1) : Color(.systemGray6))
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
                        Text(formatDate(viewModel.customEndDate))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(viewModel.selectedDateFilter == .custom ? Color.blue.opacity(0.1) : Color(.systemGray6))
                    .cornerRadius(8)
                }
                .foregroundColor(.primary)
                
                // Clear Date Filter
                if viewModel.selectedDateFilter != .all {
                    Button(action: {
                        withAnimation {
                            viewModel.updateDateFilter(.all)
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }
    
    private var filtersPanel: some View {
        VStack(spacing: 16) {
            // Status Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Status")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
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
                    .padding(.horizontal, 2)
                }
            }
            
            // Date Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Date Range")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DateFilter.allCases, id: \.self) { dateFilter in
                            DateFilterChip(
                                dateFilter: dateFilter,
                                isSelected: viewModel.selectedDateFilter == dateFilter,
                                displayText: dateFilter == .custom && viewModel.selectedDateFilter == .custom
                                    ? viewModel.dateRangeText
                                    : dateFilter.title
                            ) {
                                viewModel.updateDateFilter(dateFilter)
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Content Views
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading incidents...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.refreshIncidents()
                }
            }
            .foregroundColor(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            
            if hasActiveFilters {
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
            IncidentRowView(incident: incident)
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
    
    // MARK: - Helper Methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - Helper Properties
    
    private var hasActiveFilters: Bool {
        viewModel.selectedStatus != nil ||
        viewModel.selectedDateFilter != .all
    }
}

// MARK: - Supporting Views

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct DateFilterChip: View {
    let dateFilter: DateFilter
    let isSelected: Bool
    let displayText: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: dateFilter.icon)
                    .font(.caption)
                Text(displayText)
                    .font(.caption)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
        }
    }
}

struct IncidentRowView: View {
    let incident: IncidentEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(incident.id)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(incident.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack {
                        Image(systemName: incident.statusEnum.icon)
                        Text(incident.statusEnum.title)
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(incident.statusEnum.color.opacity(0.2))
                    .foregroundColor(incident.statusEnum.color)
                    .cornerRadius(8)
                    
                    Text(formatDate(incident.createdDate))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
