import UIKit
import SnapKit

final class RestaurantCollectionViewCell: UICollectionViewCell {
    
    static let identifier = NSStringFromClass(RestaurantCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    func configureView(with restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        locationLabel.text = restaurant.location
        
        badgeLabel.text = restaurant.type
        badgeLabel.textColor = restaurant.color
        badgeContainer.backgroundColor = restaurant.color.withAlphaComponent(0.2)
    }
    
    private func setupView() {
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 15
        
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(locationLabel)
        self.addSubview(textStackView)
        
        badgeContainer.addSubview(badgeLabel)
        self.addSubview(badgeContainer)
        
        textStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        badgeContainer.snp.makeConstraints {
            $0.width.height.equalTo(badgeLabel).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        badgeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
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
