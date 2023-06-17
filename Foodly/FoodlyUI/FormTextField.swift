import UIKit

final class FormTextField: UITextField {
    
    var leftImage: UIImage? {
        didSet {
            configureLeftView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 15
        configureColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.cornerRadius = 15
        configureColors()
    }
    
    private func configureColors() {
        self.backgroundColor = .secondarySystemGroupedBackground
        self.tintColor = UIColor(named: "AccentColor")
    }
    
    private func configureLeftView() {
        let padding = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imageView = UIImageView(frame: containerView.frame.inset(by: padding))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = leftImage
        
        containerView.addSubview(imageView)
        
        self.leftViewMode = .always
        self.leftView = containerView
    }
}
