//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by mohamed ramadan on 21/08/2025.
//

import SwiftUI
import Coordinator

@Observable
class AppCoordinator: BaseCoordinator<AppRoute> {
     var isAuthenticated = false
     var currentUser: String?
     var authToken: String?
     var showSplash = true
    
    override init() {
        super.init()
        checkAuthenticationState()
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        authToken = nil
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "authToken")
        popToRoot()
        navigate(to: .login)
    }
    
    func navigateToOTP(email: String) {
        navigate(to: .otp(email: email))
    }
    
    func navigateToDashboard() {
        navigate(to: .dashboard)
    }
    
    func navigateToSubmitIncident() {
        navigate(to: .submitIncident)
    }
    
    func navigateBack() {
        pop()
    }
    
    func otpVerificationSuccessful(email: String, token: String) {
        isAuthenticated = true
        currentUser = email
        authToken = token
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        UserDefaults.standard.set(email, forKey: "currentUser")
        UserDefaults.standard.set(token, forKey: "authToken")
        popToRoot()
    }
    
    func splashCompleted() {
        showSplash = false
    }
    
    private func checkAuthenticationState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        currentUser = UserDefaults.standard.string(forKey: "currentUser")
        authToken = UserDefaults.standard.string(forKey: "authToken")
    }
}

