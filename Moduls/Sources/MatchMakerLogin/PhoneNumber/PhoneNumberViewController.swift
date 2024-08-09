import UIKit
import SnapKit
import PhoneNumberKit
import DesignSystem
import MatchMakerAuthentication
import Swinject

enum PhoneNumberStrings: String {
    case title = "Can I get those digits?"
    case subtitle = "Enter your phone number below to create your free account."
    case continueButton = "Continue"
}

public class PhoneNumberViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var textField: PhoneNumberTextField!
    private weak var continueButton: UIButton!
    
    public var viewModel: PhoneNumberViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        configureKeyboard()
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
        
        view.backgroundColor = .background
        
        setupStackView()
        setupTitle()
        setupSubtitle()
        setupTextField()
        setupContinueButton()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        
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
        title.textColor = .title
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
        subtitle.textColor = .subtitle
        subtitle.numberOfLines = 0
        
        stackView.addArrangedSubview(subtitle)
    }
    
    private func setupTextField() {
        let textFieldBackground = UIView()
        
        textFieldBackground.layer.cornerRadius = 6
        textFieldBackground.layer.masksToBounds = false
        textFieldBackground.backgroundColor = .white
        
        stackView.addArrangedSubview(textFieldBackground)
        
        textFieldBackground.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        
        textFieldBackground.layer.borderColor = UIColor.black.withAlphaComponent(0.10).cgColor
        textFieldBackground.layer.borderWidth = 1
        textFieldBackground.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        textFieldBackground.layer.shadowOffset = CGSize(width: 0, height: 7)
        textFieldBackground.layer.shadowRadius = 64
        textFieldBackground.layer.shadowPath = UIBezierPath(roundedRect: textFieldBackground.bounds, cornerRadius: textFieldBackground.layer.cornerRadius).cgPath
        textFieldBackground.layer.shadowOpacity = 1
        
        let textField = PhoneNumberTextField(insets: UIEdgeInsets(top: 13.5, left: 3, bottom: 13.5, right: 10), clearButtonPadding: 0)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.withFlag = true
        textField.font = .textField
        textField.textColor = .text
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
        button.titleLabel?.font = .continueButton
        button.titleLabel?.textColor = .white
        button.setTitle(PhoneNumberStrings.continueButton.rawValue, for: .normal)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        view.layoutIfNeeded()
        button.applyGradient(colours: [.accent, .aceentGradient])
        
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
        
        guard textField.isValidNumber, let phoneNumber = textField.text else { return }
        
        Task { [weak self] in
            do {
                try await self?.viewModel.requestOTP(with: phoneNumber)
            } catch {
                self?.showError(error.localizedDescription)
            }
        }
    }
}

//MARK: Configure Keyboard

extension PhoneNumberViewController {
    
    private func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let animationCurveRawNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNumber?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let topMargin = -endFrame.height + view.safeAreaInsets.bottom - 16
        
        continueButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(topMargin)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let animationCurveRawNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNumber?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let topMargin: CGFloat = -40
        
        continueButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(topMargin)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.view.layoutIfNeeded()
        }
    }
}

