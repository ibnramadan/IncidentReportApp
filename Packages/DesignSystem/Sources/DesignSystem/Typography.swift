import SwiftUI

// MARK: - Typography System
public struct Typography {
    public init() {}
}

// MARK: - Font Sizes
public extension Typography {
    static let fontSizeXS: CGFloat = 10
    static let fontSizeSM: CGFloat = 12
    static let fontSizeMD: CGFloat = 14
    static let fontSizeLG: CGFloat = 16
    static let fontSizeXL: CGFloat = 18
    static let fontSizeXXL: CGFloat = 20
    static let fontSizeXXXL: CGFloat = 24
    static let fontSizeDisplay: CGFloat = 32
}

// MARK: - Font Weights
public extension Typography {
    static let fontWeightRegular = Font.Weight.regular
    static let fontWeightMedium = Font.Weight.medium
    static let fontWeightSemibold = Font.Weight.semibold
    static let fontWeightBold = Font.Weight.bold
}

// MARK: - Text Styles
public extension Typography {
    // Display
    static let displayLarge = Font.system(size: fontSizeDisplay, weight: fontWeightBold)
    static let displayMedium = Font.system(size: fontSizeXXXL, weight: fontWeightBold)
    static let displaySmall = Font.system(size: fontSizeXXL, weight: fontWeightBold)
    
    // Headings
    static let heading1 = Font.system(size: fontSizeXXXL, weight: fontWeightSemibold)
    static let heading2 = Font.system(size: fontSizeXXL, weight: fontWeightSemibold)
    static let heading3 = Font.system(size: fontSizeXL, weight: fontWeightSemibold)
    static let heading4 = Font.system(size: fontSizeLG, weight: fontWeightSemibold)
    
    // Body
    static let bodyLarge = Font.system(size: fontSizeLG, weight: fontWeightRegular)
    static let bodyMedium = Font.system(size: fontSizeMD, weight: fontWeightRegular)
    static let bodySmall = Font.system(size: fontSizeSM, weight: fontWeightRegular)
    
    // Labels
    static let labelLarge = Font.system(size: fontSizeMD, weight: fontWeightMedium)
    static let labelMedium = Font.system(size: fontSizeSM, weight: fontWeightMedium)
    static let labelSmall = Font.system(size: fontSizeXS, weight: fontWeightMedium)
    
    // Captions
    static let captionLarge = Font.system(size: fontSizeSM, weight: fontWeightRegular)
    static let captionMedium = Font.system(size: fontSizeXS, weight: fontWeightRegular)
    static let captionSmall = Font.system(size: fontSizeXS, weight: fontWeightRegular)
}

// MARK: - View Extensions
public extension View {
    func displayLarge() -> some View {
        self.font(Typography.displayLarge)
    }
    
    func displayMedium() -> some View {
        self.font(Typography.displayMedium)
    }
    
    func displaySmall() -> some View {
        self.font(Typography.displaySmall)
    }
    
    func heading1() -> some View {
        self.font(Typography.heading1)
    }
    
    func heading2() -> some View {
        self.font(Typography.heading2)
    }
    
    func heading3() -> some View {
        self.font(Typography.heading3)
    }
    
    func heading4() -> some View {
        self.font(Typography.heading4)
    }
    
    func bodyLarge() -> some View {
        self.font(Typography.bodyLarge)
    }
    
    func bodyMedium() -> some View {
        self.font(Typography.bodyMedium)
    }
    
    func bodySmall() -> some View {
        self.font(Typography.bodySmall)
    }
    
    func labelLarge() -> some View {
        self.font(Typography.labelLarge)
    }
    
    func labelMedium() -> some View {
        self.font(Typography.labelMedium)
    }
    
    func labelSmall() -> some View {
        self.font(Typography.labelSmall)
    }
    
    func captionLarge() -> some View {
        self.font(Typography.captionLarge)
    }
    
    func captionMedium() -> some View {
        self.font(Typography.captionMedium)
    }
    
    func captionSmall() -> some View {
        self.font(Typography.captionSmall)
    }
} 