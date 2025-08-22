import SwiftUI

// MARK: - Animation System
public struct Animations {
    public init() {}
}

// MARK: - Animation Durations
public extension Animations {
    static let durationFast: Double = 0.15
    static let durationNormal: Double = 0.3
    static let durationSlow: Double = 0.5
}

// MARK: - Animation Curves
public extension Animations {
    static let curveEaseInOut = Animation.easeInOut(duration: durationNormal)
    static let curveEaseIn = Animation.easeIn(duration: durationNormal)
    static let curveEaseOut = Animation.easeOut(duration: durationNormal)
    static let curveSpring = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let curveBouncy = Animation.spring(response: 0.6, dampingFraction: 0.6)
}

// MARK: - View Extensions
public extension View {
    func animationFast() -> some View {
        self.animation(Animations.curveEaseInOut, value: true)
    }
    
    func animationNormal() -> some View {
        self.animation(Animations.curveEaseInOut, value: true)
    }
    
    func animationSlow() -> some View {
        self.animation(Animations.curveEaseInOut, value: true)
    }
    
    func animationSpring() -> some View {
        self.animation(Animations.curveSpring, value: true)
    }
    
    func animationBouncy() -> some View {
        self.animation(Animations.curveBouncy, value: true)
    }
}

// MARK: - Transition Extensions
@MainActor
public extension AnyTransition {
    static let fadeIn = AnyTransition.opacity.combined(with: .scale(scale: 0.95))
    static let slideIn = AnyTransition.move(edge: .bottom).combined(with: .opacity)
    static let scaleIn = AnyTransition.scale(scale: 0.8).combined(with: .opacity)
    static let bounce = AnyTransition.scale(scale: 1.1).combined(with: .opacity)
} 
