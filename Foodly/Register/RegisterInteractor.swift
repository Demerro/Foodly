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
        if request.name.isEmpty {
            presenter?.presentRegisterFailure(String(localized: "view.register.alert.error.nameEmpty"))
            return
        }
        
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: request.email, password: request.password)
                
                let changeRequest = authResult.user.createProfileChangeRequest()
                changeRequest.displayName = request.name
                try await changeRequest.commitChanges()
                
                let response = RegisterModels.RegisterAction.Response()
                presenter?.presentRegisterSuccess(response)
            } catch {
                presenter?.presentRegisterFailure(error.localizedDescription)
            }
        }
    }
}
