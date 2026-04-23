# State Management Guide

This document outlines the state management patterns currently implemented in the AttendQR application. The project strictly follows the **MVVM (Model-View-ViewModel)** architectural pattern integrated with SwiftUI's reactive state wrappers.

## 1. Global App State (`@EnvironmentObject`)
Global dependencies and application-wide states are managed using `@EnvironmentObject`. These are instantiated at the root of the application and injected into the environment, making them accessible from any child view without the need to pass them down explicitly through initializers.

### Core Implementations:
- **`Router`** (`AppRoute.swift`): Manages the global navigation state (e.g., navigating between `splash`, `login`, `main`) and holds transient application data needed across multiple screens (e.g., `pendingEmail`, `pendingUsername` during the registration/OTP flow).
- **`ThemeManager`** (`ThemeManager.swift`): Manages global UI preferences (e.g., `isDarkMode`).

### Usage in Views:
```swift
@EnvironmentObject var router: Router
@EnvironmentObject var themeManager: ThemeManager
```

## 2. Feature-Level State (`@StateObject` & `ObservableObject`)
Each significant view or feature module has a dedicated ViewModel responsible for business logic, data fetching, and maintaining view-specific state. 

- ViewModels conform to the `ObservableObject` protocol.
- Properties that mutate and require UI updates are marked with the `@Published` property wrapper.
- The View owns its ViewModel using the `@StateObject` wrapper to ensure the ViewModel's lifecycle is safely tied to the View without being recreated unnecessarily during UI redraws.

### Core Implementations:
- `UserHomeViewModel`
- `RegisterViewModel`
- `LoginViewModel`
- `OTPViewModel`
- `OrganizerProfileViewModel`

### Usage in Views:
```swift
struct UserHomeView: View {
    @StateObject private var viewModel = UserHomeViewModel()
    
    var body: some View {
        // UI code reacting to viewModel
    }
}
```

### Usage in ViewModels:
```swift
class UserHomeViewModel: ObservableObject {
    @Published var userName: String = "User"
    @Published var isLoading: Bool = false
    
    init() {
        fetchUserData()
    }
    
    func fetchUserData() {
        isLoading = true
        // ... network call or data processing
        
        DispatchQueue.main.async {
            self.userName = "Frouen"
            self.isLoading = false
        }
    }
}
```

## 3. Asynchronous State Updates
All mutations to `@Published` properties that occur after a background task (such as fetching data or a timer) must be dispatched to the main thread to ensure thread-safe UI updates. This is typically handled using `DispatchQueue.main.async` or `DispatchQueue.main.asyncAfter`.
