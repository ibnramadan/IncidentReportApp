//
//  OTPViewModel.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
@MainActor
@Observable
final class OTPViewModel {
    var otp: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var verificationSuccess: Bool = false
    
    let email: String
    private let otpUseCase: OTPUseCaseProtocol
    private let coordinator: AppCoordinator
    
    init(email: String, otpUseCase: OTPUseCaseProtocol, coordinator: AppCoordinator) {
        self.email = email
        self.otpUseCase = otpUseCase
        self.coordinator = coordinator
    }
    
    // Convenience initializer
    convenience init(email: String, repo: IncidentsRepoProtocol, coordinator: AppCoordinator) {
        self.init(email: email, otpUseCase: OTPUseCase(repo: repo), coordinator: coordinator)
    }
    
    var canVerify: Bool {
        otp.count == 4 && !isLoading
    }
    
    func updateOTP(_ newOTP: String) {
        // Only allow 4 digits
        let filtered = String(newOTP.prefix(4)).filter { $0.isNumber }
        otp = filtered
        
        // Auto-verify when 4 digits are entered
        if filtered.count == 4 {
            Task {
                await verifyOTP()
            }
        }
    }
    
    func verifyOTP() async {
        guard canVerify else { return }
        
        isLoading = true
        errorMessage = nil
        verificationSuccess = false
        
        do {
            let response = try await otpUseCase.execute(email: email, otp: otp)
            
            isLoading = false
            verificationSuccess = true
            errorMessage = nil
            
            // Wait a bit to show success animation
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            // Navigate to home with token
            coordinator.otpVerificationSuccessful(email: email, token: response.token)
            
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func resendOTP() async {
        otp = ""
        errorMessage = nil
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func goBack() {
        coordinator.pop()
    }
}
