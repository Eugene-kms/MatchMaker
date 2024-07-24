import UIKit
import SnapKit

class SettingsHeaderCell: UITableViewCell {
    
    private weak var containerView: UIView!
    private weak var stackView: UIStackView!
    private weak var profileImageView: UIImageView!
    private weak var nameLable: UILabel!
    private weak var descroptionLable: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with viewModel: SettingsViewModel.Header) {
        profileImageView.image = viewModel.image
        nameLable.text = viewModel.name
        descroptionLable.text = viewModel.description
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension SettingsHeaderCell {
    
    private func setupUI() {
        
        setupContainer()
        setupStackView()
        setupImageView()
        setupLables()
    }
    
    private func setupContainer() {
        let view = UIView()
        view.backgroundColor = .background
        
        contentView.addSubview(view)
        
        self.containerView = view
        
        view.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 24
        
        containerView.addSubview(stackView)
        
        self.stackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(74)
        }
        
        self.profileImageView = imageView
    }
    
    private func setupLables() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        
        let nameLbl = setupNameLbl()
        stackView.addArrangedSubview(nameLbl)
        self.nameLable = nameLbl
        
        let descriptionLbl = setupDescriptionLbl()
        stackView.addArrangedSubview(descriptionLbl)
        self.descroptionLable = descriptionLbl
        
        self.stackView.addArrangedSubview(stackView)
    }
    
    private func setupNameLbl() -> UILabel {
        let nameLbl = UILabel()
        nameLbl.font = .continueButton
        nameLbl.textColor = .text
        return nameLbl
    }
    
    private func setupDescriptionLbl() -> UILabel {
        let descriptionLbl = UILabel()
        descriptionLbl.font = .descriptionLbl
        descriptionLbl.textColor = .descriptionLblColor
        return descriptionLbl
    }
}
