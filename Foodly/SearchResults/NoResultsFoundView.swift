import UIKit

final class NoResultsFoundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        [imageView, title, subtitle].forEach { [stackView] in stackView.addArrangedSubview($0) }
        addSubview(stackView)
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "NoResultsFound")!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = String(localized: "view.searchResults.noResultsFound.title")
        
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "view.searchResults.noResultsFound.subtitle")
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
}
