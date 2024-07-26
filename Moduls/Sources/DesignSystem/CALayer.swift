import UIKit

public extension CALayer {
    
    func figmaShadow(offset: CGPoint, blur: CGFloat, color: UIColor, opacity: CGFloat) {
        masksToBounds = false
        shadowColor = color.withAlphaComponent(opacity).cgColor
        shadowOpacity = 1
        shadowRadius = blur
        shadowOffset = CGSize(width: offset.x, height: offset.y)
        
    }
}
