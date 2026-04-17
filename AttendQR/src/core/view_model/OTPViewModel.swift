import Foundation
import Combine

class OTPViewModel: ObservableObject {
    @Published var otpCode = Array(repeating: "", count: 4)
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var verificationSuccess = false
    
    var email: String = "" // Needs to be set from the previous screen
    var username: String = ""
    
    private let repository = RegisterRepository()
    private var cancellables = Set<AnyCancellable>()
    
    func verify() {
        let code = otpCode.joined()
        guard code.count == 4 else {
            errorMessage = "Please enter the full 4-digit code."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        repository.verifyOTP(email: email, token: code)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.verificationSuccess = true
            }
            .store(in: &cancellables)
    }
    
    func resend() {
        guard !email.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        repository.sendOTP(email: email, username: username)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.errorMessage = "Code resent successfully."
            }
            .store(in: &cancellables)
    }
}
