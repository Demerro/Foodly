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
        Task {
            do {
                try await Auth.auth().signIn(withEmail: request.email, password: request.password)
                
                let response = LoginModels.LoginAction.Response()
                presenter?.presentLoginSuccess(response)
            } catch {
                presenter?.presentLoginFailure(error.localizedDescription)
            }
        }
    }
}
