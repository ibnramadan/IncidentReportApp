//
//  DashboardView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI
import DesignSystem

struct DashboardView: View {
    @State private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ScrollView {
                    LazyVStack(spacing: Spacing.lg) {
                        if viewModel.isLoading {
                            loadingView
                        } else if let errorMessage = viewModel.errorMessage {
                            errorView(errorMessage: errorMessage)
                        } else if viewModel.dashboardEntities.isEmpty {
                            emptyStateView
                        } else {
                            // Summary Cards
                            summaryCardsView
                            
                            // Chart Section
                            chartSectionView
                            
                            // Statistics List
                            statisticsListView
                        }
                    }
                    .padding()
                }
            }
            .refreshable {
                await viewModel.refreshDashboard()
            }
            .onAppear {
                if viewModel.dashboardEntities.isEmpty {
                    Task {
                        await viewModel.loadDashboard()
                    }
                }
            }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Dashboard")
                        .heading2()
                        .fontWeight(.semibold)
                    
                    Text("Incidents Overview")
                        .bodyMedium()
                        .foregroundColor(Colors.textSecondary)
                }
                
                Spacer()
                
                // Refresh Button
                Button(action: {
                    Task {
                       await viewModel.refreshDashboard()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(22)
                }
                .disabled(viewModel.isLoading)
                
            }
        }
        .padding()
        .background(Colors.background)
    }
    
    // MARK: - Content Views
    private var loadingView: some View {
        DSLoadingView(
            message: "Loading dashboard...",
            style: .spinner
        )
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xl)
    }
    
    private func errorView(errorMessage: String) -> some View {
        DSErrorView(
            title: "Error Loading Dashboard",
            message: errorMessage,
            retryAction: {
                Task {
                    await viewModel.refreshDashboard()
                }
            }
        )
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var emptyStateView: some View {
        DSEmptyStateView(
            icon: "chart.bar.fill",
            title: "No Data Available",
            message: "Dashboard data will appear here when available"
        )
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var summaryCardsView: some View {
        VStack(spacing: Spacing.md) {
            // Total Incidents Card
            DSSummaryCard(
                title: "Total Incidents",
                value: "\(viewModel.totalIncidents)",
                subtitle: nil,
                icon: "chart.bar.fill",
                color: Colors.primary
            )
            
            // Status Breakdown
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Spacing.sm) {
                ForEach(viewModel.dashboardEntities, id: \.id) { entity in
                    DSSummaryCard(
                        title: entity.statusEnum.title,
                        value: "\(entity.count)",
                        subtitle: viewModel.getFormattedPercentage(for: entity),
                        icon: entity.statusEnum.icon,
                        color: entity.statusEnum.color
                    )
                }
            }
        }
    }
    
    private var chartSectionView: some View {
        VStack {
            // Simple Chart Representation
            simpleChartView
        }
        .frame(height: 300)
        .padding()
        .background(Colors.secondaryBackground.opacity(0.5))
        .cornerRadius(Corners.lg)
    }
    
    private var simpleChartView: some View {
        VStack(spacing: Spacing.md) {
            // Chart Title
            Text("Incident Distribution")
                .heading4()
                .fontWeight(.semibold)
            
            // Simple Bar Chart
            HStack(alignment: .bottom, spacing: Spacing.sm) {
                ForEach(viewModel.dashboardEntities, id: \.id) { entity in
                    VStack(spacing: Spacing.xs) {
                        // Bar
                        Rectangle()
                            .fill(entity.statusEnum.color)
                            .frame(height: barHeight(for: entity))
                            .cornerRadius(Corners.xs)
                        
                        // Label
                        Text(entity.statusEnum.title)
                            .captionSmall()
                            .foregroundColor(Colors.textSecondary)
                            .rotationEffect(.degrees(-45))
                            .offset(y: Spacing.xs)
                    }
                }
            }
            .frame(height: 150)
            .padding(.horizontal, Spacing.md)
            
            // Legend
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: Spacing.sm) {
                ForEach(viewModel.dashboardEntities, id: \.id) { entity in
                    HStack(spacing: Spacing.xs) {
                        Circle()
                            .fill(entity.statusEnum.color)
                            .frame(width: 8, height: 8)
                        
                        Text(entity.statusEnum.title)
                            .captionMedium()
                            .foregroundColor(Colors.textPrimary)
                        
                        Spacer()
                        
                        Text("\(entity.count)")
                            .captionMedium()
                            .fontWeight(.semibold)
                            .foregroundColor(entity.statusEnum.color)
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
        }
    }
    
    private func barHeight(for entity: DashboardEntity) -> CGFloat {
        let maxCount = viewModel.dashboardEntities.map { $0.count }.max() ?? 1
        let percentage = Double(entity.count) / Double(maxCount)
        return CGFloat(percentage) * 120 // Max height of 120
    }
    
    private var statisticsListView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Detailed Statistics")
                .heading3()
                .fontWeight(.semibold)
            
            VStack(spacing: Spacing.sm) {
                ForEach(viewModel.dashboardEntities, id: \.id) { entity in
                    DSStatisticRow(
                        title: entity.statusEnum.title,
                        value: "\(entity.count)",
                        subtitle: String(format: "%.1f%% of total", Double(entity.count) / Double(viewModel.totalIncidents) * 100),
                        color: entity.statusEnum.color
                    )
                }
            }
            .padding()
            .background(Colors.secondaryBackground.opacity(0.5))
            .cornerRadius(Corners.lg)
        }
    }
}
