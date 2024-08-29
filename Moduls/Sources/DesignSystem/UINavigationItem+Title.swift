import UIKit

public extension UINavigationItem {
    func setMatchMakerTitle(_ title: String) {
        let titleLable = UILabel()
        titleLable.text = title
        titleLable.font = .settingsTitle
        titleLable.textColor = .text
        titleView = titleLable
    }
}
