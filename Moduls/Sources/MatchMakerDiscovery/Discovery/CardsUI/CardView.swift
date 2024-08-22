import UIKit
import SnapKit

class CardView: UIView {
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let nameLbl = UILabel()
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        setupUI()
        cinfigure(with: user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        //Add corner radius to the card
        layer.cornerRadius = 16
        clipsToBounds = true
        
        //Image View
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //Overlay View (for gradient effect)
        addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0.6, 1.0]
        overlayView.layer.addSublayer(gradientLayer)
        
        //Name Lable
        addSubview(nameLbl)
        nameLbl.font = .cardTitle
        nameLbl.textColor = .white
        nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func cinfigure(with user: User) {
        nameLbl.text = user.name
        imageView.sd_setImage(with: user.imageURL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.layer.sublayers?.first?.frame = overlayView.bounds
    }
}


