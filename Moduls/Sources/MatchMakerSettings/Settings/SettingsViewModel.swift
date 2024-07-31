import UIKit
import MatchMakerAuthentication

struct Header {
    var imageURL: URL?
    var name: String
    var location: String
}

public final class SettingsViewModel {
    
    var header: Header
    
    var didUpdateHeader: (() -> ())?
    
    let authService: AuthService
    let userProfileRepository: UserProfileRepository
    let profilePictureRepository: ProfilePictureRepository
    
    public init(authService: AuthService, userProfileRepository: UserProfileRepository, profilePictureRepository: ProfilePictureRepository) {
        self.authService = authService
        self.userProfileRepository = userProfileRepository
        self.profilePictureRepository = profilePictureRepository
        
        self.header = Header(
            imageURL: nil,
            name: "Setup Your Name",
            location: "No Location")
    }
    
    func logout() throws {
        try authService.logout()
        NotificationCenter.default.post(.didLogout)
    }
    
    func fetchUserProfile() {
        
        Task { [weak self] in
            do {
                guard let profile = try await self?.userProfileRepository.fetchUserProfile() else { return }
                
                await MainActor.run { [weak self] in
                    self?.updateHeader(with: profile)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func updateHeader(with userProfile: UserProfile) {
        self.header = Header(
            imageURL: userProfile.profilePictureURL,
            name: userProfile.fullName,
            location: userProfile.location)
        
        didUpdateHeader?()
    }
}
