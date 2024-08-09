import MatchMakerAuthentication
import Foundation
import Swinject

enum OTPViewModelError: Error {
    case otpNoValid
}

public final class OTPViewModel {
    
    private var authService: AuthService
    private let container: Container
    
    init(container: Container) {
        self.container = container
        self.authService = container.resolve(AuthService.self)!
    }
    
    func verifyOTP(with digits: [String]) async throws {
        
        guard validate(digits: digits)  else {
            throw OTPViewModelError.otpNoValid }
        
        let otp = combineToOTP(digits: digits)
        
        let user = try await authService.authenticate(withOTP: otp)
        print(user.uid)
        
        await MainActor.run {
            NotificationCenter.default.post(.didLoginSuccessfully)
        }
    }
    
    private func validate(digits: [String]) -> Bool {
        
        for digit in digits {
            guard digit.isNumber else { return false }
        }
        return true
    }
    
    private func combineToOTP(digits: [String]) -> String {
        digits.joined()
    }
}

fileprivate extension String {
    var isValidDigit: Bool {
        guard count == 1 else { return false }
        guard isNumber else { return false }
        return true
    }
}

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}
