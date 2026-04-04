# AttendQR AI Agent Guidelines

This document outlines the project structure and guidelines for AI agents working on the `AttendQR` iOS application. Please adhere to these architectural standards when generating code, refactoring, or adding new features.

## Project Structure (`AttendQR/src/`)

The application is modularized into `core` and `features` directories to maintain clean architecture.

### 1. `core/`
Contains app-wide, reusable components and shared business logic.
- **`components/`**: Reusable SwiftUI views (e.g., `StatCard`, `CustomBottomNavigation`, `ThemeToggle`). Any UI component used across multiple features must reside here.
- **`repository/`**: Handles data operations (API calls, local storage fetching). Controllers/View Models should fetch from here, avoiding direct network calls in the UI layer.
- **`utils/`**: Helper classes, extensions, and global state managers (e.g., `ThemeManager`). Keep classes focused on a single responsibility.
- **`view_model/`**: Contains global View Models (e.g. `SplashViewModel`) that handle app-wide state orchestration. Feature-specific view models reside within their respective `features/` folders.

### 2. `features/`
Contains domain-specific logic, structured chronologically or functionally by user experience.
- **`auth/`**: Registration, Login workflows, and session management views.
- **`notifications/`**: Views and management models for user notifications.
- **`organizer/`**: Views, models, and sub-features related to an Organizer's role (events, profile, home dashboard).
- **`user/`**: Views, models, and sub-features related to an Attendee's role (events, profile, home dashboard).

## Coding Conventions & Guidelines

- **UI Framework Options**: Rely aggressively on **SwiftUI**. Avoid UIKit unless necessary natively.
- **Theming**: The app implements a 'ThemeManager' in `core/utils/ThemeManager.swift`. All color logic must adapt to dark mode using environment variables (`@Environment(\.colorScheme)`) or predefined App colors (e.g., `AppColors`) if available. Do not hardcode static hex values where dynamic colors are expected constraint-wise.
- **State Management**: Leverage standard property wrappers like `@State`, `@Binding`, and `@StateObject`/`@EnvironmentObject` where appropriate. Complex logic and networking should be offloaded to an `ObservableObject` View Model or Repository, instead of clustering the `.swift` View bodies.
- **Component Reusability**: Do not duplicate styling rules. Rely on `core/components/` and parameterize sub-views.

## Agent Instructions
When you are tasked with creating a new feature:
1. Try to utilize existing common components from `core/components/`. 
2. Determine if the file belongs in `core/` (global utility) or `features/` (domain-specific).
3. If an entire system needs refactoring, consult `core/utils` or `ThemeManager/AppColors` to ensure you are abiding by existing design norms.
