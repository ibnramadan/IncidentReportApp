# DesignSystem Package

A comprehensive design system for iOS applications built with SwiftUI. This package provides consistent design tokens, reusable components, and complete views for building modern iOS applications.

## Features

- **Design Tokens**: Colors, Typography, Spacing, Corners, Shadows, and Animations
- **Reusable Components**: Buttons, TextFields, Cards, Loading states, Error states, and more
- **Complete Views**: Login, OTP, Dashboard, Submit Incident, and Home views
- **Consistent Styling**: All components follow the same design principles
- **Accessibility**: Built with accessibility in mind
- **Dark Mode Support**: Automatic dark mode support
- **Customizable**: Easy to customize and extend

## Installation

Add the DesignSystem package to your Xcode project:

1. In Xcode, go to File > Add Package Dependencies
2. Enter the package URL or select from your local packages
3. Choose the DesignSystem package
4. Add it to your target

## Usage

### Import the Package

```swift
import DesignSystem
```

### Using Design Tokens

#### Colors
```swift
// Primary colors
Colors.primary
Colors.secondary
Colors.success
Colors.error
Colors.warning

// Text colors
Colors.textPrimary
Colors.textSecondary
Colors.textTertiary

// Background colors
Colors.background
Colors.secondaryBackground
```

#### Typography
```swift
// Font styles
Typography.heading1
Typography.heading2
Typography.bodyLarge
Typography.bodyMedium
Typography.captionLarge

// Text modifiers
Text("Hello World")
    .heading1()
    .bodyMedium()
    .captionLarge()
```

#### Spacing
```swift
// Spacing values
Spacing.xs  // 4pt
Spacing.sm  // 8pt
Spacing.md  // 16pt
Spacing.lg  // 24pt
Spacing.xl  // 32pt

// Padding modifiers
VStack {
    Text("Content")
}
.paddingMD()
.paddingHorizontal(Spacing.lg)
```

#### Corners
```swift
// Corner radius values
Corners.xs   // 2pt
Corners.sm   // 4pt
Corners.md   // 8pt
Corners.lg   // 12pt
Corners.xl   // 16pt

// Corner radius modifiers
Rectangle()
    .cornerRadiusMD()
    .cornerRadiusLG()
```

#### Shadows
```swift
// Shadow values
Shadows.xs
Shadows.sm
Shadows.md
Shadows.lg

// Shadow modifiers
Rectangle()
    .shadowSM()
    .shadowMD()
```

### Using Components

#### Button
```swift
DSButton("Primary Button", style: .primary) {
    // Action
}

DSButton("Secondary Button", style: .secondary) {
    // Action
}

DSButton("Loading Button", isLoading: true) {
    // Action
}
```

#### TextField
```swift
DSTextField(
    text: $email,
    placeholder: "Enter email",
    icon: "envelope"
)

DSTextField(
    text: $password,
    placeholder: "Enter password",
    icon: "lock",
    isSecure: true
)
```

#### Card
```swift
DSCard(style: .elevated) {
    VStack {
        Text("Card Content")
    }
}
```

#### Loading View
```swift
DSLoadingView(
    message: "Loading...",
    style: .spinner
)
```

#### Error View
```swift
DSErrorView(
    title: "Error",
    message: "Something went wrong",
    retryAction: {
        // Retry action
    }
)
```

#### Empty State View
```swift
DSEmptyStateView(
    icon: "tray",
    title: "No Data",
    message: "No data available",
    actionTitle: "Refresh"
) {
    // Action
}
```

#### Summary Card
```swift
DSSummaryCard(
    title: "Total Users",
    value: "1,234",
    subtitle: "+12% from last month",
    icon: "person.3.fill",
    color: Colors.primary
)
```

#### Statistic Row
```swift
DSStatisticRow(
    title: "Active Users",
    value: "567",
    subtitle: "45% of total",
    color: Colors.success
)
```

#### OTP Input Field
```swift
DSOTPInputField(
    otp: $otpCode,
    onOTPChange: { newOTP in
        // Handle OTP change
    }
)
```

#### Navigation Bar
```swift
DSNavigationBar(
    title: "Screen Title",
    leftButton: .back { /* Action */ },
    rightButton: .save { /* Action */ }
)
```

#### Priority Selector
```swift
DSPrioritySelector(
    priority: $priority,
    onPriorityChange: { newPriority in
        // Handle priority change
    }
)
```

### Using Complete Views

#### Login View
```swift
DSLoginView(
    onLogin: { email in
        // Handle login
    },
    onClearError: {
        // Clear error
    }
)
```

#### OTP View
```swift
DSOTPView(
    email: "user@example.com",
    onVerifyOTP: { otp in
        // Verify OTP
    },
    onResendOTP: {
        // Resend OTP
    },
    onGoBack: {
        // Go back
    },
    onClearError: {
        // Clear error
    }
)
```

#### Dashboard View
```swift
let dashboardData = DashboardData(
    totalIncidents: 1234,
    totalSubtitle: "+12% from last month",
    statistics: [
        DashboardStatistic(
            id: "1",
            title: "Pending",
            count: 45,
            percentage: "8% of total",
            icon: "clock.fill",
            color: Colors.statusPending
        )
        // ... more statistics
    ]
)

DSDashboardView(
    dashboardData: dashboardData,
    onRefresh: {
        // Refresh dashboard
    },
    onLoadDashboard: {
        // Load dashboard
    }
)
```

#### Submit Incident View
```swift
DSSubmitIncidentView(
    incidentTypes: incidentTypes,
    onSubmit: { incidentData in
        // Submit incident
        return "INC-12345"
    },
    onDismiss: {
        // Dismiss view
    },
    onGoBackToHome: {
        // Go back to home
    },
    onLoadIncidentTypes: {
        // Load incident types
    }
)
```

#### Home View
```swift
DSHomeView(
    onNavigateToDashboard: {
        // Navigate to dashboard
    },
    onNavigateToSubmitIncident: {
        // Navigate to submit incident
    },
    onLogout: {
        // Logout
    }
)
```

## Customization

### Custom Colors
You can extend the Colors struct to add custom colors:

```swift
extension Colors {
    static let customColor = Color("CustomColor")
}
```

### Custom Typography
You can extend the Typography struct to add custom fonts:

```swift
extension Typography {
    static let customFont = Font.system(size: 18, weight: .bold)
}
```

### Custom Components
You can create custom components by extending the existing ones or creating new ones following the same patterns.

## Requirements

- iOS 17.0+
- Swift 6.1+
- Xcode 15.0+

## Dependencies

- SwiftUI

## License

This package is part of the IncidentReportApp project.

## Contributing

When contributing to the design system:

1. Follow the existing naming conventions
2. Ensure all components are accessible
3. Add proper documentation
4. Include preview examples
5. Test in both light and dark modes 