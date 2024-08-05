import UIKit
import MatchMakerAuthentication
import Swinject

struct Header {
    var imageURL: URL?
    var name: String
    var location: String
}

public final class SettingsViewModel {
    
    var header: Header
    
    var didUpdateHeader: (() -> ())?
    
    let container: Container
    
    var authService: AuthService { container.resolve(AuthService.self)! }
    var userProfileRepository: UserProfileRepository { container.resolve(UserProfileRepository.self)! }
    
    public init(container: Container) {
        self.container = container
        
        self.header = Header(
            imageURL: nil,
            name: "Setup Your Name",
            location: "No Location")
    } 
    
    func logout() throws {
        try authService.logout()
        NotificationCenter.default.post(.didLogout)
    }
    
    func fetchUserProfile() async {
        
        do {
            let profile = try await self.userProfileRepository.fetchUserProfile()
            
            await MainActor.run { [weak self] in
                self?.updateHeader(with: profile)
            }
        } catch {
            print(error)
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
