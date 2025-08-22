//
//  OTPView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import SwiftUI
import DesignSystem

struct OTPView: View {
    @State private var viewModel: OTPViewModel
    @FocusState private var isOTPFieldFocused: Bool
    
    init(viewModel: OTPViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "envelope.badge.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Verify Your Email")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("We've sent a 4-digit code to")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(viewModel.email)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            .padding(.top, 40)
            
            VStack(spacing: 20) {
                Text("Enter the 4-digit code")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Custom OTP Input Field
                OTPInputField(
                    otp: $viewModel.otp,
                    onOTPChange: { newOTP in
                        viewModel.updateOTP(newOTP)
                    }, isFieldFocused: isOTPFieldFocused
                )
            }
            
            if viewModel.isLoading {
                DSLoadingView(
                    message: "Verifying...",
                    style: .spinner
                )
                .padding()
            }
            
            // Error Message
            if let errorMessage = viewModel.errorMessage {
                DSErrorView(
                    title: "Verification Error",
                    message: errorMessage,
                    retryAction: {
                        viewModel.clearError()
                    }
                )
                .padding(.horizontal)
            }
            
            // Success Message
            if viewModel.verificationSuccess {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Verification Successful!")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("Welcome! You're now logged in.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
            
            // Resend Code
            if !viewModel.isLoading && !viewModel.verificationSuccess {
                VStack(spacing: 16) {
                    Text("Didn't receive the code?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Resend Code") {
                        Task {
                            await viewModel.resendOTP()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            // Back Button
            Button("Back to Login") {
                viewModel.goBack()
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.bottom, 20)
        }
        .padding()
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)
        .animation(.easeInOut(duration: 0.3), value: viewModel.verificationSuccess)
        .onAppear {
            isOTPFieldFocused = true
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
    }
}
