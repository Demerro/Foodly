final class AuthRouter: Router {
    func navigateToRegister() {
        let registerViewController = RegisterViewController()
        viewController?.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func navigateToForgetPassword() {
        let forgetPasswordViewController = ForgetPasswordViewController()
        viewController?.navigationController?.pushViewController(forgetPasswordViewController, animated: true)
    }
}
