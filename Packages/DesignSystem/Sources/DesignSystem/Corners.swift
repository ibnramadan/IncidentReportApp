import SwiftUI

// MARK: - Corner Radius System
public struct Corners {
    public init() {}
}

// MARK: - Corner Radius Values
public extension Corners {
    static let xs: CGFloat = 2
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let xxl: CGFloat = 24
    static let full: CGFloat = 999
}

// MARK: - View Extensions
public extension View {
    func cornerRadiusXS() -> some View {
        self.cornerRadius(Corners.xs)
    }
    
    func cornerRadiusSM() -> some View {
        self.cornerRadius(Corners.sm)
    }
    
    func cornerRadiusMD() -> some View {
        self.cornerRadius(Corners.md)
    }
    
    func cornerRadiusLG() -> some View {
        self.cornerRadius(Corners.lg)
    }
    
    func cornerRadiusXL() -> some View {
        self.cornerRadius(Corners.xl)
    }
    
    func cornerRadiusXXL() -> some View {
        self.cornerRadius(Corners.xxl)
    }
    
    func cornerRadiusFull() -> some View {
        self.cornerRadius(Corners.full)
    }
}

// MARK: - Rounded Corner Shape
public struct RoundedCorner: Shape {
    private let radius: CGFloat
    private let corners: UIRectCorner
    
    public init(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
} 