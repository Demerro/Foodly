import UIKit

protocol SceneFactory: AnyObject {
    func makeScene() -> UIViewController
}

final class DefaultHomeFactory: SceneFactory {
    var homeConfigurator: HomeConfigurator?
    
    func makeScene() -> UIViewController {
        let viewController = HomeViewController()
        homeConfigurator?.configure(viewController)
        return viewController
    }
}
