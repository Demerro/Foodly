import FirebaseAuth

protocol ProfileBusinessLogic: AnyObject {
    func getUserProfileImage(_ request: ProfileModels.UserProfileImageAction.Request)
    func getUserName(_ request: ProfileModels.UserNameAction.Request)
    func getUserEmail(_ request: ProfileModels.UserEmailAction.Request)
    func logout(_ request: ProfileModels.LogoutAction.Request)
}

class ProfileInteractor {
    var presenter: ProfilePresentationLogic?
}

// MARK: - ProfileBusinessLogic
extension ProfileInteractor: ProfileBusinessLogic {
    func getUserProfileImage(_ request: ProfileModels.UserProfileImageAction.Request) {
        guard let imageURL = Auth.auth().currentUser?.photoURL else { return }
        let response = ProfileModels.UserProfileImageAction.Response(imageURL: imageURL)
        
        presenter?.presentUserProfileImage(response)
    }
    
    func getUserName(_ request: ProfileModels.UserNameAction.Request) {
        guard let name = Auth.auth().currentUser?.displayName else { return }
        let response = ProfileModels.UserNameAction.Response(name: name)
        
        presenter?.presentUserName(response)
    }
    
    func getUserEmail(_ request: ProfileModels.UserEmailAction.Request) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let response = ProfileModels.UserEmailAction.Response(email: email)
        
        presenter?.presentUserEmail(response)
    }
    
    func logout(_ request: ProfileModels.LogoutAction.Request) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error during sign out.")
        }
        
        let response = ProfileModels.LogoutAction.Response()
        presenter?.presentLogout(response)
    }
}
