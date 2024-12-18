import UIKit

public extension UIButton {
    func styleLogoutButton() {
        titleLabel?.font = .continueButton
        titleLabel?.textColor = .white
        
        layer.cornerRadius = 14
        layer.masksToBounds = true
        
        applyGradient(colours: [UIColor(resource: .accent), UIColor(resource: .accentGradient)])
    }
}
