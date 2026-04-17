import Foundation
import Combine

/// Repository handling authentication requests
class LoginRepository {
    
    // In a real implementation, you would initialize the Supabase client here:
    // private let client = SupabaseClient(supabaseURL: URL(string: SupabaseConfig.url)!, supabaseKey: SupabaseConfig.anonKey)
    
    /// Simulated login request using Supabase secrets access
    func login(email: String, password: String) -> AnyPublisher<Bool, Error> {
        // Validation check for configuration
        guard SupabaseConfig.isConfigured else {
            return Fail(error: NSError(domain: "Config", code: 500, userInfo: [NSLocalizedDescriptionKey: "Supabase secrets are not configured in Secrets.plist"]))
                .eraseToAnyPublisher()
        }
        
        print("🚀 Initializing login with Supabase URL: \(SupabaseConfig.url)")
        
        // Simulating a network request with a 1.5s delay
        return Future<Bool, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Simple hardcoded logic for demonstration
                if email.contains("@") && password.count >= 6 {
                    promise(.success(true))
                } else {
                    let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials. Try using a valid email and at least 6 characters for the password."])
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
