import Foundation
import MatchMakerAuthentication
import Swinject

public final class PhoneNumberViewModel {
    
    var authService: AuthService { container.resolve(AuthService.self)! }
    let container: Container
    
    public init(container: Container) {
        self.container = container
    }
    
    public func requestOTP(with phoneNumber: String) async throws {
        try await authService.requestOTP(forPhoneNumber: phoneNumber)
    }
}
