import UIKit
import SnapKit

class ForgetPasswordView: UIView {
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
        rootStackView.addArrangedSubview(cardView)
        rootStackView.addArrangedSubview(emailTextField)
        rootStackView.addArrangedSubview(sendButton)
        scrollView.addSubview(rootStackView)
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.size.equalTo(safeAreaLayoutGuide.snp.size)
        }
        
        rootStackView.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        cardView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        emailTextField.snp.makeConstraints {
            $0.width.equalToSuperview()
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
    
    private let cardView: FormCardView = {
        let cardView = FormCardView()
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.title = String(localized: "view.forgetPassword.cardView.email.title")
        cardView.subtitle = String(localized: "view.forgetPassword.cardView.email.subtitle")
        cardView.image = UIImage(systemName: "envelope")!
        
        return cardView
    }()
    
    let emailTextField: FormTextField = {
        let textField = FormTextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = UIImage(systemName: "envelope")!
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = String(localized: "view.forgetPassword.textField")
        
        return textField
    }()
    
    let sendButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = String(localized: "view.forgetPassword.button.next").uppercased()
        config.cornerStyle = .large
        config.buttonSize = .large
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}
