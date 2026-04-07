import Foundation
import Combine

/// Repository handling authentication requests
class LoginRepository {
    
    /// Simulated login request
    func login(email: String, password: String) -> AnyPublisher<Bool, Error> {
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
