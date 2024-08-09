import UIKit
import MatchMakerAuthentication
import MatchMakerCore
import MatchMakerLogin
import Swinject

class AppCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let container: Container
    
    private var authService: AuthService {
        container.resolve(AuthService.self)!
    }
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
        
        subscribeToLogin()
        subscribeToLogout()
    }
    
    func start() {
        
        if authService.isAuthenticated {
            let controller = setupTabBar()
            navigationController.setViewControllers([controller], animated: true)
        } else {
            presentLogin()
        }
    }
    
    private func presentLogin() {
        let coordinator = PhoneNumberCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        coordinator.start()
    }
}

extension AppCoordinator {
    
    private func subscribeToLogin() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didLoginSuccessfully),
            name: Notification.Name(AppNotification.didLoginSuccessfully.rawValue),
            object: nil
        )
    }
    
    @objc private func didLoginSuccessfully() {
        navigationController.setViewControllers(
            [setupTabBar()],
            animated: true
        )
    }
    
    private func setupTabBar() -> UIViewController {
        TabBarController(container: container)
    }
}

extension AppCoordinator {
    
    private func subscribeToLogout() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didLogout),
            name: Notification.Name(AppNotification.didLogout.rawValue),
            object: nil
        )
    }
    
    @objc private func didLogout() {
        presentLogin()
    }
}
