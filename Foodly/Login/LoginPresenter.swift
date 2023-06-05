protocol LoginPresentationLogic: AnyObject {
    func presentLoginSuccess(_ response: LoginModels.LoginAction.Response)
    func presentLoginError(message: String)
}

class LoginPresenter {
    weak var viewController: LoginDisplayLogic?
}

extension LoginPresenter: LoginPresentationLogic {
    func presentLoginSuccess(_ response: LoginModels.LoginAction.Response) {
        viewController?.displayLoginSuccess()
    }
    
    func presentLoginError(message: String) {
        let viewModel = LoginModels.LoginAction.ViewModelFailure(errorMessage: message)
        viewController?.displayErrorAlert(viewModel)
    }
}
