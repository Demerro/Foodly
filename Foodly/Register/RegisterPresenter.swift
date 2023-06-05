protocol RegisterPresentationLogic: AnyObject {
    func presentRegisterSuccess(_ response: RegisterModels.RegisterAction.Response)
    func presentRegisterFailure(_ errorMessage: String)
}

class RegisterPresenter {
    weak var viewController: RegisterViewController?
}

// MARK: - RegisterPresentationLogic
extension RegisterPresenter: RegisterPresentationLogic {
    func presentRegisterSuccess(_ response: RegisterModels.RegisterAction.Response) {
        viewController?.displayRegisterSuccess()
    }
    
    func presentRegisterFailure(_ errorMessage: String) {
        let viewModel = RegisterModels.RegisterAction.ViewModelFailure(errorMessage: errorMessage)
        viewController?.displayErrorAlert(viewModel)
    }
}
