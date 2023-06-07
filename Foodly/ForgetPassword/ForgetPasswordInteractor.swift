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
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: request.email)
                
                let response = ForgetPasswordModels.SendPasswordReset.Response()
                presenter?.presentSendPasswordResetSuccess(response)
            } catch {
                presenter?.presentSendPasswordFailure(error.localizedDescription)
            }
        }
    }
}
