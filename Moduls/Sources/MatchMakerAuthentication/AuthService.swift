import FirebaseAuth

public enum AuthError: Error {
    case noVerificationId
}

enum UserDefaultKey: String {
    case authenticationID
}

public struct User {
    public let uid: String
}

public protocol AuthService {
    var user: User? { get }
    var isAuthenticated: Bool { get }
    
    func requestOTP(forPhoneNumber phoneNumber: String) async throws
    func authenticate(withOTP otp: String) async throws -> User
    func logout() throws
}

public class AuthServiceLive: AuthService  {
    
    public var user: User? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return User(uid: currentUser.uid)
    }
    
    public var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }
    
    public init() {}
    
    public func requestOTP(forPhoneNumber phoneNumber: String) async throws {
        
        let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        
        UserDefaults.standard.set(verificationID, forKey: UserDefaultKey.authenticationID.rawValue)
    }
    
    public func authenticate(withOTP otp: String) async throws -> User {
        
        guard let verificationId = UserDefaults.standard.string(forKey: UserDefaultKey.authenticationID.rawValue) else { throw AuthError.noVerificationId }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: otp
        )
        
        let result = try await Auth.auth().signIn(with: credential)
        
        return User(uid: result.user.uid)
    }
    
    public func logout() throws {
        try Auth.auth().signOut()
    }
}
