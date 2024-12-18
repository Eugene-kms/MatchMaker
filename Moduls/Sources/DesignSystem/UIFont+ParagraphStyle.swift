import UIKit

public extension UIFont {
    func paragraphStyle(forLineHight lineHight: CGFloat) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHight - pointSize - (lineHeight - pointSize)
        
        return paragraphStyle
    }
}
