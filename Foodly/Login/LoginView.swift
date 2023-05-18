import UIKit
import SnapKit

class LoginView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGroupedBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .systemGroupedBackground
        setupView()
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.size.equalTo(safeAreaLayoutGuide.snp.size)
        }
        
        scrollView.addSubview(rootStackView)
        
        rootStackView.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        signUpStackView.addArrangedSubview(signUpLabel)
        signUpStackView.addArrangedSubview(signUpButton)
        
        forgetPasswordStackView.addArrangedSubview(UIView())
        forgetPasswordStackView.addArrangedSubview(forgetPasswordButton)
        
        rootStackView.addArrangedSubview(emailTextField)
        rootStackView.addArrangedSubview(passwordTextField)
        rootStackView.addArrangedSubview(forgetPasswordStackView)
        rootStackView.addArrangedSubview(loginButton)
        rootStackView.addArrangedSubview(signUpStackView)
        
        emailTextField.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        forgetPasswordStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let signUpStackView: UIStackView = {
        return UIStackView()
    }()
    
    private let forgetPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let emailTextField: FormTextField = {
        let textField = FormTextField(leadingImage: UIImage(systemName: "envelope")!)
        
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = String(localized: "view.login.textField.placeholder.email")
        
        return textField
    }()
    
    let passwordTextField: FormTextField = {
        let textField = FormTextField(leadingImage: UIImage(systemName: "lock")!)
        
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.placeholder = String(localized: "view.login.textField.placeholder.password")
        
        return textField
    }()
    
    let forgetPasswordButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = String(localized: "view.login.button.forgetPassword")
        config.baseForegroundColor = .secondaryLabel
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let loginButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = String(localized: "view.login.button.login").uppercased()
        config.cornerStyle = .large
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        
        label.text = String(localized: "view.login.label.createNewAccount")
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let signUpButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = String(localized: "view.login.button.signUp")
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}
