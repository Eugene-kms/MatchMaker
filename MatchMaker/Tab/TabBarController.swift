import UIKit
import DesignSystem
import MatchMakerAuthentication
import MatchMakerSettings
import Swinject

class TabBarController: UITabBarController {
    
    private let container: Container
    
    init(container: Container) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            settings
        ]
        
        selectedViewController = settings
    }
    
    private func setupSettings() -> UIViewController {
        
        let navContr = UINavigationController()
        
        let coordinator = SettingsCoordinator(
            navigationController: navContr,
            container: container
        )
        coordinator.start()
        
        coordinator.rootViewController.tabBarItem = Tab.settings.tabBarItem
        coordinator.rootViewController.title = Tab.settings.tabBarItem.title
                
        return navContr
    }
}
