import UIKit

protocol LoginRoutingLogic: AnyObject {
    func navigateToRegister()
    func navigateToForgetPassword()
}

final class LoginRouter: LoginRoutingLogic {
    
    weak var viewController: UIViewController?
    
    func navigateToRegister() {
        let registerViewController = RegisterViewController()
        self.viewController?.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func navigateToForgetPassword() {
        let forgetPasswordViewController = ForgetPasswordViewController()
        self.viewController?.navigationController?.pushViewController(forgetPasswordViewController, animated: true)
    }
}
