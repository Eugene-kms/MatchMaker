import UIKit

public enum Fonts: String {
    case PoppinsBold = "Poppins-Bold"
    case PoppinsRegular = "Poppins-Regular"
    case AvenirRegular = "AvenirNextCyr-Regular"
    case AvenirMedium = "AvenirNextCyr-Medium"
    case AvenirBold = "AvenirNextCyr-Bold"
}

public extension UIFont {
    static var title: UIFont {
        UIFont(name: Fonts.PoppinsBold.rawValue, size: 45)!
    }
    
    static var subtitle: UIFont {
        UIFont(name: Fonts.AvenirRegular.rawValue, size: 18)!
    }
    
    static var textField: UIFont {
        UIFont(name: Fonts.AvenirMedium.rawValue, size: 18)!
    }
    
    static var otp: UIFont {
        UIFont(name: Fonts.AvenirBold.rawValue, size: 23.66)!
    }
    
    static var continueButton: UIFont {
        UIFont(name: Fonts.AvenirBold.rawValue, size: 20)!
    }
    
    static var bottomTitle: UIFont {
        UIFont(name: Fonts.PoppinsRegular.rawValue, size: 16)!
    }
    
    static var resendTitle: UIFont {
        UIFont(name: Fonts.PoppinsBold.rawValue, size: 16)!
    }
}
