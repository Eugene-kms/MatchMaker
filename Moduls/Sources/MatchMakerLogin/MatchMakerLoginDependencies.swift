import Foundation
import MatchMakerAuthentication

public protocol MatchMakerLoginDependencies {
    var authService: AuthService { get }
}
