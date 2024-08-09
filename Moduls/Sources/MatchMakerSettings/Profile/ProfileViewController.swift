import UIKit
import SnapKit
import DesignSystem
import MatchMakerCore

enum ProfileStrings: String {
    case title = "Profile"
    case save = "Save"
}

public final class ProfileViewController: UIViewController {
    
    private weak var tableView: UITableView!
    private weak var saveButtonContainer: UIView!
    
    var profileViewModel: ProfileViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        setupHideKeyboardGesture()
        subscribeToKeyboard()
        
        navigationItem.setMatchMakerTitle(ProfileStrings.title.rawValue)
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfilePictureCell.self, forCellReuseIdentifier: ProfilePictureCell.identifier)
        tableView.register(ProfileTextFieldCell.self, forCellReuseIdentifier: ProfileTextFieldCell.identifier)
    }
}

extension ProfileViewController {
    
    private func setupUI() {
        view.backgroundColor = .background
        
        setupTableView()
        setupSaveButton()
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView = tableView
        tableView.contentInset = UIEdgeInsets(top: 27, left: 0, bottom: 120, right: 0)
    }
    
    private func setupSaveButton() {
        let container = UIView()
        
        let lable = UILabel()
        lable.font = .saveButton
        lable.textColor = .pinkShadow
        lable.text = ProfileStrings.save.rawValue
        container.addSubview(lable)
        
        lable.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
        }
        
        let button = UIButton()
        button.setImage(UIImage(resource: .arrow), for: .normal)
        
        button.layer.figmaShadow(
            offset: CGPoint(x: 0, y: 10),
            blur: 55,
            color: .pinkShadow,
            opacity: 0.55
        )
        
        container.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.left.equalTo(lable.snp.right).offset(16)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.right.equalToSuperview().offset(-35)
        }
        
        self.saveButtonContainer = container
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSaveButton))
        container.addGestureRecognizer(tap)
    }
    
    @objc private func didTapSaveButton() {
        
        Task { [weak self] in
            do {
                try await self?.profileViewModel.save()
            } catch {
                self?.showError(error.localizedDescription)
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileViewModel.rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = profileViewModel.rows[indexPath.row]
        
        switch row {
            
        case .profilePicture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePictureCell.identifier, for: indexPath) as? ProfilePictureCell else { return UITableViewCell() }
            
            if let selectedImage = profileViewModel.selectedImage {
                cell.configure(with: selectedImage)
            } else if let url = profileViewModel.profilePictureURL {
                cell.configure(with: url)
            }
            
            cell.didTap = { [weak self] in
                self?.didTapProfilePicture()
            }
            
            return cell
            
        case .textField(let type):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldCell.identifier, for: indexPath) as? ProfileTextFieldCell else { return UITableViewCell() }
            
            cell.configure(with: profileViewModel.modelForTextFieldRow(type))
            cell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            case .profilePicture = profileViewModel.rows[indexPath.row] else { return }
        
        didTapProfilePicture()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func didTapProfilePicture() {
        let alert = UIAlertController(
            title: "Please, select option!",
            message: nil,
            preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(
            title: "Gallery",
            style: .default,
            handler: { [weak self] _ in
                self?.showImagePicker(with: .photoLibrary)}))
        
        alert.addAction(UIAlertAction(
            title: "Camera",
            style: .default,
            handler: { [weak self] _ in
                self?.showImagePicker(with: .camera)}))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showImagePicker(with sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileViewModel.selectedImage = selectedImage
            
            tableView.reloadRows(
                at: [IndexPath(row: 0, section: 0)],
                with: .automatic)
        }
        picker.dismiss(animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard
            let indexPath = tableView.indexPathForRow(at: textField.convert(textField.bounds.origin, to: tableView)) else { return }
        
        let row = profileViewModel.rows[indexPath.row]
        
        guard case let .textField(type) = row else { return }
        
        switch type {
        case .name:
            profileViewModel.fullName = textField.text ?? ""
        case .location:
            profileViewModel.location = textField.text ?? ""
        }
        
        let cell = tableView.cellForRow(at: indexPath) as? ProfileTextFieldCell
        cell?.configure(with: profileViewModel.modelForTextFieldRow(type))
    }
}

//MARK: setupKeyboard

extension ProfileViewController {
    private func setupHideKeyboardGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    private func subscribeToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let isKeyboardHidden = endFrame.origin.y >= UIScreen.main.bounds.size.height
        
        let bottonMargin = isKeyboardHidden ? 0 : -endFrame.height - 16
        
        tableView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(bottonMargin)
        }
        
        saveButtonContainer.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottonMargin - 20 + (isKeyboardHidden ? 0 : view.safeAreaInsets.bottom))
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
