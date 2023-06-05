protocol ForgetPasswordPresentationLogic: AnyObject {
    func presentSendPasswordResetSuccess(_ response: ForgetPasswordModels.SendPasswordReset.Response)
    func presentSendPasswordFailure(_ errorMessage: String)
}

class ForgetPasswordPresenter {
    weak var viewController: ForgetPasswordDisplayLogic?
}

// MARK: - ForgetPasswordPresentationLogic
extension ForgetPasswordPresenter: ForgetPasswordPresentationLogic {
    func presentSendPasswordResetSuccess(_ response: ForgetPasswordModels.SendPasswordReset.Response) {
        viewController?.displaySuccessAlert()
    }
    
    func presentSendPasswordFailure(_ errorMessage: String) {
        let viewModel = ForgetPasswordModels.SendPasswordReset.ViewModelFailure(errorMessage: errorMessage)
        viewController?.displayErrorAlert(viewModel)
    }
}
