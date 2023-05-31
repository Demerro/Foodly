import UIKit

final class RestaurantCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RestaurantCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    func configure(name: String, location: String, badgeTitle: String, badgeColor: UIColor) {
        nameLabel.text = name
        locationLabel.text = location
        
        badgeLabel.text = badgeTitle
        badgeLabel.textColor = badgeColor
        badgeContainer.backgroundColor = badgeColor.withAlphaComponent(0.2)
    }
    
    private func setupView() {
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 15
        
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(locationLabel)
        self.addSubview(textStackView)
        
        badgeContainer.addSubview(badgeLabel)
        self.addSubview(badgeContainer)
        
        self.addConstraints([
            textStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            badgeContainer.widthAnchor.constraint(equalTo: badgeLabel.widthAnchor, constant: 20),
            badgeContainer.heightAnchor.constraint(equalTo: badgeLabel.heightAnchor, constant: 20),
            badgeContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            badgeContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            badgeLabel.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor)
        ])
    }
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let badgeContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
