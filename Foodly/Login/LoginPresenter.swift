import UIKit

protocol LoginPresentationLogic: AnyObject {
    func presentSuccess(_ response: LoginModels.LoginAction.Response)
    func presentError(message: String)
}

class LoginPresenter {
    weak var viewController: LoginDisplayLogic?
}

extension LoginPresenter: LoginPresentationLogic {
    func presentSuccess(_ response: LoginModels.LoginAction.Response) {
        viewController?.makeLoginEnabled()
    }
    
    func presentError(message: String) {
        let viewModel = LoginModels.LoginAction.ViewModelFailure(errorMessage: message)
        viewController?.presentErrorAlert(message: viewModel.errorMessage)
    }
}
