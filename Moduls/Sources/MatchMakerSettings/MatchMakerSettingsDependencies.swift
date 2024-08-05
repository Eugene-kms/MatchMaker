import Foundation
import MatchMakerAuthentication

public protocol MatchMakerSettingsDependencies {
    var authService: AuthService { get }
    var userRepository: UserProfileRepository { get }
    var profilePictureRepository: ProfilePictureRepository { get }
}
