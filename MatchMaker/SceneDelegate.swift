import UIKit
import MatchMakerAuthentication
import MatchMakerCore
import MatchMakerLogin
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var container: Container!
    var coordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard 
            let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        setupContainer()
        
        UINavigationController.styleMatchMaker()
        
        setupAppCoordinator()
    }
    
    private func setupAppCoordinator() {
        let navigationController = UINavigationController()
        
        let coordinator = AppCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        coordinator.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        self.coordinator = coordinator
    }
}

extension SceneDelegate {
    private func setupContainer() {
        container = Container()
        AppAssembly(container: container).asemble()
    }
}
