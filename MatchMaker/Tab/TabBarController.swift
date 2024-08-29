import UIKit
import DesignSystem
import MatchMakerAuthentication
import MatchMakerSettings

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewControllers()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        tabBar.barTintColor = .background
        tabBar.tintColor = .accent
        
        tabBar.layer.cornerRadius = 15
        tabBar.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        tabBar.layer.borderWidth = 0.7
    }
    
    private func setupViewControllers() {
        let home = UIViewController()
        home.tabBarItem = Tab.home.tabBarItem
        
        let matches = UIViewController()
        matches.tabBarItem = Tab.matches.tabBarItem
        
        let inbox = UIViewController()
        inbox.tabBarItem = Tab.inbox.tabBarItem
        
        let settings = setupSettings()
        
        viewControllers = [
            home,
            matches,
            inbox,
            settings]
        
        selectedViewController = settings
    }
    
    private func setupSettings() -> UIViewController {
        let settings = SettingsViewController()
        
        let authService = AuthServiceLive()
        let profilePictureRepository = UserProfileRepositoryLive(authService: authService)
        settings.viewModel = SettingsViewModel(
            authService: authService,
            userProfileRepository: profilePictureRepository,
            profilePictureRepository:
                ProfilePictureRepositoryLive(
                authService: authService,
                userProfileRepository: profilePictureRepository)
        )
        let settingsNavContr = UINavigationController(rootViewController: settings)
        settings.tabBarItem = Tab.settings.tabBarItem
        settings.title = Tab.settings.tabBarItem.title
        return settingsNavContr
    }
}
