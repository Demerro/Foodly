import FirebaseAuth
import FirebaseStorage

protocol ProfileBusinessLogic: AnyObject {
    func getUserProfileImage(_ request: ProfileModels.GetUserProfileImageAction.Request)
    func getUserName(_ request: ProfileModels.UserNameAction.Request)
    func getUserEmail(_ request: ProfileModels.UserEmailAction.Request)
    func setUserProfileImage(_ request: ProfileModels.SetUserProfileImageAction.Request)
    func logout(_ request: ProfileModels.LogoutAction.Request)
}

class ProfileInteractor {
    var presenter: ProfilePresentationLogic?
}

// MARK: - ProfileBusinessLogic
extension ProfileInteractor: ProfileBusinessLogic {
    func getUserProfileImage(_ request: ProfileModels.GetUserProfileImageAction.Request) {
        guard let imageURL = Auth.auth().currentUser?.photoURL else { return }
        let response = ProfileModels.GetUserProfileImageAction.Response(imageURL: imageURL)
        
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
    
    func setUserProfileImage(_ request: ProfileModels.SetUserProfileImageAction.Request) {
        guard let jpegData = request.image.jpegData(compressionQuality: 0.5) else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        let reference = Storage.storage().reference().child("profileImageURLs").child("\(currentUser.uid).jpeg")
        
        Task {
            do {
                let _ = try await reference.putDataAsync(jpegData)
                
                let changeRequest = currentUser.createProfileChangeRequest()
                changeRequest.photoURL = try await reference.downloadURL()
                try await changeRequest.commitChanges()
            } catch {
                print(error)
            }
        }
    }
    
    func logout(_ request: ProfileModels.LogoutAction.Request) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error during sign out. \(error)")
        }
        
        let response = ProfileModels.LogoutAction.Response()
        presenter?.presentLogout(response)
    }
}
