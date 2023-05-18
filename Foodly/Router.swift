import UIKit

protocol AuthRoutingLogic: AnyObject {
    func navigateToRegister()
    func navigateToForgetPassword()
}

final class Router {
    weak var viewController: UIViewController?
}

// MARK: - AuthRoutingLogic
extension Router: AuthRoutingLogic {
    func navigateToRegister() {
        let registerViewController = RegisterViewController()
        viewController?.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func navigateToForgetPassword() {
        let forgetPasswordViewController = ForgetPasswordViewController()
        viewController?.navigationController?.pushViewController(forgetPasswordViewController, animated: true)
    }
}
