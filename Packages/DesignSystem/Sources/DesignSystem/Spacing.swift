import SwiftUI

// MARK: - Spacing System
public struct Spacing {
    public init() {}
}

// MARK: - Spacing Values
public extension Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - View Extensions
public extension View {
    func paddingXS() -> some View {
        self.padding(Spacing.xs)
    }
    
    func paddingSM() -> some View {
        self.padding(Spacing.sm)
    }
    
    func paddingMD() -> some View {
        self.padding(Spacing.md)
    }
    
    func paddingLG() -> some View {
        self.padding(Spacing.lg)
    }
    
    func paddingXL() -> some View {
        self.padding(Spacing.xl)
    }
    
    func paddingXXL() -> some View {
        self.padding(Spacing.xxl)
    }
    
    func paddingHorizontal(_ spacing: CGFloat) -> some View {
        self.padding(.horizontal, spacing)
    }
    
    func paddingVertical(_ spacing: CGFloat) -> some View {
        self.padding(.vertical, spacing)
    }
} 