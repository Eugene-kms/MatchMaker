import UIKit
import DesignSystem
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
        
        let settings = SettingsViewController()
        let settingsNavContr = UINavigationController(rootViewController: settings)
        settings.tabBarItem = Tab.settings.tabBarItem
        settings.title = Tab.settings.tabBarItem.title
        
        viewControllers = [
            home,
            matches,
            inbox,
            settingsNavContr]
        
        selectedViewController = settingsNavContr
    }
}
