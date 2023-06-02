import FirebaseAuth

protocol LoginBusinessLogic: AnyObject {
    func loginUser(_ request: LoginModels.LoginAction.Request)
}

class LoginInteractor {
    var presenter: LoginPresentationLogic?
}

// MARK: - LoginBusinessLogic
extension LoginInteractor: LoginBusinessLogic {
    func loginUser(_ request: LoginModels.LoginAction.Request) {
        Auth.auth().signIn(withEmail: request.email, password: request.password) { [weak presenter] result, error in
            if let error = error {
                presenter?.presentLoginError(message: error.localizedDescription)
                return
            }
            
            let response = LoginModels.LoginAction.Response()
            presenter?.presentLoginSuccess(response)
        }
    }
}
