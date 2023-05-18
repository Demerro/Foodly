import UIKit

protocol LoginDisplayLogic: AnyObject {
    func makeLoginEnabled()
    func presentErrorAlert(_ viewModel: LoginModels.LoginAction.ViewModelFailure)
}

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    private var interactor: LoginBusinessLogic?
    private var router: AuthRoutingLogic?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String(localized: "viewController.login.title")
        setupButtonActions()
    }
    
    private func setup() {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = Router()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    private func setupButtonActions() {
        loginView.loginButton.addAction(UIAction { [weak self] _ in
            self?.loginUser()
        }, for: .touchUpInside)
        
        loginView.signUpButton.addAction(UIAction { [weak self] _ in
            self?.router?.navigateToRegister()
        }, for: .touchUpInside)
        
        loginView.forgetPasswordButton.addAction(UIAction { [weak self] _ in
            self?.router?.navigateToForgetPassword()
        }, for: .touchUpInside)
    }
    
    private func loginUser() {
        let email = loginView.emailTextField.text ?? ""
        let password = loginView.passwordTextField.text ?? ""
        let request = LoginModels.LoginAction.Request(email: email, password: password)
        
        let button = loginView.loginButton
        
        UIView.animate(withDuration: 0.1, animations: {
            button.alpha = 0.5
        }) { _ in
            button.isEnabled = false
            self.interactor?.loginUser(request)
        }
    }
    
    private func saveAuthState() {
        UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
    }
}

extension LoginViewController: LoginDisplayLogic {
    func makeLoginEnabled() {
        saveAuthState()
        
        let button = loginView.loginButton
        
        button.isEnabled = true
        UIView.animate(withDuration: 0.1) {
            button.alpha = 1
        }
    }
    
    func presentErrorAlert(_ viewModel: LoginModels.LoginAction.ViewModelFailure) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: viewModel.errorMessage, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: String(localized: "view.login.alert.action.dismiss"), style: .default)
            alert.addAction(action)
            
            self.present(alert, animated: true)
            self.loginView.loginButton.isEnabled = true
        }
    }
}
