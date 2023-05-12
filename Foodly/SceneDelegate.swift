import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let window = window else { return }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.window!.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            } completion: { _ in
                completion?()
            }
        } else {
            window.rootViewController = rootViewController
        }
    }
}
