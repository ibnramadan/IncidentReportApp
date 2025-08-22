//
//  DashboardView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI
import Charts

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
                LazyVStack(spacing: 20) {
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
        //   .navigationBarHidden(true)
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
        VStack(spacing: 12) {
            HStack {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Dashboard")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Incidents Overview")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
        .background(Color(.systemBackground))
    }
    
    // MARK: - Content Views
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading dashboard...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private func errorView(errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error Loading Dashboard")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.refreshDashboard()
                }
            }
            .foregroundColor(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No Data Available")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Dashboard data will appear here when available")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var summaryCardsView: some View {
        VStack(spacing: 16) {
            // Total Incidents Card
            SummaryCard(
                title: "Total Incidents",
                value: "\(viewModel.totalIncidents)",
                icon: "exclamationmark.triangle.fill",
                color: .blue
            )
            
            // Status Breakdown
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(viewModel.dashboardEntities) { entity in
                    SummaryCard(
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
            // Pie Chart
            pieChartView
        }
        .frame(height: 300)
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
    }
    
    private var pieChartView: some View {
        Chart(viewModel.dashboardEntities) { entity in
            SectorMark(
                angle: .value("Count", entity.count),
                innerRadius: .ratio(0.0),
                outerRadius: .ratio(0.8)
            )
            .foregroundStyle(entity.statusEnum.color)
            .opacity(0.8)
        }
        .chartLegend(position: .bottom, alignment: .center, spacing: 16)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                let frame = geometry[chartProxy.plotAreaFrame]
                VStack {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(viewModel.totalIncidents)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .position(x: frame.midX, y: frame.midY)
            }
        }
    }
    
    private var statisticsListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detailed Statistics")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(viewModel.dashboardEntities) { entity in
                    StatisticRowView(
                        entity: entity,
                        totalCount: viewModel.totalIncidents
                    )
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(16)
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color
    
    init(title: String, value: String, subtitle: String? = nil, icon: String, color: Color) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(color)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct StatisticRowView: View {
    let entity: DashboardEntity
    let totalCount: Int
    
    private var percentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(entity.count) / Double(totalCount)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(entity.statusEnum.color)
                .frame(width: 12, height: 12)
            
            // Status info
            VStack(alignment: .leading, spacing: 2) {
                Text(entity.statusEnum.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(String(format: "%.1f%% of total", percentage * 100))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(entity.count)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(entity.statusEnum.color)
        }
        .padding(.vertical, 8)
    }
}
