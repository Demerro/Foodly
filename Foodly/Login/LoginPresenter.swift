protocol LoginPresentationLogic: AnyObject {
    func presentLoginSuccess(_ response: LoginModels.LoginAction.Response)
    func presentLoginFailure(_ errorMessage: String)
}

class LoginPresenter {
    weak var viewController: LoginDisplayLogic?
}

extension LoginPresenter: LoginPresentationLogic {
    func presentLoginSuccess(_ response: LoginModels.LoginAction.Response) {
        viewController?.displayLoginSuccess()
    }
    
    func presentLoginFailure(_ errorMessage: String) {
        let viewModel = LoginModels.LoginAction.ViewModelFailure(errorMessage: errorMessage)
        viewController?.displayErrorAlert(viewModel)
    }
}
