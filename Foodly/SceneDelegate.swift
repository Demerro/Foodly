import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = getRootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func getRootViewController() -> UIViewController {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        return hasSeenOnboarding ? LoginViewController() : OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
}
