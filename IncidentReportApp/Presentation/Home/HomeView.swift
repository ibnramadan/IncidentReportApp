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
                headerView
                filtersView
                contentView
                Spacer()
            }
            .navigationBarHidden(true)
            .refreshable { await viewModel.refreshIncidents() }
            .onAppear {
                if viewModel.incidents.isEmpty {
                    Task { await viewModel.loadIncidents() }
                }
            }
            .sheet(isPresented: $viewModel.showStartDatePicker) {
                DSDatePickerSheet(
                    title: "Select Start Date",
                    selection: $viewModel.customStartDate,
                    range: ...viewModel.customEndDate,
                    onDone: { viewModel.updateCustomStartDate(viewModel.customStartDate) },
                    onCancel: { viewModel.showStartDatePicker = false }
                )
            }
            .sheet(isPresented: $viewModel.showEndDatePicker) {
                DSDatePickerSheet(
                    title: "Select End Date",
                    selection: $viewModel.customEndDate,
                    range: viewModel.customStartDate...,
                    onDone: { viewModel.updateCustomEndDate(viewModel.customEndDate) },
                    onCancel: { viewModel.showEndDatePicker = false }
                )
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Incidents")
                        .heading2()
                        .fontWeight(.semibold)
                        .foregroundColor(Colors.textPrimary)
                    
                    if let user = viewModel.currentUser {
                        Text("Logged in as: \(user)")
                            .bodyMedium()
                            .foregroundColor(Colors.textSecondary)
                    }
                }
                Spacer()
                
                HStack(spacing: Spacing.sm) {
                    DSActionButton(icon: "chart.bar.fill", color: Colors.primary) {
                        viewModel.openDashboard()
                    }
                    DSActionButton(icon: "plus.circle.fill", color: Colors.statusResolved) {
                        viewModel.openNewIncident()
                    }
                }
            }
        }
        .padding()
        .background(Colors.background)
    }
    
    // MARK: - Filters View
    private var filtersView: some View {
        VStack(spacing: Spacing.sm) {
            statusFilterSection
            dateRangeSection
        }
        .padding(.bottom, Spacing.sm)
    }
    
    private var statusFilterSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Status")
                .captionMedium()
                .foregroundColor(Colors.textSecondary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    FilterChip(title: "All", isSelected: viewModel.selectedStatus == nil) {
                        viewModel.updateStatusFilter(nil)
                    }
                    
                    ForEach(IncidentStatus.allCases, id: \.self) { status in
                        FilterChip(title: status.title, isSelected: viewModel.selectedStatus == status) {
                            viewModel.updateStatusFilter(status)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var dateRangeSection: some View {
        HStack(spacing: Spacing.sm) {
            DSDateRangeButton(label: "From", date: viewModel.customStartDate) {
                viewModel.toggleStartDatePicker()
            }
            DSDateRangeButton(label: "To", date: viewModel.customEndDate) {
                viewModel.toggleEndDatePicker()
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading && viewModel.incidents.isEmpty {
            loadingView
        } else if let errorMessage = viewModel.errorMessage {
            errorView(errorMessage: errorMessage)
        } else if viewModel.filteredIncidents.isEmpty {
            emptyStateView
        } else {
            incidentsList
        }
    }
    
    private var loadingView: some View {
        DSLoadingView(message: "Loading incidents...", style: .spinner)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.xl)
    }
    
    private func errorView(errorMessage: String) -> some View {
        DSErrorView(
            title: "Error Loading Incidents",
            message: errorMessage,
            retryAction: { Task { await viewModel.refreshIncidents() } }
        )
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var emptyStateView: some View {
        DSEmptyStateView(
            icon: "tray.fill",
            title: "No Incidents Found",
            message: "Try adjusting your filters or search criteria",
            actionTitle: viewModel.selectedStatus != nil ? "Clear Filters" : nil
        ) {
            if viewModel.selectedStatus != nil {
                withAnimation { viewModel.clearFilters() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var incidentsList: some View {
        List(viewModel.filteredIncidents) { incident in
            DSIncidentRowView(incident: HomeViewHelpers.convertToIncidentData(incident))
                .listRowInsets(EdgeInsets(top: Spacing.sm, leading: Spacing.md, bottom: Spacing.sm, trailing: Spacing.md))
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    ForEach(IncidentStatus.allCases.filter { $0.rawValue != incident.status }, id: \.self) { status in
                        Button(status.title) {
                            Task { await viewModel.updateIncidentStatus(incident: incident, newStatus: status) }
                        }
                        .tint(status.color)
                    }
                }
        }
        .listStyle(PlainListStyle())
    }
}
