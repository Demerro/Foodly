import UIKit

protocol RegisterDisplayLogic: AnyObject {
    func makeRegisterEnabled()
    func presentErrorAlert(_ viewModel: RegisterModels.RegisterAction.ViewModelFailure)
}

class RegisterViewController: UIViewController {
    
    private let registerView = RegisterView()
    
    private var interactor: RegisterInteractor?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String(localized: "viewController.register.title")
        
        registerView.registerButton.addAction(UIAction { [weak self] _ in
            self?.registerUser()
        }, for: .touchUpInside)
    }
    
    private func setup() {
        let viewController = self
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func registerUser() {
        let email = registerView.emailTextField.text ?? ""
        let password = registerView.passwordTextField.text ?? ""
        let request = RegisterModels.RegisterAction.Request(email: email, password: password)
        
        let button = registerView.registerButton
        
        UIView.animate(withDuration: 0.1, animations: {
            button.alpha = 0.5
        }) { _ in
            button.isEnabled = false
            self.interactor?.registerUser(request)
        }
    }
    
    private func saveAuthState() {
        UserDefaults.standard.setValue(true, forKeyPath: "isLoggedIn")
    }
}

// MARK: - RegisterDisplayLogic
extension RegisterViewController: RegisterDisplayLogic {
    func makeRegisterEnabled() {
        saveAuthState()
        
        let button = registerView.registerButton
        
        button.isEnabled = true
        UIView.animate(withDuration: 0.1) {
            button.alpha = 1
        }
    }
    
    func presentErrorAlert(_ viewModel: RegisterModels.RegisterAction.ViewModelFailure) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: viewModel.errorMessage, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: String(localized: "view.register.alert.action.dismiss"), style: .default)
            alert.addAction(action)
            
            self.present(alert, animated: true)
            self.registerView.registerButton.isEnabled = true
        }
    }
}
