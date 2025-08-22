//
//  SplashView.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI
import DesignSystem

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    let onSplashComplete: () -> Void
    
    var body: some View {
        ZStack {
            Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.xl) {
                // App Icon
                appIconView
                
                // App Name
                VStack(spacing: Spacing.sm) {
                    Text("Incident Report")
                        .heading1()
                        .fontWeight(.bold)
                        .foregroundColor(Colors.textPrimary)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    Text("Manage incidents efficiently")
                        .bodyMedium()
                        .foregroundColor(Colors.textSecondary)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                
                Spacer()
                
                // Loading indicator
                if showContent {
                    VStack(spacing: Spacing.md) {
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(Colors.primary)
                        
                        Text("Loading...")
                            .bodyMedium()
                            .foregroundColor(Colors.textSecondary)
                    }
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showContent)
                }
            }
            .padding()
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private var appIconView: some View {
        Image(systemName: "shield.checkered")
            .font(.system(size: 80))
            .foregroundColor(Colors.primary)
            .scaleEffect(isAnimating ? 1.1 : 0.8)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            .font(.system(size: 80, weight: .medium))
            .foregroundColor(Colors.primary)
            .scaleEffect(isAnimating ? 1.1 : 0.8)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
    }
    
    private func startAnimation() {
        isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                onSplashComplete()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SplashView {
        print("Splash completed")
    }
}
