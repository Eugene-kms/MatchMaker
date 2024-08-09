import Foundation
import MatchMakerAuthentication
import Swinject

public final class PhoneNumberViewModel {
    
    private let authService: AuthService
    private let container: Container
    private let coordinator: PhoneNumberCoordinator
    
    public init(container: Container, coordinator: PhoneNumberCoordinator) {
        self.container = container
        self.coordinator = coordinator
        self.authService = container.resolve(AuthService.self)!
    }
    
    public func requestOTP(with phoneNumber: String) async throws {
        try await authService.requestOTP(forPhoneNumber: phoneNumber)
        
        await MainActor.run {
            didReceiveOTPSuccessfully()
        }
    }
    
    private func didReceiveOTPSuccessfully() {
        coordinator.presentOTP()
    }
}
