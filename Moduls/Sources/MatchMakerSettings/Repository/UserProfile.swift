import Foundation

public struct UserProfile: Codable {
    public let fullName: String
    public let location: String
    public let profilePictureURL: URL?
    
    public init(fullName: String, location: String, profilePictureURL: URL? = nil) {
        self.fullName = fullName
        self.location = location
        self.profilePictureURL = profilePictureURL
    }
}
