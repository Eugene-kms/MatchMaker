import UIKit
import DesignSystem

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewControllers()
    
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        tabBar.barTintColor = .background
        tabBar.tintColor = .accent
    }
    
    private func setupViewControllers() {
        let home = UIViewController()
        home.tabBarItem = Tab.home.tabBarItem
        
        let matches = UIViewController()
        matches.tabBarItem = Tab.matches.tabBarItem
        
        let inbox = UIViewController()
        inbox.tabBarItem = Tab.inbox.tabBarItem
        
        let settings = UIViewController()
        settings.tabBarItem = Tab.settings.tabBarItem
        
        viewControllers = [
            home,
            matches,
            inbox,
            settings]
    }
}
