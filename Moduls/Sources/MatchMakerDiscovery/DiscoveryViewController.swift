import UIKit
import SnapKit
import SDWebImage
import DesignSystem

public struct User: Decodable {
    let uid: String
    let name: String
    let imageURL: URL
}

public enum SwipeDirection {
    case left
    case right
}

let mockUsers = [
    User(uid: "1", name: "Ashley", imageURL: URL(string: "https://picsum.photos/seed/ashley/584/360")!),
    User(uid: "2", name: "Emma", imageURL: URL(string: "https://picsum.photos/seed/emma/584/360")!),
    User(uid: "3", name: "Olivia", imageURL: URL(string: "https://picsum.photos/seed/olivia/584/360")!),
    User(uid: "4", name: "Sophia", imageURL: URL(string: "https://picsum.photos/seed/sophia/584/360")!)
]

class CardView: UIView {
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let nameLbl = UILabel()
    
    private let user: User
    
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

class CardStackView: UIView {
    private var cardViews: [CardView] = []
    
    var topCard: CardView? {
        cardViews.last
    }
    
    func addCard(_ card: CardView) {
        cardViews.append(card)
        addSubview(card)
        card.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func removeTopCard() {
        cardViews.removeLast()
    }
}

public class DiscoveryViewController: UIViewController {
    
    private let cardStackView = CardStackView()
    private let titleLbl = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCards()
        setupUI()
        setupGestureRecognisers()
    }
    
    private func loadCards() {
        for user in mockUsers {
            let cardView = CardView(user: user)
            cardStackView.addCard(cardView)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLbl)
        titleLbl.text = "Discovery"
        titleLbl.font = .navigationTitle2
        titleLbl.textColor = .black
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }
        
        //Card Stack View
        view.addSubview(cardStackView)
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func setupGestureRecognisers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        
        cardStackView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let topCard = cardStackView.topCard else { return }
        
        let translation = gesture.translation(in: view)
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        
        switch gesture.state {
        case .began: break
        case .changed:
            let rotationTransform = CGAffineTransform(rotationAngle: angle)
            let translationTransform = CGAffineTransform(
                translationX: translation.x,
                y: translation.y
            )
            topCard.transform = rotationTransform.concatenating(translationTransform)
        case .ended:
            handleSwipeEnd(topCard: topCard, translation: translation)
        default:
            break
        }
    }
    
    private func handleSwipeEnd(topCard: CardView, translation: CGPoint) {
        let swipeThreshold: CGFloat = 100
        
        if translation.x > swipeThreshold {
            swipeCard(.right)
        } else if translation.x < -swipeThreshold {
            swipeCard(.left)
        } else {
            resetCard(topCard)
        }
    }
    
    private func swipeCard(_ direction: SwipeDirection) {
        guard let topCard = cardStackView.topCard else { return }
        
        let translationX: CGFloat = direction == .right ? 300 : -300
        
        UIView.animate(withDuration: 0.3) {
            topCard.center = CGPoint(x: topCard.center.x + translationX, y: topCard.center.y)
            topCard.alpha = 0
        } completion: { _ in
            //tell our view model to fire network request
            
            self.cardStackView.removeTopCard()
        }
    }
    
    private func resetCard(_ card: CardView) {
        UIView.animate(withDuration: 0.2) {
            card.transform = .identity
        }
    }
}
