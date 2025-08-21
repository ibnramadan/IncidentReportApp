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
            VStack(spacing: 30) {
                // Welcome Header
                VStack(spacing: 8) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Welcome Home!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let user = viewModel.currentUser {
                        Text("Logged in as: \(user)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Success Message
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    Text("You are successfully logged in")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}
