protocol ProfilePresentationLogic: AnyObject {
    func presentUserProfileImage(_ response: ProfileModels.UserProfileImageAction.Response)
    func presentUserName(_ response: ProfileModels.UserNameAction.Response)
    func presentUserEmail(_ response: ProfileModels.UserEmailAction.Response)
    func presentLogout(_ response: ProfileModels.LogoutAction.Response)
}

class ProfilePresenter {
    weak var viewController: ProfileDisplayLogic?
}

// MARK: - ProfilePresentationLogic
extension ProfilePresenter: ProfilePresentationLogic {
    func presentUserProfileImage(_ response: ProfileModels.UserProfileImageAction.Response) {
        let viewModel = ProfileModels.UserProfileImageAction.ViewModel(imageURL: response.imageURL)
        viewController?.displayUserProfileImage(viewModel)
    }
    
    func presentUserName(_ response: ProfileModels.UserNameAction.Response) {
        let viewModel = ProfileModels.UserNameAction.ViewModel(name: response.name)
        viewController?.displayUserName(viewModel)
    }
    
    func presentUserEmail(_ response: ProfileModels.UserEmailAction.Response) {
        let viewModel = ProfileModels.UserEmailAction.ViewModel(email: response.email)
        viewController?.displayUserEmail(viewModel)
    }
    
    func presentLogout(_ response: ProfileModels.LogoutAction.Response) {
        let viewModel = ProfileModels.LogoutAction.ViewModel()
        viewController?.displayLogout(viewModel)
    }
}
