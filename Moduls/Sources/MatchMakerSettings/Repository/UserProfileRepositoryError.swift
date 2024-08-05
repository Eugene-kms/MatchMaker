import Foundation

public enum UserProfileRepositoryError: Error {
    case notAuthenticated
}

extension UserProfileRepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User is not authenticated!"
        }
    }
}
