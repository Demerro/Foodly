import UIKit

protocol AuthRoutingLogic: AnyObject {
    func navigateToRegister()
}

final class Router {
    weak var viewController: UIViewController?
}

extension Router: AuthRoutingLogic {
    func navigateToRegister() {
        let registerViewController = RegisterViewController()
        viewController?.navigationController?.pushViewController(registerViewController, animated: true)
    }
}
