import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var fullName = "" // Mapped to username
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var registerSuccess = false
    
    private let repository = RegisterRepository()
    private var cancellables = Set<AnyCancellable>()
    
    func register() {
        // 1. Basic validation
        guard validateFields() else { return }
        
        isLoading = true
        errorMessage = nil
        
        // 2. check email and username availability
        Publishers.Zip(
            repository.isEmailRegistered(email: email.lowercased()),
            repository.isUsernameTaken(username: fullName)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.isLoading = false
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] isEmailTaken, isUsernameTaken in
            if isEmailTaken {
                self?.isLoading = false
                self?.errorMessage = "This email is already registered."
                return
            }
            if isUsernameTaken {
                self?.isLoading = false
                self?.errorMessage = "This username is already taken."
                return
            }
            
            // 3. Proceed to register
            self?.performRegistration()
        }
        .store(in: &cancellables)
    }
    
    private func performRegistration() {
        repository.register(
            email: email.lowercased(),
            password: password,
            username: fullName,
            role: "user"
        )
        .flatMap { [weak self] success -> AnyPublisher<Bool, Error> in
            guard let self = self else { return Fail(error: NSError(domain: "Auth", code: 0)).eraseToAnyPublisher() }
            // 4. Send OTP via Edge Function
            return self.repository.sendOTP(email: self.email.lowercased(), username: self.fullName)
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] _ in
            self?.registerSuccess = true
        }
        .store(in: &cancellables)
    }
    
    private func validateFields() -> Bool {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required."
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        
        // Password strength: Min 8 chars, one letter, one number
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        if !passwordTest.evaluate(with: password) {
            errorMessage = "Password must be at least 8 characters long and include both letters and numbers."
            return false
        }
        
        return true
    }
}
