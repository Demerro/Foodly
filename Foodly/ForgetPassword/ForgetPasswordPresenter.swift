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
        viewController?.presentSuccessAlert()
    }
    
    func presentSendPasswordFailure(_ errorMessage: String) {
        let viewModel = ForgetPasswordModels.SendPasswordReset.ViewModelFailure(errorMessage: errorMessage)
        viewController?.presentErrorAlert(viewModel)
    }
}
