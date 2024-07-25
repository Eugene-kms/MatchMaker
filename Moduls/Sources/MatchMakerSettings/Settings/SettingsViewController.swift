import UIKit
import MatchMakerLogin
import DesignSystem
import MatchMakerCore
import SnapKit

public final class SettingsViewController: UIViewController {
    
    private weak var tableView: UITableView!
    
    private var footerView: UIView!
    
    let viewModel = SettingsViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        
        view.layoutIfNeeded()
        styleFooterButton(in: footerView)
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsHeaderCell.self, forCellReuseIdentifier: SettingsHeaderCell.identifier)
    }
}

extension SettingsViewController {
    
    private func setupUI() {
        view.backgroundColor = .background
        
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.setMatchMakerTitle("Settings")
        
        setupNavigationButton()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    private func setupNavigationButton() {
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .editIcon),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped))
        
        rightBarButtonItem.tintColor = .accent
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    @objc private func rightBarButtonTapped() {
        presentProfile()
    }
    
    private func presentProfile() {
        let controller = ProfileViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView = tableView
        self.footerView = setupTableFooter()
    }
    
    private func setupTableFooter() -> UIView {
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        let button = UIButton(type: .custom)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(334)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-37)
        }
        
        return footerView
    }
    
    @objc private func logoutButtonTapped() {
        
    }
    
    private func styleFooterButton(in footerView: UIView) {
        if let button = footerView.subviews.compactMap({ $0 as? UIButton }).first { button.styleLogoutButton() }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHeaderCell.identifier, for: indexPath) as? SettingsHeaderCell else { return UITableViewCell() }
        
        cell.configure(with: viewModel.header)
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        108
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        tableView.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 108
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentProfile()
    }
}
