import UIKit

public class GradientView: UIView {
    
    public var colors: [UIColor] = []
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(colours: colors)
        applyShadow()
    }
    
    public func configureGradient(colours: [UIColor]) {
        self.colors = colours
        applyGradient(colours: colours)
        applyShadow()
    }
    
    public func applyShadow() {
        let shadow = UIView()
        
        shadow.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
        shadow.layer.shadowOffset = CGSize(width: 0, height: 7)
        shadow.layer.shadowRadius = 64
        shadow.layer.shadowPath = UIBezierPath(roundedRect: shadow.bounds, cornerRadius: shadow.layer.cornerRadius).cgPath
        shadow.layer.shadowOpacity = 1
        
    }
    
}

public extension UIView {
    
    func applyGradient(colours: [UIColor], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colours.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.name = "gradientLayer"
        
        if let oldLayer = self.layer.sublayers?.first(where: { $0.name == "gradientLayer" }) {
            self.layer.replaceSublayer(oldLayer, with: gradientLayer)
        } else {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}



