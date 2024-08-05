import Foundation
import MatchMakerAuthentication
import MatchMakerLogin
import MatchMakerSettings

class DIContainer: MatchMakerSettingsDependencies, MatchMakerLoginDependencies {
    var authService: AuthService
    var userRepository: UserProfileRepository
    var profilePictureRepository: ProfilePictureRepository
    
    init() {
        let authService = AuthServiceLive()
        let userRepository = UserProfileRepositoryLive(authService: authService)
        let profilePictureRepository = ProfilePictureRepositoryLive(
            authService: authService,
            userProfileRepository: userRepository
        )
        
        self.authService = authService
        self.userRepository = userRepository
        self.profilePictureRepository = profilePictureRepository
    }
}
