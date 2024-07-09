import UIKit

public enum Fonts: String {
    case PoppinsBold = "Poppins-Bold"
    case AvenirNextRegular = "AvenirNext-Regular"
    case AvenirNextDemi = "AvenirNext-Demi"
}

public extension UIFont {
    static var title: UIFont {
        UIFont(name: Fonts.PoppinsBold.rawValue, size: 45)!
    }
    
    static var subtitle: UIFont {
        UIFont(name: Fonts.AvenirNextRegular.rawValue, size: 18)!
    }
    
    static var continueButton: UIFont {
        UIFont(name: Fonts.AvenirNextDemi.rawValue, size: 20)!
    }
}
