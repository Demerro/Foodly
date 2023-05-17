import FirebaseAuth

protocol RegisterBusinessLogic: AnyObject {
    func registerUser(_ request: RegisterModels.RegisterAction.Request)
}

class RegisterInteractor {
    var presenter: RegisterPresenter?
}

// MARK: - RegisterBusinessLogic
extension RegisterInteractor: RegisterBusinessLogic {
    func registerUser(_ request: RegisterModels.RegisterAction.Request) {
        Auth.auth().createUser(withEmail: request.email, password: request.password) { [weak self] result, error in
            if let error = error {
                self?.presenter?.presentRegisterFailure(error.localizedDescription)
            }
            
            let response = RegisterModels.RegisterAction.Response()
            self?.presenter?.presentRegisterSuccess(response)
        }
    }
}
