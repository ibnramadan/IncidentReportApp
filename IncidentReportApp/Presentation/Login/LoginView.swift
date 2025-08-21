//
//  LoginView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//
//
import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    @FocusState private var isEmailFieldFocused: Bool
    
    init(viewModel: LoginViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Welcome Back")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Enter your email to continue")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            
            // Email Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Email Address")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
                    .focused($isEmailFieldFocused)
                    .onSubmit {
                        Task {
                            await viewModel.login()
                        }
                    }
            }
            .padding(.horizontal)
            
            // Login Button
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Continue with Email")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(viewModel.email.isEmpty || !viewModel.isValidEmail(viewModel.email) || viewModel.isLoading)
            .opacity((viewModel.email.isEmpty || !viewModel.isValidEmail(viewModel.email) || viewModel.isLoading) ? 0.6 : 1)
            
            // Error Message
            if let errorMessage = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button("Try Again") {
                    viewModel.clearError()
                }
                .font(.caption)
                .foregroundColor(.blue)
            } 
            
            Spacer()
            
            // Footer
            Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
        .padding()
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)

        .onAppear {
            // Set focus to email field when view appears
            isEmailFieldFocused = true
        }
    }
}
