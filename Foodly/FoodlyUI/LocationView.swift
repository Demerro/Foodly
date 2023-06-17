import UIKit

final class LocationView: UIView {
    
    var location: String? {
        didSet {
            locationLabel.text = location
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleImageView)

        rootStackView.addArrangedSubview(titleStackView)
        rootStackView.addArrangedSubview(locationLabel)

        addSubview(rootStackView)
    }
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "view.location.title")
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(named: "AccentColor")!
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "view.location.error")
        label.numberOfLines = 1
        return label
    }()
}
