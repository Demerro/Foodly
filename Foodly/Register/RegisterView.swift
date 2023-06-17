import UIKit

class RegisterView: UIView {
    
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
        
        rootStackView.addArrangedSubview(nameTextField)
        rootStackView.addArrangedSubview(emailTextField)
        rootStackView.addArrangedSubview(passwordTextField)
        rootStackView.addArrangedSubview(registerButton)
        
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
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
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let nameTextField: FormTextField = {
        let textField = FormTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = UIImage(systemName: "person")!
        textField.textContentType = .name
        textField.keyboardType = .namePhonePad
        textField.placeholder = String(localized: "view.register.textField.placeholder.name")
        
        return textField
    }()
    
    let emailTextField: FormTextField = {
        let textField = FormTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = UIImage(systemName: "envelope")!
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = String(localized: "view.register.textField.placeholder.email")
        
        return textField
    }()
    
    let passwordTextField: FormTextField = {
        let textField = FormTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = UIImage(systemName: "lock")!
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.placeholder = String(localized: "view.register.textField.placeholder.password")
        
        return textField
    }()
    
    let registerButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = String(localized: "view.register.button.register").uppercased()
        config.cornerStyle = .large
        config.buttonSize = .large
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}
