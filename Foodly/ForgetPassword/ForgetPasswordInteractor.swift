import FirebaseAuth

protocol ForgetPasswordBusinessLogic: AnyObject {
    func sendPasswordReset(_ request: ForgetPasswordModels.SendPasswordReset.Request)
}

class ForgetPasswordInteractor {
    var presenter: ForgetPasswordPresentationLogic?
}

// MARK: - ForgetPasswordBusinessLogic
extension ForgetPasswordInteractor: ForgetPasswordBusinessLogic {
    func sendPasswordReset(_ request: ForgetPasswordModels.SendPasswordReset.Request) {
        Auth.auth().sendPasswordReset(withEmail: request.email) { [weak presenter] error in
            if let error = error {
                presenter?.presentSendPasswordFailure(error.localizedDescription)
                return
            }
            
            let response = ForgetPasswordModels.SendPasswordReset.Response()
            presenter?.presentSendPasswordResetSuccess(response)
        }
    }
}
