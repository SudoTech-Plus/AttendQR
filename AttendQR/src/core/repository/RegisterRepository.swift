import Foundation
import Combine
import Supabase

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Repository handling user registration and verification
class RegisterRepository {
    private let client = SupabaseManager.shared.client
    
    /// Checks if the email is already registered in the users table
    func isEmailRegistered(email: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            Task {
                do {
                    // We only select "email" to avoid decoding errors for other columns in dirty data
                    let results: [[String: AnyJSON]] = try await self.client.database
                        .from("users")
                        .select("email")
                        .eq("email", value: email)
                        .execute()
                        .value
                    promise(.success(!results.isEmpty))
                } catch {
                    print("❌ RegisterRepository.isEmailRegistered error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Checks if the username is already taken
    func isUsernameTaken(username: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            Task {
                do {
                    // We only select "username" to avoid decoding errors for other columns in dirty data
                    let results: [[String: AnyJSON]] = try await self.client.database
                        .from("users")
                        .select("username")
                        .eq("username", value: username)
                        .execute()
                        .value
                    promise(.success(!results.isEmpty))
                } catch {
                    print("❌ RegisterRepository.isUsernameTaken error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Performs user registration: Signs up via Auth and creates a record in the users table
    func register(email: String, password: String, username: String, role: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            Task {
                do {
                    print("⏳ RegisterRepository: Starting auth sign up...")
                    // 1. Sign up via Supabase Auth
                    let _ = try await self.client.auth.signUp(
                        email: email,
                        password: password,
                        data: ["username": .string(username), "role": .string(role)]
                    )
                    
                    print("⏳ RegisterRepository: Uploading default avatar...")
                    // 2. Upload default profile picture if available
                    let imageUrl = try? await self.uploadDefaultAvatar(username: username)
                    
                    print("⏳ RegisterRepository: Inserting into users table...")
                    // 3. Insert into the users table
                    let userRow = UserRow(
                        username: username,
                        full_name: username, // Using username as full_name from the UI field
                        email: email,
                        role: role,
                        image_url: imageUrl
                    )
                    
                    try await self.client.database
                        .from("users")
                        .insert(userRow)
                        .execute()
                    
                    print("✅ RegisterRepository: Registration complete.")
                    promise(.success(true))
                } catch {
                    print("❌ RegisterRepository.register error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Internal helper to upload the "Logo" asset as the default avatar
    private func uploadDefaultAvatar(username: String) async throws -> String? {
        var imageData: Data?
        
        #if canImport(UIKit)
        if let image = UIImage(named: "Logo") {
            imageData = image.pngData()
        }
        #elseif canImport(AppKit)
        if let image = NSImage(named: "Logo") {
            if let tiffData = image.tiffRepresentation,
               let bitmap = NSBitmapImageRep(data: tiffData) {
                imageData = bitmap.representation(using: .png, properties: [:])
            }
        }
        #endif
        
        guard let finalData = imageData else {
            print("⚠️ RegisterRepository: 'Logo' asset not found or failed to convert to PNG data.")
            return nil
        }
        
        let fileName = "avatars/\(username).png"
        let bucket = client.storage.from("profile")
        
        // Upload the data
        do {
            try await bucket.upload(
                path: fileName,
                file: finalData,
                options: FileOptions(contentType: "image/png")
            )
            
            // Return the public URL
            return try bucket.getPublicURL(path: fileName).absoluteString
        } catch {
            print("⚠️ RegisterRepository: Avatar upload failed: \(error)")
            return nil // Continue without avatar rather than failing registration
        }
    }
    
    /// Calls the 'resend-email' Edge Function to deliver the OTP
    func sendOTP(email: String, username: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            Task {
                do {
                    print("⏳ RegisterRepository: triggering sendOTP edge function...")
                    struct OTPPayload: Encodable {
                        let email: String
                        let username: String
                    }
                    
                    try await self.client.functions
                        .invoke(
                            "resend-email",
                            options: .init(body: OTPPayload(email: email, username: username))
                        )
                    
                    promise(.success(true))
                } catch {
                    // Log error but we might still proceed if the edge function is just for custom email
                    print("⚠️ Edge Function 'resend-email' failed: \(error)")
                    promise(.success(true)) 
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Verifies the OTP token for the user
    func verifyOTP(email: String, token: String) -> AnyPublisher<Bool, Error> {
        Future { promise in
            Task {
                do {
                    print("⏳ RegisterRepository: verifying OTP...")
                    try await self.client.auth.verifyOTP(
                        email: email,
                        token: token,
                        type: .signup
                    )
                    promise(.success(true))
                } catch {
                    print("❌ RegisterRepository.verifyOTP error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
// MARK: - Models
/// Helper structure for the users table rows - made optional for resilience
struct UserRow: Codable {
    let username: String?
    let full_name: String?
    let email: String?
    let role: String?
    let image_url: String?
}
