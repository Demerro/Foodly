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
        Auth.auth().sendPasswordReset(withEmail: request.email) { [weak self] error in
            if let error = error {
                self?.presenter?.presentSendPasswordFailure(error.localizedDescription)
                return
            }
            
            let response = ForgetPasswordModels.SendPasswordReset.Response()
            self?.presenter?.presentSendPasswordResetSuccess(response)
        }
    }
}
