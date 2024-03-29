import UIKit

protocol LoginDisplayLogic: AnyObject {
    func displayLoginSuccess()
    func displayErrorAlert(_ viewModel: LoginModels.LoginAction.ViewModelFailure)
}

final class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    private var interactor: LoginBusinessLogic?
    private var router: LoginRoutingLogic?
    
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
        let router = LoginRouter()
        
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
        
        loginView.signUpButton.addAction(UIAction { [weak router] _ in
            router?.navigateToRegister()
        }, for: .touchUpInside)
        
        loginView.forgetPasswordButton.addAction(UIAction { [weak router] _ in
            router?.navigateToForgetPassword()
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
    
    private func makeLoginEnabled() {
        let button = loginView.loginButton
        
        button.isEnabled = true
        UIView.animate(withDuration: 0.1) {
            button.alpha = 1
        }
    }
}

extension LoginViewController: LoginDisplayLogic {
    func displayLoginSuccess() {
        DispatchQueue.main.async {
            self.loginView.window?.switchRootViewController(TabBarController())
            self.makeLoginEnabled()
        }
    }
    
    func displayErrorAlert(_ viewModel: LoginModels.LoginAction.ViewModelFailure) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: viewModel.errorMessage, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: String(localized: "view.login.alert.action.dismiss"), style: .default)
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            self.loginView.loginButton.isEnabled = true
            self.loginView.loginButton.alpha = 1
        }
    }
}
