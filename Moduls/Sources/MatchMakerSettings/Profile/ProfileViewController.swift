import UIKit
import SnapKit
import DesignSystem

public final class ProfileViewController: UIViewController {
    
    enum Row: Int, CaseIterable {
        case profilePicture
        case name
        case location
    }
    
    private weak var tableView: UITableView!
    
    let viewModel = ProfileViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        
        navigationItem.setMatchMakerTitle("Profile")
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfilePictureCell.self, forCellReuseIdentifier: ProfilePictureCell.identifier)
    }
}

extension ProfileViewController {
    
    private func setupUI() {
        view.backgroundColor = .background
        
        setupTableView()
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView = tableView
        tableView.contentInset = UIEdgeInsets(top: 27, left: 0, bottom: 0, right: 0)
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.profilePicture.rawValue + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch row {
            
        case .profilePicture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePictureCell.identifier, for: indexPath) as? ProfilePictureCell else { return UITableViewCell() }
            
            if let selectedImage = viewModel.selectedImage {
                cell.configure(with: selectedImage)
            }
            
            return cell
            
        case .name, .location:
            fatalError()
            
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == Row.profilePicture.rawValue else { return }
        
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
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            viewModel.selectedImage = selectedImage
            
            tableView.reloadRows(
                at: [IndexPath(row: Row.profilePicture.rawValue, section: 0)],
                with: .automatic)
        }
        picker.dismiss(animated: true)
    }
}
