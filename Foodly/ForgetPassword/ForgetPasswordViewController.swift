import UIKit

protocol ForgetPasswordDisplayLogic: AnyObject {
    func displaySuccessAlert()
    func displayErrorAlert(_ viewModel: ForgetPasswordModels.SendPasswordReset.ViewModelFailure)
}

class ForgetPasswordViewController: UIViewController {
    
    private let forgetPasswordView = ForgetPasswordView()
    
    private var interactor: ForgetPasswordBusinessLogic?
    private var router: AuthRouter?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        view = forgetPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String(localized: "viewController.forgetPassword.title")
        
        forgetPasswordView.sendButton.addAction(UIAction { [weak self] _ in
            self?.resetPassword()
        }, for: .touchUpInside)
    }
    
    private func setup() {
        let viewController = self
        let interactor = ForgetPasswordInteractor()
        let presenter = ForgetPasswordPresenter()
        let router = AuthRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    private func resetPassword() {
        let email = forgetPasswordView.emailTextField.text ?? ""
        let request = ForgetPasswordModels.SendPasswordReset.Request(email: email)
        
        let button = forgetPasswordView.sendButton
        
        UIView.animate(withDuration: 0.1, animations: {
            button.alpha = 0.5
        }) { _ in
            button.isEnabled = false
            self.interactor?.sendPasswordReset(request)
        }
    }
}

// MARK: - ForgetPasswordDisplayLogic
extension ForgetPasswordViewController: ForgetPasswordDisplayLogic {
    func displaySuccessAlert() {
        DispatchQueue.main.async {
            let title = String(localized: "view.forgetPassword.alert.title")
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: String(localized: "view.forgetPassword.alert.dismiss"), style: .default) { [weak router = self.router] _ in
                router?.pop()
            }
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            self.forgetPasswordView.sendButton.isEnabled = true
            self.forgetPasswordView.sendButton.alpha = 1
        }
    }
    
    func displayErrorAlert(_ viewModel: ForgetPasswordModels.SendPasswordReset.ViewModelFailure) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: viewModel.errorMessage, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: String(localized: "view.forgetPassword.alert.dismiss"), style: .default)
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            self.forgetPasswordView.sendButton.isEnabled = true
            self.forgetPasswordView.sendButton.alpha = 1
        }
    }
}
