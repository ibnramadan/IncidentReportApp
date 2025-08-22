import SwiftUI

// MARK: - Shadow System
public struct Shadows {
    public init() {}
}
@MainActor
// MARK: - Shadow Values
public extension Shadows {
    static let xs = Shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    static let sm = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
    static let md = Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4)
    static let lg = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 8)
    static let xl = Shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 16)
    static let xxl = Shadow(color: .black.opacity(0.3), radius: 24, x: 0, y: 24)
    static let none = Shadow(color: .clear, radius: 0, x: 0, y: 0)
}

// MARK: - Shadow Model
public struct Shadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - View Extensions
public extension View {
    func shadowXS() -> some View {
        self.shadow(Shadows.xs)
    }
    
    func shadowSM() -> some View {
        self.shadow(Shadows.sm)
    }
    
    func shadowMD() -> some View {
        self.shadow(Shadows.md)
    }
    
    func shadowLG() -> some View {
        self.shadow(Shadows.lg)
    }
    
    func shadowXL() -> some View {
        self.shadow(Shadows.xl)
    }
    
    func shadowXXL() -> some View {
        self.shadow(Shadows.xxl)
    }
    
    func shadowNone() -> some View {
        self.shadow(Shadows.none)
    }
    
    func shadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
} 
