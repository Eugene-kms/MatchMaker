import UIKit
import DesignSystem
import SnapKit

enum OTPStrings: String {
    case title = "Enter the 6 digit code."
    case subtitle = "Enter the 6 digit code sent to your device to verify your account."
    case continueButton = "Continue"
    case bottomTitle = "Didn’t get a code?"
    case resend = "Resend"
}
//OTP - One Time Password
public final class OTPViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private var textFields: [UITextField] = []
    private weak var continueButton: UIButton!
    private weak var resendButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureKeyboard()
        
        continueButton.alpha = 0.5
        
        textFields.first?.becomeFirstResponder()
    }
    
}

extension OTPViewController {
    
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
        
//        let isKeyboardHidden = endFrame.origin.y >= UIScreen.main.bounds.size.height
//        isKeyboardHidden ? -40 :
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

extension OTPViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .background
        
        setupStackView()
        setupTitle()
        setupSubtitle()
        setupOTPTextField()
        setupContinueButton()
        setupBottomTitleWithResendButton()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        self.stackView = stackView
    }
    
    private func setupTitle() {
        let title = UILabel()
        
        let attributedString = NSAttributedString(
            string: OTPStrings.title.rawValue,
            attributes: [.paragraphStyle: UIFont.title.paragraphStyle(forLineHight: 50.5)])
        
        title.attributedText = attributedString
        title.text = OTPStrings.title.rawValue
        title.font = .title
        title.textColor = .title
        title.numberOfLines = 0
        
        stackView.addArrangedSubview(title)
    }
    
    private func setupSubtitle() {
        let subtitle = UILabel()
        
        let attributedString = NSAttributedString(
            string: OTPStrings.subtitle.rawValue,
            attributes: [.paragraphStyle: UIFont.subtitle.paragraphStyle(forLineHight: 26.5)])
        
        subtitle.attributedText = attributedString
        subtitle.text = OTPStrings.subtitle.rawValue
        subtitle.font = .subtitle
        subtitle.textColor = .subtitle
        subtitle.numberOfLines = 0
        
        stackView.addArrangedSubview(subtitle)
    }
    
    private func setupOTPTextField() {
        
        var fields = [UITextField]()
        
        let fieldsStackView = UIStackView()
        fieldsStackView.axis = .horizontal
        fieldsStackView.spacing = 8
        fieldsStackView.alignment = .center
        
        for index in 0...5 {
            
            let background = GradientView()
            background.configureGradient(colours: [.accent, .aceentGradient])
            background.layer.cornerRadius = 13.4
            background.layer.masksToBounds = true
            
            let shadow = UIView()
            view.layoutIfNeeded()
            shadow.layer.shadowColor = UIColor.accent.withAlphaComponent(0.5).cgColor
            shadow.layer.shadowOffset = CGSize(width: 0, height: 7)
            shadow.layer.shadowRadius = 64
            shadow.layer.shadowPath = UIBezierPath(roundedRect: shadow.bounds, cornerRadius: shadow.layer.cornerRadius).cgPath
            shadow.layer.shadowOpacity = 1
            
            let textField = UITextField()
            textField.textAlignment = .center
            textField.textColor = .white
            textField.font = .otp
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            textField.tag = 100 + index
            
            background.addSubview(shadow)
            background.addSubview(textField)
            
            background.snp.makeConstraints { make in
                make.width.equalTo(48)
                make.height.equalTo(48)
            }
            
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            fieldsStackView.addArrangedSubview(background)
            fields.append(textField)

        }
        
        stackView.addArrangedSubview(fieldsStackView)
        
        textFields = fields
        
    }
    
    private func setupContinueButton() {
        let button = UIButton()
        
        button.backgroundColor = .accent
        
        button.titleLabel?.font = .continueButton
        button.titleLabel?.textColor = .white
        button.setTitle(OTPStrings.continueButton.rawValue, for: .normal)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-84)
        }
        
        view.layoutIfNeeded()
        button.applyGradient(colours: [.accent, .aceentGradient])
        
        self.continueButton = button
    }
    
    private func setupBottomTitleWithResendButton() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        let bottomTitle = UILabel()
        
        let attributedString = NSAttributedString(
            string: OTPStrings.bottomTitle.rawValue,
            attributes: [.paragraphStyle: UIFont.bottomTitle.paragraphStyle(forLineHight: 16)])
        
        bottomTitle.attributedText = attributedString
        bottomTitle.font = .bottomTitle
        bottomTitle.numberOfLines = 1
        bottomTitle.textColor = .subtitle
        bottomTitle.textAlignment = .center
        
        stackView.addArrangedSubview(bottomTitle)
        
        let button = UIButton()
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .resendTitle
        button.setTitle(OTPStrings.resend.rawValue, for: .normal)
        
        stackView.addArrangedSubview(button)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-1)
        }
        
        self.resendButton = button
    }
    
    
}

extension OTPViewController {
    
    @objc func didChangeText(textField: UITextField) {
        
        let index = textField.tag - 100
        let nextIndex = index + 1
        
        guard nextIndex < textFields.count else {
            print("Execute authentication")
            continueButton.alpha = 1.0
            return
        }
        
        textFields[nextIndex].becomeFirstResponder()
    }
}

extension OTPViewController {
    
    @objc func didTapContinue() {
        print("Did tap continue!")
    }
}
