//
//  DSLoadingView.swift
//  DesignSystem
//
//  Created by mohamed ramadan on 22/08/2025.
//


import SwiftUI

// MARK: - LoadingView Component
public struct DSLoadingView: View {
    public enum LoadingStyle {
        case spinner
        case dots
        case pulse
    }
    
    public enum LoadingSize {
        case small
        case medium
        case large
        
        var scale: CGFloat {
            switch self {
            case .small: return 0.8
            case .medium: return 1.0
            case .large: return 1.2
            }
        }
    }
    
    private let message: String?
    private let style: LoadingStyle
    private let size: LoadingSize
    private let color: Color
    
    public init(
        message: String? = nil,
        style: LoadingStyle = .spinner,
        size: LoadingSize = .medium,
        color: Color = Colors.primary
    ) {
        self.message = message
        self.style = style
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        VStack(spacing: Spacing.md) {
            loadingIndicator
            
            if let message = message {
                Text(message)
                    .bodyMedium()
                    .foregroundColor(Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var loadingIndicator: some View {
        switch style {
        case .spinner:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: color))
                .scaleEffect(size.scale)
        case .dots:
            DotsLoadingView(color: color, size: size)
        case .pulse:
            PulseLoadingView(color: color, size: size)
        }
    }
}

// MARK: - Dots Loading View
private struct DotsLoadingView: View {
    let color: Color
    let size: DSLoadingView.LoadingSize
    
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(1.0 + sin(animationOffset + Double(index) * .pi / 2) * 0.3)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animationOffset
                    )
            }
        }
        .onAppear {
            animationOffset = 1
        }
    }
}

// MARK: - Pulse Loading View
private struct PulseLoadingView: View {
    let color: Color
    let size: DSLoadingView.LoadingSize
    
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 20 * size.scale, height: 20 * size.scale)
            .scaleEffect(isAnimating ? 1.5 : 1.0)
            .opacity(isAnimating ? 0.0 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - LoadingView Modifiers
public extension View {
    func dsLoadingView(
        message: String? = nil,
        style: DSLoadingView.LoadingStyle = .spinner,
        size: DSLoadingView.LoadingSize = .medium,
        color: Color = Colors.primary
    ) -> some View {
        DSLoadingView(
            message: message,
            style: style,
            size: size,
            color: color
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.lg) {
        DSLoadingView(message: "Loading...", style: .spinner)
        DSLoadingView(message: "Processing...", style: .dots)
        DSLoadingView(message: "Please wait...", style: .pulse)
        
        HStack(spacing: Spacing.lg) {
            DSLoadingView(style: .spinner, size: .small)
            DSLoadingView(style: .spinner, size: .medium)
            DSLoadingView(style: .spinner, size: .large)
        }
    }
    .padding()
} 
