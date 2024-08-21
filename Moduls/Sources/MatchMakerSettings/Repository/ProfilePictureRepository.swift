import UIKit
import FirebaseStorage
import MatchMakerAuthentication

public enum ProfilePictureRepositoryError: Error {
    case noAuthenticated
    case compressionFailed
}

public protocol ProfilePictureRepository {
    func upload(_ image: UIImage) async throws
}

public class ProfilePictureRepositoryLive: ProfilePictureRepository {
    
    private let reference: StorageReference
    private let authService: AuthService
    private let userProfileRepository: UserProfileRepository
    private let profilePictureSize = CGSize(width: 512, height: 512)
    private var uploadTask: StorageUploadTask?
    
    public init(authService: AuthService, userProfileRepository: UserProfileRepository) {
        reference = Storage.storage().reference().child("profilePicture")
        self.authService = authService
        self.userProfileRepository = userProfileRepository
    }
    
    public func upload(_ image: UIImage) async throws {
        uploadTask?.cancel()
        
        guard let user = authService.user else {
            throw ProfilePictureRepositoryError.noAuthenticated
        }
        
        let userReference = reference.child("\(user.uid).jpg")
        
        let resizedImage = image.resize(to: profilePictureSize)
        
        guard let data = resizedImage.jpegData(compressionQuality: 0.95) else {
            throw ProfilePictureRepositoryError.compressionFailed
        }
        
        let _ = try await uploadToFirebase(data, reference: userReference)
        
        let url = try await userReference.downloadURL()
        
        try userProfileRepository.saveProfilePictureURL(url)
    }
    
    private func uploadToFirebase(_ data: Data, reference: StorageReference) async throws -> StorageMetadata {
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StorageMetadata, Error>) in
            uploadTask = reference.putData(data) { metadata, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let metadata {
                    continuation.resume(returning: metadata)
                }
            }
        }
    }
}

extension UIImage {
    
    func resize(to targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

