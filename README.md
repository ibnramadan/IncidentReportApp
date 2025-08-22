# IncidentReportApp

A comprehensive iOS application for incident reporting and management, built with SwiftUI and following clean architecture principles. The app provides a complete solution for users to report incidents, track their status, and view analytics through an intuitive dashboard.

## 📱 Features

### Core Features
- **User Authentication**: Secure login with email and OTP verification
- **Incident Reporting**: Submit detailed incident reports with priority levels and location tracking
- **Dashboard Analytics**: Visual representation of incident statistics and trends
- **Status Tracking**: Monitor incident status (Pending, In Progress, Resolved)
- **Type Management**: Categorize incidents by type for better organization
- **Location Services**: GPS coordinates for precise incident location

### User Experience
- **Modern UI/UX**: Clean, intuitive interface built with custom design system
- **Responsive Design**: Optimized for all iOS devices

## 🏗️ Architecture

The app follows **Clean Architecture** principles with a clear separation of concerns:

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │   Views     │ │ ViewModels  │ │ Coordinators│            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │  Entities   │ │ Use Cases   │ │ RepoProtocol│            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │    DTOs     │ │ Repositories│ │  Network    │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
IncidentReportApp/
├── IncidentReportApp/                    # Main App Target
│   ├── Assets.xcassets/                  # App assets and icons
│   ├── Coordinator/                      # Navigation coordination
│   │   ├── AppCoordinator.swift         # Main app coordinator
│   │   ├── AppCoordinatorView.swift     # Coordinator view wrapper
│   │   └── AppRoute.swift               # Navigation routes
│   ├── Data/                            # Data Layer
│   │   ├── Models/                      # Data Transfer Objects (DTOs)
│   │   │   ├── ChangeIncidentStatusDTO.swift
│   │   │   ├── DashboardDTO.swift
│   │   │   ├── IncidentDTO.swift
│   │   │   ├── IncidentsRequestDTO.swift
│   │   │   ├── IncidentsTypeDTO.swift
│   │   │   └── OtpDTO.swift
│   │   └── Repos/                       # Repository implementations
│   │       └── IncidentsRepo.swift
│   ├── DI/                              # Dependency Injection
│   │   └── AppDependencies.swift        # App dependency container
│   ├── Domain/                          # Domain Layer
│   │   ├── Entities/                    # Business entities
│   │   │   ├── DashboardEntity.swift
│   │   │   ├── IncidentEntity.swift
│   │   │   ├── IncidentRequestEntity.swift
│   │   │   ├── IncidentStatus.swift
│   │   │   ├── IncidentsTypeEntity.swift
│   │   │   └── OtpEntity.swift
│   │   ├── RepoProtocols/               # Repository protocols
│   │   │   └── IncidentsRepoProtocol.swift
│   │   └── UseCases/                    # Business logic
│   │       ├── ChangeIncidentStatusUseCase.swift
│   │       ├── DashboardUseCase.swift
│   │       ├── GetIncidentsTypesUseCase.swift
│   │       ├── GetIncidentsUseCase.swift
│   │       ├── LoginUseCase.swift
│   │       ├── OTPUseCase.swift
│   │       └── SubmitIncidentUseCase.swift
│   ├── Presentation/                    # Presentation Layer
│   │   ├── Dashboard/                   # Dashboard feature
│   │   │   ├── DashboardView.swift
│   │   │   └── DashboardViewModel.swift
│   │   ├── Home/                        # Home feature
│   │   │   ├── HomeView.swift
│   │   │   └── HomeViewModel.swift
│   │   ├── Login/                       # Authentication feature
│   │   │   ├── LoginView.swift
│   │   │   └── LoginViewModel.swift
│   │   ├── Otp/                         # OTP verification feature
│   │   │   ├── OTPDigitBox.swift
│   │   │   ├── OTPInputField.swift
│   │   │   ├── OTPView.swift
│   │   │   └── OTPViewModel.swift
│   │   └── SubmitIncident/              # Incident submission feature
│   │       ├── SubmitIncidentView.swift
│   │       └── SubmitIncidentViewModel.swift
│   └── IncidentReportAppApp.swift       # App entry point
├── Packages/                            # Swift Package Manager modules
│   ├── Coordinator/                     # Navigation coordination package
│   ├── DesignSystem/                    # UI/UX design system package
│   └── Networking/                      # Network layer package
└── Tests/                               # Test targets
    ├── IncidentReportAppTests/          # Unit tests
    └── IncidentReportAppUITests/        # UI tests
```

## 🧩 Modules

### 1. **Coordinator Package** (`Packages/Coordinator/`)
Navigation management using coordinator pattern:
- **BaseCoordinator**: Base coordinator implementation
- **CoordinatorProtocol**: Coordinator interface
- **NavigationCoordinatorView**: SwiftUI wrapper for coordinators
- **CoordinatorKey**: Environment key for coordinator injection

### 2. **DesignSystem Package** (`Packages/DesignSystem/`)
Comprehensive design system with reusable components:
- **Design Tokens**: Colors, Typography, Spacing, Corners, Shadows, Animations
- **UI Components**: Buttons, TextFields, Cards, Loading states, Error states
- **Complete Views**: Login, OTP, Dashboard, Submit Incident, Home views
- **Customizable**: Easy to extend and modify

### 3. **Networking Package** (`Packages/Networking/`)
Network layer abstraction:
- **ApiManager**: HTTP client implementation
- **ApiEndpoint**: Endpoint configuration
- **ApiError**: Error handling
- **ApiConstants**: API configuration constants

## 🔄 Data Flow

### 1. **User Authentication Flow**
```
LoginView → LoginViewModel → LoginUseCase → IncidentsRepo → API
```

### 2. **Incident Submission Flow**
```
SubmitIncidentView → SubmitIncidentViewModel → SubmitIncidentUseCase → IncidentsRepo → API
```

### 3. **Dashboard Data Flow**
```
DashboardView → DashboardViewModel → DashboardUseCase → IncidentsRepo → API
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 6.1+

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd IncidentReportApp
   ```

2. **Open in Xcode**
   ```bash
   open IncidentReportApp.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Configuration

1. **API Configuration**
   - Update `ApiConstants.swift` in the Networking package with your API endpoints
   - Configure authentication tokens if required

2. **Design System Customization**
   - Modify design tokens in `Packages/DesignSystem/Sources/DesignSystem/`
   - Customize colors, typography, and spacing as needed

## 📱 Usage

### 1. **Authentication**
- Launch the app
- Enter your email address
- Verify with OTP sent to your email
- Access the main application

### 2. **Dashboard**
- View incident statistics and analytics
- Monitor incident status distribution
- Refresh data with pull-to-refresh
- Navigate to other sections

### 3. **Submit Incident**
- Tap "Submit Incident" from home screen
- Fill in incident details:
  - Type (select from available types)
  - Priority level (1-5)
  - Description
  - Location (GPS coordinates)
- Submit the incident

### 4. **Navigation**
- Use the home screen to navigate between features
- Back navigation is handled automatically
- Modal presentations for forms and pickers

## 🧪 Testing

### Unit Tests
```bash
# Run unit tests
xcodebuild test -scheme IncidentReportApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

### UI Tests
```bash
# Run UI tests
xcodebuild test -scheme IncidentReportAppUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🔧 Development

### Adding New Features

1. **Create Domain Layer**
   ```swift
   // Domain/Entities/NewEntity.swift
   struct NewEntity {
       let id: String
       let title: String
   }
   
   // Domain/UseCases/NewUseCase.swift
   class NewUseCase {
       func execute() async throws -> [NewEntity] {
           // Business logic
       }
   }
   ```

2. **Create Data Layer**
   ```swift
   // Data/Models/NewDTO.swift
   struct NewDTO: Codable {
       let id: String
       let title: String
   }
   ```

3. **Create Presentation Layer**
   ```swift
   // Presentation/NewFeature/NewView.swift
   struct NewView: View {
       @StateObject private var viewModel: NewViewModel
       
       var body: some View {
           // UI implementation
       }
   }
   ```

### Design System Usage

```swift
import DesignSystem

// Using design tokens
Text("Hello World")
    .heading1()
    .foregroundColor(Colors.primary)

// Using components
DSButton("Submit", style: .primary) {
    // Action
}

// Using complete views
DSLoginView(
    onLogin: { email in
        // Handle login
    },
    onClearError: {
        // Clear error
    }
)
```


### Code Style
- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

---

**Built with ❤️ using SwiftUI and Clean Architecture**
