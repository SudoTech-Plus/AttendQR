# Supabase Integration Guide

This document outlines how Supabase is configured and utilized within the AttendQR iOS application. The project relies on the `supabase-swift` library, bridging modern `async/await` calls with the Combine framework for reactive data flow in ViewModels.

## 1. Configuration & Secrets Management
To maintain security and prevent accidental exposure, sensitive API keys are never hardcoded in the Swift source code. Instead, they are read from a local `Secrets.plist` file.

- **`SupabaseConfig`** (`SupabaseConfig.swift`): A utility enum that securely reads `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY` from the `Secrets.plist` bundle resource.
- **`SupabaseManager`** (`SupabaseManager.swift`): A singleton that initializes and exposes the core `SupabaseClient` instance using the validated credentials from `SupabaseConfig`.

### Accessing the Client:
```swift
let client = SupabaseManager.shared.client
```

## 2. Repository Pattern & Combine Bridging
Supabase network operations are strictly isolated inside **Repository** classes (e.g., `RegisterRepository.swift`, `LoginRepository.swift`). Because the `supabase-swift` SDK is built around `async/await`, the app bridges these calls to Combine's `AnyPublisher` using `Future` and `Task`.

### Example (Querying Data):
```swift
func isEmailRegistered(email: String) -> AnyPublisher<Bool, Error> {
    Future { promise in
        Task {
            do {
                let results: [[String: AnyJSON]] = try await self.client.database
                    .from("users")
                    .select("email")
                    .eq("email", value: email)
                    .execute()
                    .value
                promise(.success(!results.isEmpty))
            } catch {
                promise(.failure(error))
            }
        }
    }
    .eraseToAnyPublisher()
}
```

## 3. Supported Sub-modules
The application currently integrates with several Supabase sub-services:

### Authentication (`client.auth`)
Handles user identity, registration, and OTP verification flows.
```swift
try await client.auth.signUp(email: email, password: password, data: ["username": .string(username), "role": .string(role)])
try await client.auth.verifyOTP(email: email, token: token, type: .signup)
```

### Database (`client.database`)
Handles Postgres database operations. Responses and insertions are strictly typed using `Codable` Swift structs (e.g., `UserRow`).
```swift
let userRow = UserRow(...)
try await client.database.from("users").insert(userRow).execute()
```

### Storage (`client.storage`)
Used to manage bucket assets, such as user avatars.
```swift
let bucket = client.storage.from("profile")
try await bucket.upload(path: fileName, file: imageData, options: FileOptions(contentType: "image/png"))
let avatarUrl = try bucket.getPublicURL(path: fileName).absoluteString
```

### Edge Functions (`client.functions`)
Used for triggering customized backend serverless functions, such as custom email sending logic.
```swift
struct OTPPayload: Encodable { let email: String; let username: String }

try await client.functions.invoke(
    "resend-email",
    options: .init(body: OTPPayload(email: email, username: username))
)
```
