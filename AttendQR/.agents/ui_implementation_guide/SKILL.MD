# UI Implementation Guide

This document outlines the UI development patterns and standards used in the AttendQR application. The project is built entirely using **SwiftUI**, emphasizing a consistent, modular, and premium dark-mode aesthetic.

## 1. Design System & Theming
The application relies on a centralized color and typography system rather than hardcoding styling values directly in views.

- **`AppColors`** (`AppColors.swift`): Defines semantic colors such as `.primary`, `.secondary`, `.accent`, `.surface`, `.textPrimary`, `.textTertiary`, and `.error`. Always use these instead of raw `Color` values.
- **Dark Mode Focus**: The app enforces a dark mode experience globally (managed via `ThemeManager`). Use `AppColors.adaptiveBackground()` inside a `ZStack` as the base layer for full-screen views.
- **Glassmorphism & Depth**: Cards, modals, and containers utilize partial opacity on `.surface` colors combined with subtle drop shadows and thin, low-opacity borders to create depth.

### Example Card Style:
```swift
.background(
    RoundedRectangle(cornerRadius: 24)
        .fill(AppColors.surface.opacity(0.8))
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
)
.overlay(
    RoundedRectangle(cornerRadius: 24)
        .stroke(Color.white.opacity(0.05), lineWidth: 1)
)
```

## 2. Core Reusable Components
To maintain UI consistency and accelerate development, primitive UI elements are wrapped in reusable components located in `src/core/components`. **Always use these custom components over standard SwiftUI equivalents when applicable.**

- **`CustomText`**: Ensures consistent typography, sizes, and semantic font weights.
- **`CustomInputField`**: Provides standardized text fields featuring built-in leading icons, secure text toggling, and consistent padding/styling.
- **`CustomButton`**: The standard primary action button, which includes built-in loading states.
- **`AnimatedListItem` / `AnimatedCard`**: Used for list elements and dashboard cards to provide smooth entry animations and consistent corner radii.
- **`AnimatedDialogWrapper` / `AnimatedDialog`**: Standardized custom modals for alerts, success states, or user actions.

### Example Usage:
```swift
CustomText(
    title: "AttendQR",
    fontSize: 32,
    fontColor: .white,
    weight: .bold
)

CustomInputField(
    icon: "envelope.fill",
    placeholder: "Email",
    text: $viewModel.email
)
```

## 3. Layout Patterns
- **Base Structure**: Screens typically begin with a `ZStack` containing the adaptive background, overlaid with a `ScrollView` and/or `VStack` for content layout.
- **Spacing**: Use standard spacing increments (e.g., `8`, `16`, `24`, `32`) in `VStack` and `HStack` initializers.
- **Icons**: The application primarily utilizes SF Symbols (e.g., `Image(systemName: "envelope.fill")`) sized appropriately.
- **State Feedback**: UI elements should immediately react to `ViewModel` states (e.g., conditionally rendering a `ProgressView()` when `isLoading` is true, or displaying `errorMessage` strings).

## 4. Navigation & Toolbars
- **Bottom Navigation**: Tab navigation is implemented using custom components (e.g., `CustomBottomNavigation.swift`) instead of SwiftUI's native `TabView`. This allows for highly customized routing, floating action buttons (`AnimatedFAB.swift`), and tailored animations.
- **Routing Transitions**: Screen-to-screen transitions at the root level are managed by the `Router` environment object, utilizing explicit `.easeInOut` animations during state changes.
