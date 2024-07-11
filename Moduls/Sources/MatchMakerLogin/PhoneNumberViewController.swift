import UIKit
import SnapKit
import PhoneNumberKit
import DesignSystem

enum PhoneNumberStrings: String {
    case title = "Can I get those digits?"
    case subtitle = "Enter your phone number below to create your free account."
    case continueButton = "Continue"
}

public class PhoneNumberViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var textField: PhoneNumberTextField!
    private weak var continueButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        subscribeToTextChange()
        textFieldDidChange()
        
        textField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToTextChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: self)
    }
}

extension PhoneNumberViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor(resource: .background)
        
        setupStackView()
        setupTitle()
        setupSubtitle()
        setupTextField()
        setupContinueButton()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        self.stackView = stackView
    }
    
    private func setupTitle() {
        let title = UILabel()
        
        let attributedString = NSAttributedString(
            string: PhoneNumberStrings.title.rawValue,
            attributes: [.paragraphStyle: UIFont.title.paragraphStyle(forLineHight: 50.5)])
        
        title.attributedText = attributedString
        title.text = PhoneNumberStrings.title.rawValue
        title.font = .title
        title.textColor = UIColor(resource: .title)
        title.numberOfLines = 0
        
        stackView.addArrangedSubview(title)
    }
    
    private func setupSubtitle() {
        let subtitle = UILabel()
        
        let attributedString = NSAttributedString(
            string: PhoneNumberStrings.subtitle.rawValue,
            attributes: [.paragraphStyle: UIFont.subtitle.paragraphStyle(forLineHight: 26.5)])
        
        subtitle.attributedText = attributedString
        subtitle.text = PhoneNumberStrings.subtitle.rawValue
        subtitle.font = .subtitle
        subtitle.textColor = UIColor(resource: .subtitle)
        subtitle.numberOfLines = 0
        
        stackView.addArrangedSubview(subtitle)
    }
    
    private func setupTextField() {
        let textFieldBackground = UIView()
        
        textFieldBackground.layer.cornerRadius = 6
        textFieldBackground.layer.borderWidth = 1
        textFieldBackground.layer.borderColor = UIColor.black.withAlphaComponent(0.10).cgColor
        textFieldBackground.layer.masksToBounds = true
        textFieldBackground.backgroundColor = .white
        
        stackView.addArrangedSubview(textFieldBackground)
        
        textFieldBackground.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(55)
        }
        
        let textField = PhoneNumberTextField(insets: UIEdgeInsets(top: 13.5, left: 3, bottom: 13.5, right: 10), clearButtonPadding: 0)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.withFlag = true
        textField.font = .textField
        textField.textColor = UIColor(resource: .text)
        textField.withExamplePlaceholder = true
        textField.attributedPlaceholder = NSAttributedString(string: "Enter phone number")
        
        textFieldBackground.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        self.textField = textField
    }
    
    private func setupContinueButton() {
        let button = UIButton()
        
        button.backgroundColor = UIColor(resource: .accent)
        button.titleLabel?.font = .continueButton
        button.setTitle(PhoneNumberStrings.continueButton.rawValue, for: .normal)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        self.continueButton = button
    }
    
}

extension PhoneNumberViewController {
    
    @objc func textFieldDidChange() {
        continueButton.isEnabled = textField.isValidNumber
        continueButton.alpha = textField.isValidNumber ? 1.0 : 0.25
    }
}

extension PhoneNumberViewController {
    
    @objc func didTapContinue() {
        print("Did tap continue!")
    }
}
