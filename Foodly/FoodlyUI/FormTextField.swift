import UIKit

final class FormTextField: UITextField {
    
    let leftImage: UIImage?
    
    init(leadingImage: UIImage?) {
        self.leftImage = leadingImage
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 15
        
        configureColors()
        configureLeftView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureColors() {
        backgroundColor = .secondarySystemGroupedBackground
        tintColor = UIColor(named: "AccentColor")
    }
    
    private func configureLeftView() {
        let padding = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imageView = UIImageView(frame: containerView.frame.inset(by: padding))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = leftImage
        
        containerView.addSubview(imageView)
        
        leftViewMode = .always
        leftView = containerView
    }
}
