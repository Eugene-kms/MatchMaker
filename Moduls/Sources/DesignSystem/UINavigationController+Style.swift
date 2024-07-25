import UIKit

public extension UINavigationController {
    static func styleMatchMaker() {
        
        let appearence = UINavigationBar.appearance()
        
        appearence.tintColor = .accent
        
        let imgBack = UIImage(resource: .chevronLeft)

        appearence.backIndicatorImage = imgBack
        appearence.backIndicatorTransitionMaskImage = imgBack
        
        appearence.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}
