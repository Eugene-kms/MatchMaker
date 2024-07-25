import UIKit

public final class SettingsViewModel {
    
    struct Header {
        let image: UIImage
        let name: String
        let description: String
    }
    
    let header: Header
    
    public init() {
        header = Header(
            image: UIImage(resource: .avatar),
            name: "Setup Your Name",
            description: "No Location")
    }
}
