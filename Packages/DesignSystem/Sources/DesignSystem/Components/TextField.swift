import SwiftUI

// MARK: - TextField Component
public struct DSTextField: View {
    public enum TextFieldStyle {
        case standard
        case outlined
        case filled
    }
    
    public enum TextFieldSize {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 44
            case .large: return 52
            }
        }
        
        var fontSize: Font {
            switch self {
            case .small: return Typography.bodySmall
            case .medium: return Typography.bodyMedium
            case .large: return Typography.bodyLarge
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return Spacing.sm
            case .medium: return Spacing.md
            case .large: return Spacing.lg
            }
        }
    }
    
    @Binding private var text: String
    private let placeholder: String
    private let icon: String?
    private let trailingIcon: String?
    private let style: TextFieldStyle
    private let size: TextFieldSize
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let isSecure: Bool
    private let isDisabled: Bool
    private let errorMessage: String?
    private let onTrailingIconTap: (() -> Void)?
    
    public init(
        text: Binding<String>,
        placeholder: String,
        icon: String? = nil,
        trailingIcon: String? = nil,
        style: TextFieldStyle = .standard,
        size: TextFieldSize = .medium,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        errorMessage: String? = nil,
        onTrailingIconTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.trailingIcon = trailingIcon
        self.style = style
        self.size = size
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.isSecure = isSecure
        self.isDisabled = isDisabled
        self.errorMessage = errorMessage
        self.onTrailingIconTap = onTrailingIconTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(size.fontSize)
                        .foregroundColor(iconColor)
                }
                
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(size.fontSize)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .disabled(isDisabled)
                
                if let trailingIcon = trailingIcon {
                    Button(action: {
                        onTrailingIconTap?()
                    }) {
                        Image(systemName: trailingIcon)
                            .font(size.fontSize)
                            .foregroundColor(iconColor)
                    }
                    .disabled(onTrailingIconTap == nil)
                }
            }
            .frame(height: size.height)
            .padding(.horizontal, size.padding)
            .background(backgroundColor)
            .cornerRadius(Corners.md)
            .overlay(
                RoundedRectangle(cornerRadius: Corners.md)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            
            if let errorMessage = errorMessage {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(Colors.error)
                    
                    Text(errorMessage)
                        .font(Typography.captionSmall)
                        .foregroundColor(Colors.error)
                }
                .padding(.leading, Spacing.sm)
            }
        }
    }
    
    private var backgroundColor: Color {
        if isDisabled {
            return Colors.secondaryBackground
        }
        
        switch style {
        case .standard:
            return Colors.background
        case .outlined:
            return Colors.background
        case .filled:
            return Colors.secondaryBackground
        }
    }
    
    private var borderColor: Color {
        if let _ = errorMessage {
            return Colors.error
        }
        
        if isDisabled {
            return Colors.border
        }
        
        switch style {
        case .standard:
            return Colors.border
        case .outlined:
            return Colors.border
        case .filled:
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .standard:
            return 1
        case .outlined:
            return 1
        case .filled:
            return 0
        }
    }
    
    private var iconColor: Color {
        if isDisabled {
            return Colors.textSecondary
        }
        
        if let _ = errorMessage {
            return Colors.error
        }
        
        return Colors.textSecondary
    }
}

// MARK: - TextField Modifiers
public extension View {
    func dsTextField(
        text: Binding<String>,
        placeholder: String,
        icon: String? = nil,
        trailingIcon: String? = nil,
        style: DSTextField.TextFieldStyle = .standard,
        size: DSTextField.TextFieldSize = .medium,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        errorMessage: String? = nil,
        onTrailingIconTap: (() -> Void)? = nil
    ) -> some View {
        DSTextField(
            text: text,
            placeholder: placeholder,
            icon: icon,
            trailingIcon: trailingIcon,
            style: style,
            size: size,
            keyboardType: keyboardType,
            textContentType: textContentType,
            isSecure: isSecure,
            isDisabled: isDisabled,
            errorMessage: errorMessage,
            onTrailingIconTap: onTrailingIconTap
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.md) {
        DSTextField(
            text: .constant(""),
            placeholder: "Standard TextField",
            icon: "person"
        )
        
        DSTextField(
            text: .constant(""),
            placeholder: "Outlined TextField",
            icon: "envelope", style: .outlined
        )
        
        DSTextField(
            text: .constant(""),
            placeholder: "Filled TextField",
            icon: "lock", style: .filled
        )
        
        DSTextField(
            text: .constant(""),
            placeholder: "With Error",
            icon: "exclamationmark.triangle",
            errorMessage: "This field is required"
        )
        
        DSTextField(
            text: .constant(""),
            placeholder: "Disabled",
            icon: "person",
            isDisabled: true
        )
    }
    .padding()
} 
