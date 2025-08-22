//
//  LoginView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//
//
import SwiftUI
import DesignSystem

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    @FocusState private var isEmailFieldFocused: Bool

    init(viewModel: LoginViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                // Header
                VStack(spacing: Spacing.sm) {
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 60))
                        .foregroundColor(Colors.primary)
                    
                    VStack(spacing: Spacing.xs) {
                        Text("Incident Report")
                            .heading1()
                            .fontWeight(.bold)
                            .foregroundColor(Colors.textPrimary)
                        
                        Text("Sign in to continue")
                            .bodyMedium()
                            .foregroundColor(Colors.textSecondary)
                    }
                }
                .padding(.top, Spacing.xl)
                
                // Form
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Email Address")
                        .labelMedium()
                        .foregroundColor(Colors.textPrimary)
                    
                    DSTextField(
                        text: $viewModel.email,
                        placeholder: "Enter your email",
                        icon: "envelope",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress,
                      //  isFocused: $isEmailFieldFocused
                    )
                }
                .padding(.horizontal, Spacing.md)
                
                DSButton(
                    "Sign In",
                    style: .primary, isLoading: viewModel.isLoading
                ) {
                    Task {
                        await viewModel.login()
                    }
                }
                .padding(.horizontal, Spacing.md)
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    DSErrorView(
                        title: "Login Error",
                        message: errorMessage,
                        retryAction: {
                            Task {
                                await viewModel.login()
                            }
                        },
                        dismissAction: {
                            viewModel.clearError()
                        }
                    )
                    .padding(.horizontal, Spacing.md)
                }
            }
            .padding(.bottom, Spacing.lg)
            .background(Colors.background)
        }
    }
}
