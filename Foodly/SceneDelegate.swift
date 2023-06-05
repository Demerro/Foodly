import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabBarController()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func getRootController() -> UIViewController {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if !hasSeenOnboarding {
            return OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        }
        
        if Auth.auth().currentUser == nil {
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
        
        return TabBarController()
    }
}
