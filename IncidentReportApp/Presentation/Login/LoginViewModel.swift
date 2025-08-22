//
//  LoginViewModel.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation

@MainActor
@Observable
final class LoginViewModel {
    var email: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var loginSuccess: Bool = false
    
    private let loginUseCase: LoginUseCaseProtocol
    private let coordinator: AppCoordinator
    
    init(loginUseCase: LoginUseCaseProtocol, coordinator: AppCoordinator) {
        self.loginUseCase = loginUseCase
        self.coordinator = coordinator
    }
    
    // Convenience initializer for production use
    convenience init(repo: IncidentsRepoProtocol, coordinator: AppCoordinator) {
        self.init(loginUseCase: LoginUseCase(repo: repo), coordinator: coordinator)
    }
    
    func login() async {
        // Validate input
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address"
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        isLoading = true
        errorMessage = nil
        loginSuccess = false
        
        do {
            let result = try await loginUseCase.execute(email: email)
            
            isLoading = false
            if result.uppercased() == "OK" {
                loginSuccess = true
                errorMessage = nil
  
                coordinator.navigateToOTP(email: email)
                
            } else {
                errorMessage = "Unexpected response: \(result)"
            }
            
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func reset() {
        email = ""
        isLoading = false
        errorMessage = nil
        loginSuccess = false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
