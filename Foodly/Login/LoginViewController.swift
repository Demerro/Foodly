import UIKit

protocol LoginDisplayLogic: AnyObject {
    func makeLoginEnabled()
    func presentErrorAlert(message: String)
}

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    private var interactor: LoginBusinessLogic?
    
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
        
        title = String(localized: "view.login.title")
        loginView.loginButton.addAction(UIAction { [weak self] _ in
            self?.loginUser()
        }, for: .touchUpInside)
    }
    
    private func setup() {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
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
        
        let button = self.loginView.loginButton
        
        button.isEnabled = true
        UIView.animate(withDuration: 0.1) {
            button.alpha = 1
        }
    }
    
    func presentErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: String(localized: "view.login.alert.action.dismiss"), style: .default)
            alert.addAction(action)
            
            self.present(alert, animated: true)
            self.loginView.loginButton.isEnabled = true
        }
    }
}
