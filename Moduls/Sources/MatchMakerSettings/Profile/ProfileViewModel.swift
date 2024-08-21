import UIKit
import MatchMakerAuthentication
import MatchMakerCore
import Swinject

enum TextFieldType {
    case name
    case location
}

enum Row {
    case profilePicture
    case textField(TextFieldType)
}

public final class ProfileViewModel {
    var selectedImage: UIImage?
    var fullName: String = ""
    var location: String = ""
    var profilePictureURL: URL? = nil
    
    var rows: [Row]
    
    let container: Container
    
    private let coordinator: ProfileCoordinator
    
    var authService: AuthService { container.resolve(AuthService.self)! }
    var userProfileRepository: UserProfileRepository { container.resolve(UserProfileRepository.self)! }
    var profilePictureRepository: ProfilePictureRepository { container.resolve(ProfilePictureRepository.self)! }
    
    init(container: Container, coordinator: ProfileCoordinator) {
        self.container = container
        self.coordinator = coordinator
        
        rows = [
            .profilePicture,
            .textField(.name),
            .textField(.location)
        ]
        
        if let profile = userProfileRepository.profile {
            fullName = profile.fullName
            location = profile.location
            profilePictureURL = profile.profilePictureURL
        }
    }
    
    func save() async throws {
        
        let profile = UserProfile(
            fullName: fullName,
            location: location,
            profilePictureURL: profilePictureURL
        )
        
        try userProfileRepository.saveUserProfile(profile)
        
        if let selectedImage {
            try await profilePictureRepository.upload(selectedImage)
        }
        await MainActor.run {
            coordinator.dismiss()
        }
    }
    
    func modelForTextFieldRow(_ type: TextFieldType) -> ProfileTextFieldCell.Model {
        
        switch type {
        case .name:
            ProfileTextFieldCell.Model(
                icon: UIImage(resource: .user),
                placeholderText: "Your name",
                text: fullName,
                isValid: isFullNameValid()
            )
            
        case .location:
            ProfileTextFieldCell.Model(
                icon: UIImage(resource: .location),
                placeholderText: "Location",
                text: location,
                isValid: isLocationValid()
            )
        }
    }
    
    private func isFullNameValid() -> Bool {
        fullName.count > 2
    }
    
    private func isLocationValid() -> Bool {
        location.count > 3
    }
}
